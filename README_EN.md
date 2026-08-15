# UFKIT — Ultimate Field Kit

**Modular** cyber tool installer for quickly provisioning any new Linux/macOS workstation: reverse engineering, OSINT, networking, offensive, web, blue team, wordlists, virtualization, cloud/DevSecOps and mobile — plus a complete development environment (**git, VS Code, Node.js, Claude Code CLI**).

Interactive menu by category, real installations (not just `git clone`s), automatic distribution detection and dependency management.

```
 ╔═══════════════════════════════════════════════════════════════════════╗
 ║   _/\/\____/\/\__/\/\/\/\/\/\__/\/\____/\/\__/\/\/\/\__/\/\/\/\/\/\_   ║
 ║  _/\/\____/\/\__/\/\__________/\/\__/\/\______/\/\________/\/\_____    ║
 ║ _/\/\____/\/\__/\/\/\/\/\____/\/\/\/\________/\/\________/\/\_____     ║
 ║_/\/\____/\/\__/\/\__________/\/\__/\/\______/\/\________/\/\_____      ║
 ║___/\/\/\/\____/\/\__________/\/\____/\/\__/\/\/\/\______/\/\_____      ║
 ╚═══════════════════════════════════════════════════════════════════════╝
```

---

## Quick install

```bash
git clone https://github.com/Buntasam/UFKIT.git ufkit && cd ufkit
chmod +x UFKIT.sh
sudo ./UFKIT.sh
```

> **Why sudo?** Installing system packages (apt/dnf/pacman…) requires root privileges.
> The script detects whether it runs as root or through `sudo` and adapts accordingly.
> User-level tools (pipx, go, cargo, git clones) are installed in your `$HOME`.

---

## Requirements & troubleshooting

### System requirements

| Requirement | Minimum | Recommended |
|---|---|---|
| **Disk space** | 5 GB free | 20+ GB (Ghidra, VirtualBox, OSINT databases) |
| **RAM** | 4 GB | 8+ GB (for containers and VMs) |
| **Connection** | 1 Mbps stable | 10+ Mbps (large downloads) |
| **OS** | Linux 4.4+, macOS 10.12+ | Ubuntu 20.04+, Fedora 32+, macOS 12+ |
| **Sudo** | Optional but recommended | Configured sudoers access |

### Tested distributions

✅ **Fully supported**

- Ubuntu 20.04 LTS, 22.04 LTS, 24.04 LTS (apt)
- Debian 11, 12 (apt)
- Fedora 35+ (dnf)
- Rocky Linux 8, 9 (dnf)
- Arch Linux (pacman)
- openSUSE Leap 15.4+ (zypper)
- macOS 11+ (brew)

⚠️ **Partial support** (essential tools work, some are missing)

- Alpine Linux (no full apk support)
- Kali Linux (cyber-focused distro, many tools already pre-installed)

❌ **Not supported**

- Native Windows 10/11 — use WSL 2 with Ubuntu 20.04+ instead

### Permissions & special groups

Some tools require elevated privileges or membership in specific groups:

| Tool | Group / permission | Fix |
|---|---|---|
| **Docker** | `docker` group | `sudo usermod -aG docker $USER`, then restart your session |
| **Wireshark** | `wireshark` group | `sudo usermod -aG wireshark $USER`, then restart your session |
| **VirtualBox** | `vboxusers` group | `sudo usermod -aG vboxusers $USER`, then restart your session |
| **aircrack-ng** | `CAP_NET_ADMIN` | Installed with `setcap` automatically |
| **bettercap** | `CAP_NET_ADMIN` | Installed with `setcap` automatically |

**After `usermod -aG`, restart your session:** log out and back in, or run `newgrp docker`.

### Common issues

#### ❌ `sudo: command not found` or `Permission denied`

- **Cause:** you are not root and sudo is not installed.
- **Fix:** `apt install sudo` (or the equivalent for your distro), then add yourself to sudoers: `su - && usermod -aG sudo $USER`.

#### ❌ `No package manager detected`

- **Cause:** unknown distribution (Alpine, musl-based, non-Ubuntu WSL).
- **Fix:** install manually with `apk` (Alpine) or `zypper` (openSUSE), or switch to Ubuntu under WSL 2.

#### ❌ `npm: command not found` after installing Claude Code

- **Cause:** the npm global bin directory is not in your `PATH`.
- **Fix:**

  ```bash
  npm config get prefix  # shows the prefix (e.g. /home/user/.npm-global)
  export PATH="$(npm config get prefix)/bin:$PATH"
  echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
  ```

- **Then:** open a new terminal — `claude --version` should work.

#### ❌ `./UFKIT.sh: line XX: /lib/core.sh: No such file or directory`

- **Cause:** the script was launched from the wrong directory.
- **Fix:** `cd /path/to/ufkit && sudo ./UFKIT.sh`.

