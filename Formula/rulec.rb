# Written by packaging/homebrew.sh in i2y/rulec for v0.21.2; the next release replaces it.
class Rulec < Formula
  desc "Little language for business rules that proves each rule before it compiles"
  homepage "https://i2y.github.io/rulec/"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.21.2/rulec-v0.21.2-aarch64-apple-darwin.tar.gz"
      sha256 "6d3ff50c3b8b6dcddcb2b2bf074229957189fa5273e7138a569d5a4c2664945b"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.21.2/rulec-v0.21.2-x86_64-apple-darwin.tar.gz"
      sha256 "68e0c9b4dc96a9b0897422184a84c53a570da8ca551ee5ece9f7499595b79d6a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.21.2/rulec-v0.21.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3bd2e6f0175e070eb2a8747638abbad6e374f0cdc0810b30ec4e58e055a720d9"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.21.2/rulec-v0.21.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4a70cdfcfb5a2bcf0a97944a2e1c1c275a3e699b6e0a8a26af8b6e5b41249c5a"
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
