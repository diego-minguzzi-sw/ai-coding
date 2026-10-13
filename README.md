# AI Coding

## Installation

To change the location where Claude Code stores its configuration (skills, plugins, settings, etc.), set the `CLAUDE_CONFIG_DIR` environment variable to the directory of your choice. For example:

```bash
CLAUDE_CONFIG_DIR=/home/user/claude_config_files
```

To make it permanent, add it to your shell profile (e.g. `~/.bashrc` or `~/.zshrc`):

```bash
export CLAUDE_CONFIG_DIR=/home/user/claude_config_files
```

On Windows (PowerShell):

```powershell
setx CLAUDE_CONFIG_DIR "C:\Users\user\claude_config_files"
```

### Copy your existing configuration

Changing the variable does not move anything automatically, so Claude Code will start with an empty configuration. Copy the existing files from your current `.claude` directory (by default `~/.claude`) into the new config directory:

```bash
mkdir -p /home/user/claude_config_files
cp -r ~/.claude/. /home/user/claude_config_files/
```

On Windows (PowerShell):

```powershell
New-Item -ItemType Directory -Force C:\Users\user\claude_config_files
Copy-Item -Recurse -Force $HOME\.claude\* C:\Users\user\claude_config_files\
```

Restart your terminal and Claude Code so the new location is picked up.