#### ❌ Package error: `E: Could not open lock file`

- **Cause:** apt is locked by another process (apt-daily, snapd…).
- **Fix:**

  ```bash
  sudo killall apt apt-get  # kill running apt processes
  sudo rm /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock*
  sudo dpkg --configure -a
  ```

- **Then:** try again.

#### ❌ Wireshark: "This could be caused by permissions on a system file"

- **Cause:** Wireshark group privileges have not been applied.
- **Fix:**

  ```bash
  sudo usermod -aG wireshark $USER
  newgrp wireshark  # applies immediately
  # or log out and back in
  ```

#### ❌ Docker: `Cannot connect to the Docker daemon`

- **Cause:** the docker group is not applied, or the daemon is not running.
- **Fix:**

  ```bash
  sudo usermod -aG docker $USER
  newgrp docker
  sudo systemctl start docker  # start the service
  docker ps                    # verify
  ```

#### ❌ Slow installation or network timeout

- **Cause:** weak connection, distant package mirrors, or VPN interference.
- **Fix:**
  - Check connectivity: `ping 8.8.8.8`
  - Temporarily disable your VPN if one is active
  - Increase the timeout: `sudo UFKIT_TIMEOUT=300 ./UFKIT.sh`
  - Try again later

### After installation

#### Configure git

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

#### Authenticate Claude Code

```bash
claude  # first launch = authentication
```

#### First steps

```bash
./UFKIT.sh --list         # see all available tools
./UFKIT.sh --starter      # install the essentials without the menu
./UFKIT.sh                # interactive menu
```

#### Update tools

Most tools update themselves (`go install`, `cargo install`, `npm -g`, git clones).
To force a full update, run `./UFKIT.sh --install <tool>` again.

---

## Usage

```bash
./UFKIT.sh                       # interactive menu
./UFKIT.sh --list                # list all categories and tools
./UFKIT.sh --starter             # install the starter pack without the menu
./UFKIT.sh --install nmap ffuf   # install specific tools by name
./UFKIT.sh --help                # help
```

### Install tools by name

To script workstation provisioning without going through the menu, use `--install` (or `-i`) followed by one or more tool names:

```bash
./UFKIT.sh --install nmap ffuf trivy sherlock
```

Accepted names are the ones shown by `./UFKIT.sh --list` (the `i_` prefix is optional: `nmap` works just as well as `i_nmap`). Unknown or failing tools are reported, but the installation continues with the remaining ones and a summary is printed at the end.

### In the menu

- Enter the **number** of a category to open its submenu.
- In a submenu: a number installs a tool, **`99`** installs *everything* in the category, **`0`** goes back.
- From the main menu: **`S`** launches the starter pack, **`0`** exits.

### Starter pack

A cross-category selection of essentials for a new workstation:
`git`, `VS Code`, `Claude Code`, utilities (htop/tmux/jq/fzf…), build tools, `nmap`, `wireshark`, `netcat`, `sherlock`, `sqlmap`, `SecLists`.

---

## Development environment (git, VS Code, Claude Code)

The **Development environment** category installs:

| Tool | Method |
|---|---|
| **git** | system package |
| **GitHub CLI** | official `cli.github.com` repository |
| **VS Code** | Microsoft repository (apt/dnf), cask (brew), AUR (arch) |
| **Node.js 20** | NodeSource (apt/dnf) — required by Claude Code (Node ≥ 18) |
| **Claude Code** | `npm install -g @anthropic-ai/claude-code` |

Once Claude Code is installed, simply run:

```bash
claude          # first launch = authentication
claude --version
```

If the `claude` command cannot be found, add the npm global prefix to your `PATH` (often `~/.npm-global/bin` or `$(npm config get prefix)/bin`).

---

## Categories & tools

