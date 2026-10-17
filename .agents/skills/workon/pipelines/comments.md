# Comments (`add-review-comments`, `remove-review-comments`)

Target level: review (`add-review-comments`) or default
(`remove-review-comments`); the editor brief loads the level rules.

1. Base = `git merge-base HEAD <base-branch>` (`<base-branch>` as the
   command resolved it: local, else `origin/`). Files = `git diff
   --name-only <base>` plus new untracked files (`git ls-files --others
   --exclude-standard`). Drop activity files, `.dev-notes/`, generated, and
   binary files. Ask the user if an untracked file looks unrelated.
2. Delete the old `comments/`. Copy each file to `comments/before/<path>`
   (the snapshot).
3. Split the files MECE into jobs (no shared file). Each prompt: target
   level, assigned files, and their hunks (`git diff -U0 <base> --
   <file>`; a new file is one hunk). Launch all editors.
4. All job reports ready → launch the verifier (file list, snapshot root,
   Setup build and test commands).
5. The parent Reads only `comments/verify.md` (`add-review-comments` /
   `remove-review-comments` steps 3–4).
