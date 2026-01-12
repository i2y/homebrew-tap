cask "bkstg" do
  version "0.1.4"
  sha256 "b9f6db3ad724d65d65ca9b8bb3f07c2d1ab1e8687ce122af7668f5531bf172d0"

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
