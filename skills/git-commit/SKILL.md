---
name: git-commit
description: Create the message related to a git commit
---
<use-session> : if it is "true" case unsensitive, then the skill will use the current session context to generate the git commit message. 
Otherwise, the skill uses only the uncommited modifications on the repository.

**Do not edit or modify any file.**

The steps are:

* if <use-session> is true, use the session title as main source to create the commit message
* list the modified files
* list the uncommitted modifications on the repository 
* summarize the modifications in a single brief line
* issue a warning message if there are untracked files
* execute the git commit using that single brief line as message

## List the modified files
```bash
git ls-files -m
```

## List the uncommitted modifications on the repo
Execute:

```bash
git --no-pager diff
```

and capture the output.

## Summarize the modifications
Given the output of the previous step, summarize the modifications occurred in the code, into a brief one line text.
In particular, if applicable, insert the name of the main classes or files that were modified or created.
Let's call <summary> the brief one line text summary.

## Issue a warning message if there are untracked files
Warn me if there are untracked files, that can be detected with the command:
```bash
git ls-files --others --exclude-standard --full-name
```

## Execute the git commit
Given <summary>, the summary created in the previous step.
Print the proposed <summary> to the user, if, and only if, the operator agrees, then execute the following command in a terminal:
In the repository folder path, issue the command:
```bash
git add -vu ; git commit -m "<summary>"
```

