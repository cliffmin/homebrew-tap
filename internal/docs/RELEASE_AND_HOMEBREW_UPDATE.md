# VoxCompose Release and Homebrew Tap Update Flow

Last updated: 2025-09-19

This document explains how a new VoxCompose release is produced, how the Homebrew tap is updated, and how the asset is delivered via CDN to end users.

---

## TL;DR

- Tag a new version in `voxcompose`:
  - `git tag vX.Y.Z && git push origin vX.Y.Z`
- GitHub Actions builds the fat JAR and attaches it to the Release as an asset.
- Update the Homebrew tap formula with the new Release URL and sha256.
- Users run `brew update && brew upgrade voxcompose` to get the latest version.

---

## Components and Sources of Truth

- Repositories
  - VoxCompose app/release pipeline: `github.com/cliffmin/voxcompose`
  - Homebrew tap: `github.com/cliffmin/homebrew-tap`
- Key files
  - Release workflow (builds and uploads Release assets): `.github/workflows/release.yml`
  - CLI build config: `cli-java/build.gradle.kts`
  - Homebrew formula: `Formula/voxcompose.rb`
- Artifact naming
  - Release asset filename is currently tied to the Java module version (`0.1.0`) and is named `voxcompose-cli-0.1.0-all.jar`.
  - Git tags (e.g., `v0.4.0`, `v0.5.0`) denote releases; the filename can remain the same across releases.

---

## How a Release is Produced (GitHub Actions)

Trigger
- The workflow triggers when a tag matching `v*` is pushed to the `voxcompose` repository.

Build & Upload
- Sets up JDK 17 and Gradle via SDKMAN
- Builds a fat JAR from `cli-java` using the Shadow plugin
- Uploads `cli-java/build/libs/*-all.jar` to the GitHub Release for that tag

