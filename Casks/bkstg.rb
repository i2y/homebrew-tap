cask "bkstg" do
  version "0.5.10"
  sha256 "251d7b3b743be83561b61fd00a825cca25ec854397e4956339754065ae02e558"

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
