# Written by packaging/homebrew.sh in i2y/rulec for v0.22.0; the next release replaces it.
class Rulec < Formula
  desc "Little language for business rules that proves each rule before it compiles"
  homepage "https://i2y.github.io/rulec/"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.22.0/rulec-v0.22.0-aarch64-apple-darwin.tar.gz"
      sha256 "84ab55c7c8bdfa8ded3e27b5169685b95d0ca27b65fa0ccccba3359a7c4b4f3a"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.22.0/rulec-v0.22.0-x86_64-apple-darwin.tar.gz"
      sha256 "5981a583ec090bff024852594623db96cf9a2994eadaa0789a82a9f9caf93e76"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.22.0/rulec-v0.22.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e61425d89eb7724957c93f0bfa04d8013fe45327386e5eb769a929e39f91515b"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.22.0/rulec-v0.22.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cc49d5a44f84d94ecd3bdd8e1562cd0dce4270b47013365334c29dd4a85f3f56"
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
