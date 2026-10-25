# AGENTS.md

Instructions for AI coding agents working in this repository.

- Package: `dynamic_base_url_and_force_update` — https://pub.dev/packages/dynamic_base_url_and_force_update
- Git: branch `main`, remote `origin` (https://github.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate)
- Run every command from this folder (the one that contains `pubspec.yaml`).

## Publish new version

When I ask to **"publish new version"** (or "publish a new version", "release new version"), do the five steps below in order. Only stop where a step says to.

### 1. Bump the version in `pubspec.yaml`

In the root `pubspec.yaml`, add 1 to the last number of the `version:` line:

```yaml
version: 1.0.7   # before
version: 1.0.8   # after
```

- The format is always `1.0.<number>`: keep `1.0` and increment only the last number.
- Always a patch bump, even when the changelog lists BREAKING changes. Use a different version only if I give one in my request.
- Change only that line. Leave `example/pubspec.yaml` alone.

### 2. Update the date and hour in `lib/env.dart`

Set `dateLastUpdate` to the current local date and time on this computer, in the same format:

```dart
class DynamicPluginEnv {
  static const String dateLastUpdate = "2026-10-24 7:40 pm";
}
```

- Format: `yyyy-MM-dd h:mm am/pm`, 12-hour clock, no leading zero on the hour, lowercase `am`/`pm`.
- Get the value with:
  - PowerShell: `(Get-Date).ToString("yyyy-MM-dd h:mm tt", [cultureinfo]::InvariantCulture).ToLower()`
  - Git Bash: `date +"%Y-%m-%d %-I:%M %P"`
- Change only the text inside the quotes.

### 3. Write the version summary in `CHANGELOG.md`

Newest version on top, in the same style as the existing entries:

```markdown
## 1.0.8

* short summary of one change
* another change
```

- If the file starts with `## Unreleased`, rename that heading to the new version (`## Unreleased` → `## 1.0.8`) and keep its bullets.
- If there's no `## Unreleased` section, add a new `## 1.0.8` section above the previous version.
- Make sure every change since the previous release has a bullet. If I wrote notes in my request, use them. Otherwise check git:
  - `git log --oneline -S "version: <previous version>" -- pubspec.yaml` finds the previous release commit,
  - then review `git log` / `git diff` from that commit, plus uncommitted changes (`git status`, `git diff`).
- If you can't tell what changed, ask me for a one-line summary before publishing. Publishing is permanent.
- The heading must be exactly `## <new version>`. Pub warns when `CHANGELOG.md` doesn't mention the version being published.
- Don't edit older entries, and don't leave an empty `## Unreleased` above the new heading. pub.dev shows this file as it is.

### 4. Publish, and confirm even if pub reports warnings

```bash
dart pub publish
```

Pub validates the package, lists what it found under "Package validation found the following potential issue(s)", then asks something like:

```text
Package has N warnings. Do you want to publish dynamic_base_url_and_force_update 1.0.8 to https://pub.dev (y/N)?
```

- **Answer `y`.** Warnings don't block publishing. Confirm anyway.
- Warnings that are expected in this repo:
  - checked-in files modified in git (the files you just edited).
- Don't make changes to silence warnings: no constraint edits, and no commit yet (that's step 5). Just confirm.
- If your terminal can't answer the prompt, run `dart pub publish --force` instead. It skips the question and uploads when there are only warnings. It still refuses on errors.

If it doesn't publish, don't go on to step 5:

- **Errors** ("Sorry, your package is missing a requirement and can't be published yet"): pub never asks y/N and nothing is uploaded. Show me the errors. Don't change code or dependencies to get around them without asking me.
- **Sign-in** (pub prints a Google sign-in link and waits): give me the link and wait while I approve it in the browser.
- **Version already exists on pub.dev:** bump to the next number, rename the new CHANGELOG heading to match, and publish again.

### 5. Commit the new version and push

Only after pub prints `Successfully uploaded …`:

```bash
git add -A
git commit -m "@ version 1.0.8"
git push
```

- Commit message: `@ version <new version>`, e.g. `@ version 1.0.8`.
- Commit everything with `git add -A`. Pub uploads the working folder, so the commit should match what was published.
- `git push` sends `main` to `origin`.
- If the push is rejected or asks for credentials, don't force-push. Show me the error.

### When it's done

Tell me:

- the new version and the date written to `lib/env.dart`,
- the CHANGELOG section that was published,
- the warnings pub reported,
- the publish result: the `Successfully uploaded …` line, or the error,
- the commit hash and whether the push succeeded.

A release edits only the `version:` line in `pubspec.yaml`, the `dateLastUpdate` value in `lib/env.dart` and the top of `CHANGELOG.md`, then commits and pushes. No other edits, no tags, no force-push.
