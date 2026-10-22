# Written by packaging/homebrew.sh in i2y/ritsu for v0.35.0; the next release replaces it.
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
      url "https://github.com/i2y/ritsu/releases/download/v0.35.0/ritsu-v0.35.0-aarch64-apple-darwin.tar.gz"
      sha256 "5dfaec4a81d8eb492ab7ee1d6ab03a9d881a09a2385df05ec22243f51ca8fe44"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.35.0/ritsu-v0.35.0-x86_64-apple-darwin.tar.gz"
      sha256 "6ffb9ca3f7226f6b58ab51c958a780ba4f87e93f3b33204e343ee167ae889e00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/ritsu/releases/download/v0.35.0/ritsu-v0.35.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c9f54be50978769c9559d8489acbb2a06a1b8a97f185c1d3ee1b9a189ce365c4"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.35.0/ritsu-v0.35.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8b68eebcbdba4548ccaaab31b13ccda4153d1ccb646ca4ea6d00202d5f2a201c"
    end
  end

  def install
    bin.install "ritsu"
    # one link to it for each language: called by that name, ritsu is that language's command
    %w[rulec dandori koyomi chobo geas yuen sakai sekisho kaname].each do |language|
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
    %w[rulec dandori koyomi chobo geas yuen sakai sekisho kaname].each do |language|
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
