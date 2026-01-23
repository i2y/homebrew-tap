cask "bkstg" do
  version "0.5.6"
  sha256 "46a0d37ac2904957417d82988397f308aea4be131267cea9638165425d14062a"

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
