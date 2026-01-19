cask "bkstg" do
  version "0.5.4"
  sha256 "7aa41ec6400832b61e9a64e13b0d95a3fe2458ac2cd883ca9c4810d85d845d4e"

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