| # | Category | Tools |
|---|---|---|
| 1 | **Development environment** | git, GitHub CLI, VS Code, Node.js 20, Claude Code CLI |
| 2 | **System & base** | system update, net-tools, utilities (htop/tmux/jq/fzf/ripgrep/bat), shells (zsh/fish), build tools |
| 3 | **Reverse engineering** | Ghidra, Cutter/rizin, radare2, GDB, GEF, binwalk, pwntools, apktool |
| 4 | **OSINT** | Sherlock, Holehe, Maigret, theHarvester, SpiderFoot, Photon, Sublist3r, recon-ng, ExifTool, GHunt |
| 5 | **Network & recon** | Wireshark, Nmap, tcpdump, masscan, netcat, RustScan, naabu, subfinder, Responder, bettercap, proxychains |
| 6 | **Offensive & cracking** | John, hashcat, Hydra, Aircrack-ng, hashid, CrackMapExec/NetExec, impacket, Metasploit, BloodHound, evil-winrm |
| 7 | **Web & API** | ffuf, gobuster, nuclei, httpx, katana, dalfox, Nikto, sqlmap, WPScan, WhatWeb, OWASP ZAP |
| 8 | **Blue team & forensics** | Volatility3, Sleuth Kit, Autopsy, YARA, ClamAV, chkrootkit, rkhunter, Lynis, Wazuh |
| 9 | **Virtualization & containers** | virt-manager + KVM, Docker, docker-compose, Vagrant, kubectl |
| 10 | **Cloud & DevSecOps** | Trivy, Grype, Syft, Kubescape, Checkov, Gitleaks, TruffleHog, Prowler, ScoutSuite |
| 11 | **Wordlists & resources** | SecLists, rockyou, wordlists package, FuzzDB, PayloadsAllTheThings, Assetnote |
| 12 | **Mobile & wireless** | adb, Frida, objection, MobSF, Reaver, wifite, hcxtools, Kismet |

Always up to date via `./UFKIT.sh --list`.

---

## Architecture

```
UFKIT.sh                    launcher: loads the core + modules, builds the menu
lib/
  core.sh                   engine: colors, logs, distro detection, primitives, registry
modules/
  05-devenv.sh              Development environment
  10-system.sh              System & base
  20-reversing.sh           Reverse engineering
  30-osint.sh               OSINT
  40-network.sh             Network & recon
  50-offensive.sh           Offensive & cracking
  60-web.sh                 Web & API
  70-blueteam.sh            Blue team & forensics
  80-virt.sh                Virtualization & containers
  85-cloud.sh               Cloud & DevSecOps
  90-wordlists.sh           Wordlists & resources
  95-mobile-wireless.sh     Mobile & wireless
```

The launcher sources `lib/core.sh` and then every `modules/*.sh` in alphabetical order (hence the `NN-` numbering). Each module **self-registers** through `register_category`, and the main menu builds itself from that registry.

**You never need to modify `UFKIT.sh`** to add content.

### Compatibility

Package managers are detected automatically: **apt**, **dnf**, **pacman**, **zypper**, **brew**. When a package does not exist for a given distribution, the tool falls back to an alternative method (pipx, `go install`, `cargo install`, git clone).

---

## Extending UFKIT

### Add a tool to an existing category

Edit the relevant module: add an `i_xxx` function and a matching line in its `submenu`.

```bash
# in modules/40-network.sh
i_mytool() { pkg my-package; }        # or pipx_install / go_install / git_get

menu_network() {
    submenu "Network & recon" \
        ...
        "My tool"  i_mytool
}
```

### Add a category

Create `modules/NN-name.sh`:

```bash
#!/usr/bin/env bash

i_thing() { pkg thing; }

menu_mycategory() {
    submenu "My category" \
        "Thing"  i_thing
}

register_category "My category" menu_mycategory
```

It shows up in the main menu automatically, in the right position based on its number.

### Available primitives (in `lib/core.sh`)

| Function | Role |
|---|---|
| `pkg NAME…` | installs a system package (multi-distro) |
| `pipx_install PKG [name]` | installs an isolated Python tool |
| `go_install PKG@ver [name]` | runs `go install` (installs Go if needed) |
| `cargo_install PKG [name]` | runs `cargo install` (installs Rust if needed) |
| `npm_global PKG [name]` | runs `npm install -g` (installs Node if needed) |
| `git_get URL [dir]` | clones or updates a repo in `$TOOLS_DIR` |
| `ensure_dep CMD [PKG]` | installs PKG if CMD is missing |
| `ensure_base` / `ensure_python` / `ensure_node` / `ensure_go` / `ensure_rust` | prerequisites |
| `has CMD` | true if the command exists |
| `run "desc" cmd…` | executes with logging and failure handling |
| `info` / `ok` / `warn` / `err` / `step` | colored output + log |

---

## Configuration

| Variable | Default | Role |
|---|---|---|
| `UFKIT_TOOLS_DIR` | `$HOME/ufkit-tools` | git clone directory |
| `UFKIT_LOG` | `$HOME/ufkit-install.log` | timestamped log file |

```bash
UFKIT_TOOLS_DIR=/opt/tools sudo -E ./UFKIT.sh
```

Every operation is logged: if something fails, check the log file shown on screen.

---

## Notes & warnings

- Third-party installation scripts (Docker, Metasploit, Claude Code) download from their official sources; check your connection and your level of trust in those repositories.
- Some tools (Wireshark, aircrack-ng, bettercap) require special permissions or a session restart for newly added groups (e.g. `docker`, `wireshark`).
- **Authorized use only:** these tools are meant for legitimate testing (authorized pentests, CTFs, research, defense). You are responsible for how you use them.

---

## License

Personal use. Adapt freely.
