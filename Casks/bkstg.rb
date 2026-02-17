cask "bkstg" do
  version "0.5.13"
  sha256 "b888271886936a1aff36151b0c3e51e1f3cccdaa5ed9b62b5b4ca33309011b3a"

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
