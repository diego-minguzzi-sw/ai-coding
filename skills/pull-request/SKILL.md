---
name: pull-request
description: Create the markdown text to submit a pull request related to a github branch.
---

Analyze the modifications that I executed in the current beanch, and create the text of the pull request, in markdown format.
Do not be verbose, prefer bullet lists. 
Rather than going into implementation details, include in the PR the modifications that affect users of the library or applications:

- interface changes
- behavioral change
- new commands added to command line tools

Use the past tense in describing the modifications, e.g. added the methods, extended the interface, etc.

If you add a bullet list, the first character of every item must be lowercase.

Do not add messages like "authored by Copilot" or any other model or harness.
