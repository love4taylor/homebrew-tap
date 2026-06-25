# Revert on Upstream Release Deletion

**Date:** 2026-06-26
**Status:** draft

## Problem

Upstream may delete a GitHub Release after this tap has already bumped the formula to that version. The current update script treats this as a "newer version available" and performs a forward edit — creating a confusing commit that goes backwards in version number.

## Goal

When upstream deletes a release that our formula currently references, automatically detect this and use `git revert` to roll back the formula to the latest available upstream version, preserving semantic git history.

## Design

### Detection

After fetching the latest releases from upstream:

1. Extract `cur_ver` from the current formula file (unchanged).
2. Build a set of upstream tag names from the fetched releases.
3. Determine `new_ver` from the latest matching release (unchanged).

New check: **Is `cur_ver` present in the upstream tag set?** If not, the release our formula references was deleted.

### Branching Logic

```
cur_ver == new_ver
  → exit 0 (already up-to-date, unchanged)

cur_ver in upstream_tags
  → forward update: download assets, compute SHA256, edit file, commit via GitHub API (unchanged)

cur_ver NOT in upstream_tags
  → rollback: git revert the bump commit(s) that introduced the deleted version(s)
```

### Rollback Procedure

1. `git pull origin main` — sync before operating.
2. `git log --oneline FORMULA_FILE` — get commits touching the formula.
3. Scan commits forward (newest first), collecting SHAs where:
   - The commit message matches the pattern `{type}: bump to {ver}`
   - The `{ver}` is NOT found in the current upstream tag set
   - Stop at the first commit whose `{ver}` IS found in upstream (this is the target to roll back to)
4. `git revert --no-commit <sha1> <sha2> ...` — apply all reversions into the index.
5. Construct a multi-revert commit message:

```
Revert "testing: bump to 1.14.0-alpha.35"

This reverts commit abc1234...

Revert "testing: bump to 1.14.0-alpha.34"

This reverts commit def5678...
```

6. `git commit -m "$message"` — single commit capturing all reverts.
7. `git push origin main`.

### Conflict Handling

If `git revert` encounters a conflict: `git revert --abort`, then `abort "Revert conflict in FORMULA_FILE, manual intervention needed"`.

### Non-requirements

- Normal forward upgrades (cur_ver < new_ver) remain unchanged, using the existing GitHub API commit path.
- Workflow YAML files are unchanged.
- Concurrency via `concurrency: formula-update` already prevents parallel execution.

## Scenarios

### Single deletion

```
Upstream: v1.13.13 (exists), v1.13.14 (deleted)
Repo HEAD: stable: bump to 1.13.14
Result: reverts HEAD — formula restored to 1.13.13
```

### Multiple consecutive deletions

```
Upstream: v1.14.0-alpha.33 (exists), alpha.34 (deleted), alpha.35 (deleted)
Repo HEAD: testing: bump to 1.14.0-alpha.35
Repo HEAD~1: testing: bump to 1.14.0-alpha.34
Result: reverts both — formula restored to alpha.33 in one commit
```

### Non-consecutive deletions (unlikely)

```
If HEAD is .35 (deleted), HEAD~1 is .34 (deleted), but HEAD~2 is .33 (exists):
Stop scanning at .33. Revert .34 and .35.
```

### Edge case: cur_ver not in fetched releases (pagination)

Upstream is paginated at 20 releases. If cur_ver is older than the 20 most recent releases, it won't appear in the fetched set — but this is not a deletion. Detection exits early because `cur_ver == new_ver` (the formula would already be on the latest). The deletion path only activates when a newer release was deleted, making cur_ver > new_ver, in which case both are within the recent release window.

### Stable and testing run in parallel? No.

`concurrency: formula-update` serializes them. Each runs, pulls, and pushes atomically.
