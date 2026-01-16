cask "bkstg" do
  version "0.5.2"
  sha256 "757c2f4fda65756f219c3539536cad09a1a0a5491bf8f50db4da088fa4132bb7"

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
