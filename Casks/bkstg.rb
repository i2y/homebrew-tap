cask "bkstg" do
  version "0.5.3"
  sha256 "e2ca9f5c74f3b518e271d9cba82f2d6cafc86ada2dac5861fa8bee5e0c79b6cd"

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
