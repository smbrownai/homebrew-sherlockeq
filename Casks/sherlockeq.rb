# Homebrew Cask for SherlockEQ.
#
# Lives in a personal tap repo at:
#   github.com/smbrownai/homebrew-sherlockeq/Casks/sherlockeq.rb
#
# Bumping a release:
#   1. dist/release.sh <version>   produces a signed/notarized/stapled dmg
#      and prints the sha256 + the two lines below.
#   2. Copy the printed `version` and `sha256` over the values here.
#   3. Commit and push the tap repo. `brew upgrade --cask sherlockeq`
#      picks it up on the next `brew update`.
#
# Future migration to the official homebrew-cask:
#   The DSL below is already submission-grade — `brew audit --cask --online
#   --new` passes everything except notability, and `brew style` is clean.
#   The ONE blocker is repo popularity. Homebrew's package acceptance policy
#   wants 30 forks / 30 watchers / 75 stars, and DOUBLE-PLUS that for a
#   self-submission by the author: 90 forks / 90 watchers / 225 stars.
#   As of 2026-07-24 the repo has 0 / 0 / 0, so a PR would be closed as not
#   notable. (The "repo only hosts binaries" notability exception does not
#   apply — smbrownai/SherlockEQ is the real source repo.) Repo age is fine:
#   the 30-day minimum was met 2026-07-08.
#
#   When the numbers clear: fork Homebrew/homebrew-cask, add this file as
#   Casks/s/sherlockeq.rb, re-run `brew audit --new --cask sherlockeq` +
#   `brew style --cask sherlockeq` + an install/uninstall round-trip, then
#   open the PR by hand. `brew bump-cask-pr` is for version bumps of an
#   already-accepted cask, NOT for the initial submission.

cask "sherlockeq" do
  version "1.0.0"
  sha256 "b2001b329d3c71cdc43e74157b8362fc5f5ef0dfbb9e6ed91010ee693809af64"

  url "https://github.com/smbrownai/SherlockEQ/releases/download/v#{version}/SherlockEQ-#{version}.dmg",
      verified: "github.com/smbrownai/SherlockEQ/"
  name "SherlockEQ"
  desc "Audio equalizer for personal listening preferences"
  homepage "https://snxt.ai/SherlockEQ/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app self-updates through Sparkle (SherlockEQ → Check for Updates…
  # downloads and installs on its own), so Homebrew must not reinstall over
  # it. With this set, `brew upgrade` leaves the cask alone unless --greedy.
  auto_updates true
  # Cask's :sonoma matches macOS 14.x. The app's runtime check enforces
  # 14.6 specifically (Core Audio Tap engine floor).
  depends_on macos: :sonoma

  app "SherlockEQ.app"
  # Expose the bundled `sherlockeq` command-line tool on PATH. It lives inside
  # the app (Contents/Helpers/), built + signed + notarized with the bundle by
  # dist/release.sh; Homebrew just symlinks it into its bin. Non-Homebrew users
  # get the same result with `sherlockeq install`.
  binary "#{appdir}/SherlockEQ.app/Contents/Helpers/sherlockeq"

  # `brew uninstall --zap sherlockeq` removes these alongside the .app.
  # Keep this in sync with anything the app writes under ~/Library.
  zap trash: [
    "~/Library/Application Support/SherlockEQ",
    "~/Library/Caches/com.shawnbrown.SherlockEQ",
    "~/Library/HTTPStorages/com.shawnbrown.SherlockEQ",
    "~/Library/Preferences/com.shawnbrown.SherlockEQ.plist",
    "~/Library/Saved Application State/com.shawnbrown.SherlockEQ.savedState",
  ]
end
