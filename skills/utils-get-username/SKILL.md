---
name: utils-get-username
description: Use it to get the name of the user running the skill.
---

To find it in Windows:
```bat
echo %USERNAME%
```

In Linux:
```bash
if command -v git >/dev/null 2>&1; then git config user.name; else whoami; fi
```
