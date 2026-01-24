cask "bkstg" do
  version "0.5.8"
  sha256 "f29ac3c6745ebc5d6494703f478fe8612937b4474ccd613f7f947fde011b1742"

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
