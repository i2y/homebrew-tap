# Written by packaging/homebrew.sh in i2y/rulec for v0.21.1; the next release replaces it.
class Rulec < Formula
  desc "Little language for business rules that proves each rule before it compiles"
  homepage "https://i2y.github.io/rulec/"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.21.1/rulec-v0.21.1-aarch64-apple-darwin.tar.gz"
      sha256 "b2edc50dc3cba9c3985475387303aad473244856fd4210307e261035ed33ba56"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.21.1/rulec-v0.21.1-x86_64-apple-darwin.tar.gz"
      sha256 "2b0318dd40af094cfd5777469cb9b18112e818fa6ed2867a7c48ef379e4d3d14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.21.1/rulec-v0.21.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6eda635e76f57c930b6c64ffa6870c015d919e4eede01e092c0d26e7ce93e8bc"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.21.1/rulec-v0.21.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a6cb813e713d9a65be657f6b5f16fbe12843c2f2544b29a76a26342b9b247edf"
    end
  end

  def install
    bin.install "rulec"
  end

  test do
    assert_equal "rulec #{version}", shell_output("#{bin}/rulec --version").strip

    (testpath/"fee.rule").write <<~RULE
      rule fee v1
      description "Two zones, one fee each"

      enum zone = domestic | overseas

      inputs
        dest : zone

      outputs
        fee : money[USD, incl_tax]  round up(1USD)

      table fee
      policy unique
      | dest     | -> fee : money[USD, incl_tax] |
      | domestic | 6USD                          |
      | overseas | 16USD                         |
    RULE
    assert_match "ok fee.rule", shell_output("#{bin}/rulec check fee.rule 2>&1")

    # Without the overseas row the rule has a gap, and check has to say which input falls in it.
    (testpath/"gap.rule").write (testpath/"fee.rule").read.sub(/^\| overseas .*\n/, "")
    assert_match "dest = overseas", shell_output("#{bin}/rulec check gap.rule 2>&1", 1)
  end
end
