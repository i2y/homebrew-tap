cask "bkstg" do
  version "0.5.0"
  sha256 "bbb0c98aa4d9a9af2f5ea2e1b68cc6633bc567197065e6643d6006ffa0b0725d"

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
