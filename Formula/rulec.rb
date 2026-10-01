# Written by packaging/homebrew.sh in i2y/rulec for v0.22.1; the next release replaces it.
class Rulec < Formula
  desc "Little language for business rules that proves each rule before it compiles"
  homepage "https://i2y.github.io/rulec/"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.22.1/rulec-v0.22.1-aarch64-apple-darwin.tar.gz"
      sha256 "cd9147241d7196b0338355786cd5271ce94bd8cdb425d615920b6aae7898b232"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.22.1/rulec-v0.22.1-x86_64-apple-darwin.tar.gz"
      sha256 "be274130d6fbed4b7fba15e59e6411854aaa5434e1b28fe0830882d94f2657b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/rulec/releases/download/v0.22.1/rulec-v0.22.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d1e9b8a9faf57fa038d62244c591e0d639cb03d01dfa7d9bc28353f226503a5c"
    end
    on_intel do
      url "https://github.com/i2y/rulec/releases/download/v0.22.1/rulec-v0.22.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "13937feb5dd056877f74fd5b2db64fbca0427335741ff15fffadb869238b8553"
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
