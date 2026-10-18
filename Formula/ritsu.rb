# Written by packaging/homebrew.sh in i2y/ritsu for v0.30.0; the next release replaces it.
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
      url "https://github.com/i2y/ritsu/releases/download/v0.30.0/ritsu-v0.30.0-aarch64-apple-darwin.tar.gz"
      sha256 "4267eb32ccbe1edc5e685599e03e491139bc8989b037a1b01b90c0eb93c3b55f"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.30.0/ritsu-v0.30.0-x86_64-apple-darwin.tar.gz"
      sha256 "acec46d9e5b47a764068c511ddbc91fccb57b0037727088bb7c82218fe87ab72"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/i2y/ritsu/releases/download/v0.30.0/ritsu-v0.30.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6f981ddcab2aa7dc55c4e34980aed21045bff9e8d687ae26bab811d0686fbde4"
    end
    on_intel do
      url "https://github.com/i2y/ritsu/releases/download/v0.30.0/ritsu-v0.30.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "05b4278c6ff994f666d155c9f69f96a72e7e59f6f2d13fcc864847f0480bfd63"
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
