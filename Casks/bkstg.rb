cask "bkstg" do
  version "0.1.0"
  sha256 "04dc1bddf84fdf13c3b5b6924fc6057eb2dc5af64f99d2b0b1e69e3f8f0cc294"

  url "https://github.com/i2y/bkstg/releases/download/v#{version}/bkstg.dmg"
  name "bkstg"
  desc "Mini IDP - A serverless Internal Developer Portal using local Git repository"
  homepage "https://github.com/i2y/bkstg"

  app "bkstg.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/bkstg.app"]
  end
end
