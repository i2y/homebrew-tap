cask "bkstg" do
  version "0.5.7"
  sha256 "222add7434a5826283779d9cc03f37888cfc764472bc17a06dd711fcdff8843f"

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