Workflow (reference)

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build-and-release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'
      - name: Install Gradle via SDKMAN
        run: |
          curl -s "https://get.sdkman.io" | bash
          source "$HOME/.sdkman/bin/sdkman-init.sh"
          sdk install gradle 8.7
          gradle -v
      - name: Build fat JAR
        run: |
          source "$HOME/.sdkman/bin/sdkman-init.sh"
          gradle -p cli-java clean shadowJar --no-daemon --stacktrace
      - name: Upload release assets
        uses: softprops/action-gh-release@v2
        with:
          files: |
            cli-java/build/libs/*-all.jar
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## Homebrew Formula and Update Path

Current formula (reference)

```ruby
class Voxcompose < Formula
  desc "Markdown refiner for speech transcripts (CLI)"
  homepage "https://github.com/cliffmin/voxcompose"
  url "https://github.com/cliffmin/voxcompose/releases/download/v0.4.0/voxcompose-cli-0.1.0-all.jar"
  sha256 "6e6f9261bb8df46a4898d432f7786ec50b6f39d48997fa48c58cea93e905e445"
  license "MIT"

  depends_on "openjdk@21"

  def install
    libexec.install "voxcompose-cli-0.1.0-all.jar"
    (bin/"voxcompose").write <<~EOS
      #!/usr/bin/env bash
      exec "#{Formula["openjdk@21"].opt_bin}/java" -jar "#{libexec}/voxcompose-cli-0.1.0-all.jar" "$@"
    EOS
    chmod 0555, (bin/"voxcompose")
  end

  test do
    output = shell_output("#{bin}/voxcompose --help 2>&1", 2)
    assert_match "model", output
  end
end
```

What changes per release?
- Only the `url` tag segment (e.g., `v0.5.0`) and the `sha256` need updating.
- The filename can remain `voxcompose-cli-0.1.0-all.jar` until the CLI module version changes.

---

## Step-by-Step: Cutting a New Release

1) Tag and push the release
- In `voxcompose`:
  ```bash
  git tag v0.5.0
  git push origin v0.5.0
  ```

2) Wait for CI to publish the Release asset
- Confirm the Release exists and the asset is attached:
  - `https://github.com/cliffmin/voxcompose/releases/tag/v0.5.0`
  - Asset path pattern:
    `https://github.com/cliffmin/voxcompose/releases/download/v0.5.0/voxcompose-cli-0.1.0-all.jar`

3) Compute the asset sha256
- Option A (streaming):
  ```bash
  curl -sL https://github.com/cliffmin/voxcompose/releases/download/v0.5.0/voxcompose-cli-0.1.0-all.jar | shasum -a 256
  ```
- Option B (download first):
  ```bash
  curl -LO https://github.com/cliffmin/voxcompose/releases/download/v0.5.0/voxcompose-cli-0.1.0-all.jar
  shasum -a 256 voxcompose-cli-0.1.0-all.jar
  ```

4) Update the tap formula
- Edit `Formula/voxcompose.rb`:
  - Update `url` to the new tag `v0.5.0` (filename unchanged unless CLI module version changes)
  - Update `sha256` with the value from step 3

5) Commit and push the tap change
```bash
git add Formula/voxcompose.rb
git commit -m "voxcompose: bump to v0.5.0"
git push
```

6) Verify (locally or on a clean machine)
```bash
brew update
brew fetch voxcompose          # Ensure the URL is reachable
brew audit --strict voxcompose # Lint the formula
brew info voxcompose           # Confirm version and URL
brew upgrade voxcompose        # Perform the upgrade
brew test voxcompose           # Run formula test (if any)
```

---

## Distribution / CDN Behavior

- The Release asset is served from GitHub’s CDN (releases.*.githubusercontent.com, backed by Fastly/AWS).
- Once the Release is published with the asset attached, the file is generally available immediately.
- Homebrew downloads directly from the Release asset URL in the formula. There is no bottle/`ghcr.io` involvement because this installs a JAR.
- Homebrew verifies the file’s integrity by matching the downloaded checksum with the formula’s `sha256`.

---

## User Update Flow

Typical user commands to get updates:
```bash
brew update
brew upgrade voxcompose
```

What happens:
- `brew update` pulls the latest tap changes.
- `brew upgrade` sees the formula version (URL) changed, fetches the new asset from GitHub’s CDN, verifies `sha256`, and installs the wrapper script that calls the JAR via `openjdk@21`.

---

## Troubleshooting

- 404 on asset URL
  - Ensure the Release is published (not a draft) and the asset is attached under the correct tag.
  - Confirm the exact tag in the URL (e.g., `v0.5.0`) and that the filename matches.

- Checksum mismatch
  - Recompute `sha256` and confirm you’re hashing the correct file/URL.
  - Watch for proxy/caching layers; download the file locally and hash that artifact.

- CI didn’t upload the asset
  - Check the `release.yml` workflow logs in the `voxcompose` repo.
  - Confirm `cli-java/build/libs/*-all.jar` exists after `shadowJar` and that `GITHUB_TOKEN` permissions are sufficient.

- Homebrew cache
  - If testing repeatedly, clear or bypass caches:
    ```bash
    brew fetch --force voxcompose
    ```

---

## Future Automation (Optional)

1) Automate tap bump via GitHub Action (voxcompose → homebrew-tap PR)
- On Release publish, compute `sha256`, open a PR to `cliffmin/homebrew-tap` updating `Formula/voxcompose.rb`.
- Benefits: removes manual steps and reduces risk of checksum mistakes.

2) Use `brew bump-formula-pr`
- From a machine with `brew` and a GitHub token configured:
  ```bash
  brew bump-formula-pr \
    --tap=cliffmin/homebrew-tap \
    --url=https://github.com/cliffmin/voxcompose/releases/download/v0.5.0/voxcompose-cli-0.1.0-all.jar \
    --sha256=<new_sha256> \
    voxcompose
  ```

3) Add a `livecheck` block to the formula
- Enables `brew livecheck voxcompose` to detect new tags automatically.
  ```ruby
  livecheck do
    url :stable
    strategy :github_latest
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
  ```

---

## Checklists

Release Day (voxcompose)
- [ ] Ensure `cli-java` builds locally
- [ ] Tag: `git tag vX.Y.Z && git push origin vX.Y.Z`
- [ ] Confirm Release asset uploaded by CI

Tap Bump (homebrew-tap)
- [ ] Compute `sha256` for the new asset
- [ ] Update `Formula/voxcompose.rb` (`url` tag and `sha256`)
- [ ] Commit and push
- [ ] `brew fetch`, `brew audit --strict`, `brew test`

Post-Release
- [ ] `brew update && brew upgrade voxcompose` on a clean machine
- [ ] Confirm wrapper script and runtime (`openjdk@21`) work as expected

---

## Appendix: Key Files

- `voxcompose/.github/workflows/release.yml` (builds and publishes Release assets)
- `voxcompose/cli-java/build.gradle.kts` (fat JAR build via Shadow plugin)
- `homebrew-tap/Formula/voxcompose.rb` (tap formula pointing to Release asset)

---

If you’d like, we can add a link to this document in the tap `README.md`, and/or implement the automation options above to streamline future releases.
