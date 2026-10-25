# AI Coding

Configuration files, agents, skills and rules for Agentic coding harnesses: Claude and gitHub Copilot.


## Installation with Claude Code

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

## Installation with GitHub Copilot 
With GitHub Copilot, create an environment variable called COPILOT_HOME, and set it to the path of the directory where settings files are stored.<br>
For example add to your shell profile (e.g. `~/.bashrc` or `~/.zshrc`):

```bash
export COPILOT_HOME=/home/user/ai-coding
```

On Windows (Cmd/batch file):

```powershell
COPILOT_HOME=C:\repo\ai-coding
```

**Hint**: if you launch Visual Studio Code from WSL, but Visual Studio Code actually runs in Windows and accesses Linux files via the Remote - SSH extension, then add the environment variable in Windows.  You can verify the path of the skills and instructions that Visual Studio Code is using.

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

# Tricks and pitfalls

## Visual Studio Code with gitHub Copilot 
### Use customizations in a monorepo
By default, VS Code only discovers customization files within your open workspace folder(s). 
Enable the setting below to also discover customizations from the parent repository. <br>
```json
{
  "chat.useCustomizationsInParentRepositories": true
}
```
( ref <a target="_blank" href="https://code.visualstudio.com/docs/agent-customization/overview#_use-customizations-in-a-monorepo">VS Code documentation</a>)
<br>




## TODO

