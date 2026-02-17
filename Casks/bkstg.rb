cask "bkstg" do
  version "0.5.12"
  sha256 "1f9c70b2db32dfef9f6c75ac4e3a865b5a1cf5f48b0b8d61430a6bfb7335e120"

  url "https://github.com/i2y/bkstg/releases/download/v#{version}/bkstg.dmg"
  name "bkstg"
  desc "Mini IDP - A serverless Internal Developer Portal using local Git repository"
  homepage "https://github.com/i2y/bkstg"

  depends_on formula: "harfbuzz"

  app "bkstg.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/bkstg.app"]
  end
end
