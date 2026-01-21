cask "bkstg" do
  version "0.5.5"
  sha256 "dc8c14c798f34d46a5b169ea33aa255c45a770a3224c53ba56dcfbcb37c4122a"

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
