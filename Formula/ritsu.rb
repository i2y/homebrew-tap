# Written by packaging/homebrew.sh in i2y/ritsu for v0.28.0; the next release replaces it.
class Ritsu < Formula
  desc "Small languages for a system's rules, checked so every input gets one answer"
  homepage "https://github.com/i2y/ritsu"
  # ritsu's own code with the data it holds (crates/ritsu/Cargo.toml); brew's audit asks for a
  # nested license on lines of its own
  license all_of: [
    { any_of: ["MIT", "Apache-2.0"] },
    "Unicode-3.0",
    "BSD-3-Clause",
  ]

  on_macos do
    on_arm do
      url "https://github.com/i2y/ritsu/releases/download/v0.28.0/ritsu-v0.28.0-aarch64-apple-darwin.tar.gz"
      sha256 "c4194227ac1b6f772b0dca94c31a71bbe93bc93d1d02c59628e21be123aca9e9"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.28.0/ritsu-v0.28.0-x86_64-apple-darwin.tar.gz"
      sha256 "69bc2d1fef8ebdc8e7e22423242caffee2028142848012895f0f88773ad07439"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/ritsu/releases/download/v0.28.0/ritsu-v0.28.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1a999cd474cfd78fd99f82d1808d52b0c171008a946ce03ccf94ee14f32d6daf"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.28.0/ritsu-v0.28.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8858b28b90ba4a1fceb8ac85164f4e1dbff0594695773cd96ec1670e7cdc7378"
    end
  end

  def install
    bin.install "ritsu"
    # one link to it for each language: called by that name, ritsu is that language's command
    %w[rulec dandori koyomi chobo geas yuen sakai sekisho].each do |language|
      bin.install_symlink "ritsu" => language
    end
    # brew puts LICENSE-MIT and LICENSE-APACHE in the keg by their names; the notices of what the
    # binary holds from others go beside them
    prefix.install "THIRD_PARTY_NOTICES"
  end

  test do
    %w[LICENSE-MIT LICENSE-APACHE THIRD_PARTY_NOTICES].each do |file|
      assert_path_exists prefix/file
    end
    assert_equal "ritsu #{version}", shell_output("#{bin}/ritsu --version").strip
    %w[rulec dandori koyomi chobo geas yuen sakai sekisho].each do |language|
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
