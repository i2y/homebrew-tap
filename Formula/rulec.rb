# Written by packaging/homebrew.sh in i2y/rulec for v0.21.0; the next release replaces it.
class Rulec < Formula
  desc "Little language for business rules that proves each rule before it compiles"
  homepage "https://i2y.github.io/rulec/"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.21.0/rulec-v0.21.0-aarch64-apple-darwin.tar.gz"
      sha256 "032f1cf49d11c610f6fce57b69a263eca59ce45130dc1fc5b1cf78ed0b93c4d8"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.21.0/rulec-v0.21.0-x86_64-apple-darwin.tar.gz"
      sha256 "e2a2fdd094aca383598f3f1ebbcb12c8e9a537be78d13a991a333182d81bede4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.21.0/rulec-v0.21.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ecd3dac16e001ac4ecf310d9b332b21b9ec77bccbe3d97902304ad68cd73277b"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.21.0/rulec-v0.21.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "fcb5e401cc9ae99ac612f4883135bbad8137a2343a7cbb8d3f7d76a62e648d02"
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
