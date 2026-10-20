# Written by packaging/homebrew.sh in i2y/ritsu for v0.33.0; the next release replaces it.
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
      url "https://github.com/i2y/ritsu/releases/download/v0.33.0/ritsu-v0.33.0-aarch64-apple-darwin.tar.gz"
      sha256 "cfe924cc92b3e066ee3855dcbd2674d79fa0af205754ba9ba38cb47a9769a84f"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.33.0/ritsu-v0.33.0-x86_64-apple-darwin.tar.gz"
      sha256 "e7d0170f02dacacea94eeab70d5e3fed06eaee31c91a79b27da3a768c17d01c0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/ritsu/releases/download/v0.33.0/ritsu-v0.33.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "33d59fa7a16c4586e1e94390bd0e7622d1999c931bb8e08c42e68bd2bfc50de0"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.33.0/ritsu-v0.33.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e6cff69fdb7e5d32ebc12b644dcb0c94fccb83f73ad9ce6b26e20b33f1bd2f4a"
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
