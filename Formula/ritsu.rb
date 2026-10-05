# Written by packaging/homebrew.sh in i2y/ritsu for v0.23.0; the next release replaces it.
class Ritsu < Formula
  desc "Seven small languages, one toolchain: what one checks, the next can build on"
  homepage "https://github.com/i2y/ritsu"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/i2y/ritsu/releases/download/v0.23.0/ritsu-v0.23.0-aarch64-apple-darwin.tar.gz"
      sha256 "f0c23183177af08b3512ddf59a396f8f1439f0334ca96032d4e7ca0c7c2840ae"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.23.0/ritsu-v0.23.0-x86_64-apple-darwin.tar.gz"
      sha256 "8db0326048f97a4020820a81f6b3b499e1d1ccbc1bda2462a8d5612ff0569729"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/ritsu/releases/download/v0.23.0/ritsu-v0.23.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ec9e1a68aebde66c4b3d56968b85307c796e8d3872e6308d66cf87526fd1372d"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.23.0/ritsu-v0.23.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7bc054dca2d9fdd1b1c61d5daa6c1a2ec8c0c2aee4667da60a91cab90dec3ee3"
    end
  end

  def install
    bin.install "ritsu"
    # one link to it for each language: called by that name, ritsu is that language's command
    %w[rulec dandori koyomi chobo geas yuen sakai].each do |language|
      bin.install_symlink "ritsu" => language
    end
  end

  test do
    assert_equal "ritsu #{version}", shell_output("#{bin}/ritsu --version").strip
    %w[rulec dandori koyomi chobo geas yuen sakai].each do |language|
      assert_equal "#{language} #{version}", shell_output("#{bin}/#{language} --version").strip
    end

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
    # the link and the same words after ritsu are one command
    assert_match "ok fee.rule", shell_output("#{bin}/ritsu rulec check fee.rule 2>&1")

    # Without the overseas row the rule has a gap, and check has to say which input falls in it.
    (testpath/"gap.rule").write (testpath/"fee.rule").read.sub(/^\| overseas .*\n/, "")
    assert_match "dest = overseas", shell_output("#{bin}/rulec check gap.rule 2>&1", 1)
  end
end
