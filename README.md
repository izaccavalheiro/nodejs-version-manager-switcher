# Node.js Version Manager Switcher (nvms)

## Overview

Cross-platform Bash script to detect and manage Node.js versions across different project configurations.

## Features

- 🔍 Multi-source version detection
- 🌐 Cross-platform support
- ⚡ Lightweight Bash script
- 🚀 Automatic version installation
- 🔄 Detect Node.js version from:
  - `.nvmrc`
  - `.node-version`
  - `package.json` engines

## Prerequisites

- Bash
- curl
- **NVM (Node Version Manager) MUST be installed**
  - Install from: https://github.com/nvm-sh/nvm
  - macOS/Linux: `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash`
  - Windows: Use NVM for Windows from https://github.com/coreybutler/nvm-windows

## Quick Setup

1. Install NVM
2. Download nvms script
```bash
curl -O https://raw.githubusercontent.com/yourusername/nvms/main/nvms.sh
chmod +x nvms.sh
```

## Usage

### Detect Version
```bash
./nvms.sh
```

### Install Version
```bash
./nvms.sh -i
```

## Adding as Alias

### macOS/Linux
Add to `~/.bashrc` or `~/.bash_profile`:
```bash
alias nvms='path/to/nvms.sh'
```

### Windows (Git Bash)
Add to `~/.bash_profile`:
```bash
alias nvms='path/to/nvms.sh'
```

### PowerShell
Create function in `$PROFILE`:
```powershell
function nvms { bash path/to/nvms.sh }
```

## Troubleshooting

- Ensure executable permissions: `chmod +x nvms.sh`
- Check curl and bash are installed
- Verify version management tools (NVM, Homebrew, etc.)

## Contributing

PRs welcome. Please test across different platforms.
