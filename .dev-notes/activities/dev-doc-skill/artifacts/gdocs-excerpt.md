# Google Docs excerpt

Source: https://support.google.com/docs/answer/9406611 and https://support.google.com/docs/answer/6033474

Kept: the two Drive paths, and the review-markup pitfall. No Google Docs plugin is configured on this machine, so this file does not describe a live plugin call.

- Upload a `.docx` to Drive. Open with Google Docs edits that Office file in place. The file stays `.docx`.
- File, Save as Google Docs, makes a Docs copy. The original `.docx` stays. Drive's upload setting "Convert uploads to Google Docs editor format" converts new uploads only.
- A Docs copy is what add-ons and Apps Script need. Office editing mode does not.
- When a file moves between Office and Docs, tracked changes become suggestions, and suggestions become tracked changes.
- This skill file is read only for a Google Docs conversion. The core Typst and Marp path does not load it.
