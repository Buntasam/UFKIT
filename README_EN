# UFKIT — Ultimate Field Kit

**Modular** cyber tool installer for quickly provisioning any new
Linux/macOS workstation: reverse engineering, OSINT, networking, offensive, web, blue team, wordlists,
virtualization, cloud/DevSecOps, mobile — plus a complete development environment (**git, VS Code,
Node.js, Claude Code CLI**).

Interactive menu by category, actual installations (not simple `git clone`s),
automatic distribution detection and dependency management.

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

## Quick installation

```bash
git clone <ton-repo> ufkit && cd ufkit
chmod +x UFKIT.sh
sudo ./UFKIT.sh
```

> **Why sudo?** L'installation de paquets système (apt/dnf/pacman…) requiert
> les droits root. Le script détecte s'il tourne en root ou via `sudo` et s'adapte.
> Les tools utilisateur (pipx, go, cargo, clones git) s'installent dans ton `$HOME`.

---

## Requirements & troubleshooting

### System requirements

| Criterion | Minimum | Recommended |
|---------|---------|-----------|
| **Disk space** | 5 GB free | 20+ GB (Ghidra, VirtualBox, bases OSINT) |
| **RAM** | 4 GB | 8+ GB (pour conteneurs, VMs) |
| **Connection** | 1 Mbps stable | 10+ Mbps (téléchargements volumineux) |
| **OS** | Linux 4.4+, macOS 10.12+ | Ubuntu 20.04+, Fedora 32+, macOS 12+ |
| **Sudo** | (optional but recommended) | Configured sudoers access |

### Tested distributions

✅ **Fully supported:**
- Ubuntu 20.04 LTS, 22.04 LTS, 24.04 LTS (apt)
- Debian 11, 12 (apt)
- Fedora 35+ (dnf)
- Rocky Linux 8, 9 (dnf)
- Arch Linux (pacman)
- openSUSE Leap 15.4+ (zypper)
- macOS 11+ Monterey (brew)

⚠️ **Partial compatibility (essential tools OK, some are missing):**
- Alpine Linux (no support pacman/apk complet)
- Kali Linux (cyber-specialized, many pre-installed)

❌ **Not supported:**
- Native Windows 10/11 (use WSL 2: Ubuntu 20.04+ as a subsystem)

### Permissions & special groups

Certains tools nécessitent des permissions élevées ou l'adhésion à des groupes :

| Tool | Group/Permission | Fix |
|-------|------------------|-----------|
| **Docker** | `docker` group | `sudo usermod -aG docker $USER` + redémarrage session |
| **Wireshark** | `wireshark` group | `sudo usermod -aG wireshark $USER` + redémarrage session |
| **VirtualBox** | `vboxusers` group | `sudo usermod -aG vboxusers $USER` + redémarrage session |
| **aircrack-ng** | CAP_NET_ADMIN | Installe avec setcap automatiquement |
| **bettercap** | CAP_NET_ADMIN | Installe avec setcap automatiquement |

**Après `usermod -aG`, redémarre ta session :** logout + login, ou `newgrp docker`.

### Common troubleshooting

#### ❌ `sudo: command not found` or `Permission denied`
- **Cause:** Not root and sudo not found
- **Solution:** `apt install sudo` (ou équivalent), then add yourself to sudoers : `su - && usermod -aG sudo $USER`

#### ❌ `No package manager detected`
- **Cause:** Unknown distro (Alpine, musl, non-Ubuntu WSL)
- **Solution:** Installe manuellement : `apk` (Alpine), `zypper` (openSUSE), or switch to Ubuntu via WSL 2

#### ❌ `npm : command not found` after installing Claude Code
- **Cause:** npm global bin not in PATH
- **Solution:** 
  ```bash
  npm config get prefix  # Affiche le préfixe (ex: /home/user/.npm-global)
  export PATH="$(npm config get prefix)/bin:$PATH"
  echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
  ```
- **Then:** Open a new terminal, `claude --version` should work

#### ❌ `./UFKIT.sh: line XX: /lib/core.sh: No such file or directory`
- **Cause:** Launched from the wrong directory
- **Solution:** `cd /chemin/vers/ufkit && sudo ./UFKIT.sh`

#### ❌ Package error: `E: Could not open lock file`
- **Cause:** apt locked (another process, apt-daily, snapd)
- **Solution:**
  ```bash
  sudo killall apt apt-get  # kills running apt processes
  sudo rm /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock*
  sudo dpkg --configure -a
  ```
- **Puis :** Réessaie

#### ❌ Wireshark: "This could be caused by permissions on a system file"
- **Cause:** Wireshark groups/privileges not applied
- **Solution:**
  ```bash
  sudo usermod -aG wireshark $USER
  newgrp wireshark  # applies immediately
  # Ou logout/login
  ```

#### ❌ Docker: `Cannot connect to the Docker daemon`
- **Cause:** Docker group not applied or daemon not running
- **Solution:**
  ```bash
  sudo usermod -aG docker $USER
  newgrp docker
  sudo systemctl start docker  # starts the service
  docker ps  # verifies
  ```

#### ❌ Slow installation or network timeout
- **Cause :** Connection faible, miroirs de paquets loin, VPN interfère
- **Solution:**
  - Check the connection: `ping 8.8.8.8`
  - Temporarily disable the VPN if active
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

#### First use
```bash
./UFKIT.sh --list         # see all available tools
./UFKIT.sh --starter      # install essentials without menu
./UFKIT.sh                # interactive menu
```

#### Update tools
Most tools update themselves (`go install`, `cargo install`, `npm -g`, git clones).
To force a full update, rerun `./UFKIT.sh --install <tool>`.

---

## Usage

```bash
./UFKIT.sh                       # interactive menu
./UFKIT.sh --list                # list all categories and tools
./UFKIT.sh --starter             # install the "starter pack" without going through the menu
./UFKIT.sh --install nmap ffuf   # install specific tools by name
./UFKIT.sh --help                # help
```

### Install tools by name

To script workstation provisioning without going through the menu, use
`--install` (ou `-i`) followed by one or more tool names :

```bash
./UFKIT.sh --install nmap ffuf trivy sherlock
```

Les noms acceptés sont ceux affichés par `./UFKIT.sh --list` (le préfixe `i_`
est optionnel : `nmap` comme `i_nmap`). Les tools inconnus ou en échec sont
signalés, mais l'installation continue pour les suivants et un résumé s'affiche
à la fin.

### In the menu

- Enter the **number** of a category to open its submenu.
- In a submenu: a number installs a tool, **`99`** installs *everything* in the
  category, **`0`** goes back.
- From the main menu: **`S`** launches the starter pack, **`0`** exits.

### Starter pack

Cross-category selection of essentials for a new workstation:
`git`, `VS Code`, `Claude Code`, utilitaires (htop/tmux/jq/fzf…), build tools,
`nmap`, `wireshark`, `netcat`, `sherlock`, `sqlmap`, `SecLists`.

---

## Development environment (git, VS Code, Claude Code)

The **"Development environment"** category installs:

| Tool            | Method                                                        |
|------------------|---------------------------------------------------------------|
| **git**          | system package                                                |
| **GitHub CLI**   | official repository `cli.github.com`                               |
| **VS Code**      | Microsoft repository (apt/dnf), cask (brew), AUR (arch)           |
| **Node.js 20**   | NodeSource (apt/dnf) — required by Claude Code (Node ≥ 18)     |
| **Claude Code**  | `npm install -g @anthropic-ai/claude-code`                    |

After installing Claude Code, simply run:

```bash
claude          # first launch = authentication
claude --version
```

If the `claude` command cannot be found, add the npm global prefix to your `PATH`
(often `~/.npm-global/bin` or `$(npm config get prefix)/bin`).

---

## Categories & tools

| # | Category | Tools |
|---|-----------|--------|
| 1 | **Development environment** | git, GitHub CLI, VS Code, Node.js 20, Claude Code CLI |
| 2 | **System & base** | system update, net-tools, utils (htop/tmux/jq/fzf/ripgrep/bat), shells (zsh/fish), build tools |
| 3 | **Reverse engineering** | Ghidra, Cutter/rizin, radare2, GDB, GEF, binwalk, pwntools, apktool |
| 4 | **OSINT** | Sherlock, Holehe, Maigret, theHarvester, SpiderFoot, Photon, Sublist3r, recon-ng, ExifTool, GHunt |
| 5 | **Network & recon** | Wireshark, Nmap, tcpdump, masscan, netcat, RustScan, naabu, subfinder, Responder, bettercap, proxychains |
| 6 | **Offensive & cracking** | John, hashcat, Hydra, Aircrack-ng, hashid, CrackMapExec/NetExec, impacket, Metasploit, BloodHound, evil-winrm |
| 7 | **Web & API** | ffuf, gobuster, nuclei, httpx, katana, dalfox, Nikto, sqlmap, WPScan, WhatWeb, OWASP ZAP |
| 8 | **Blue team & forensics** | Volatility3, Sleuth Kit, Autopsy, YARA, ClamAV, chkrootkit, rkhunter, Lynis, Wazuh |
| 9 | **Virtualization & containers** | virt-manager+KVM, Docker, docker-compose, Vagrant, kubectl |
| 10 | **Cloud & DevSecOps** | Trivy, Grype, Syft, Kubescape, Checkov, Gitleaks, TruffleHog, Prowler, ScoutSuite |
| 11 | **Wordlists & resources** | SecLists, rockyou, paquet wordlists, FuzzDB, PayloadsAllTheThings, Assetnote |
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

The launcher sources `lib/core.sh` and then all `modules/*.sh` in alphabetical order
(hence the `NN-` numbering). Each module **self-registers** via
`register_category`, and the main menu builds itself from this registry.
**You never have to modify `UFKIT.sh`** to add content.

### Compatibility

Automatic package manager detection : **apt**, **dnf**, **pacman**,
**zypper**, **brew**. A given tool falls back to an alternative method if the package
does not exist (pipx, `go install`, `cargo install`, clone git).

---

## Extending UFKIT

### Add a tool to an existing category

Edit the relevant module: add an `i_xxx` function and a line in its `submenu`.

```bash
# in modules/40-network.sh
i_monoutil() { pkg mon-paquet; }        # or pipx_install / go_install / git_get

menu_network() {
    submenu "Network & recon" \
        ...
        "Mon outil"  i_monoutil
}
```

### Add a category

Create `modules/NN-name.sh`:

```bash
#!/usr/bin/env bash
i_truc() { pkg truc; }

menu_matruc() {
    submenu "Ma catégorie" \
        "Truc"  i_truc
}
register_category "Ma catégorie" menu_matruc
```

It automatically appears in the main menu, in the correct position according to its number.

### Available primitives (in `lib/core.sh`)

| Function | Role |
|----------|------|
| `pkg NOM…` | installe un system package (multi-distro) |
| `pipx_install PKG [nom]` | installs an isolated Python tool |
| `go_install PKG@ver [nom]` | `go install` (installs Go if needed) |
| `cargo_install PKG [nom]` | `cargo install` (installs Rust if needed) |
| `npm_global PKG [nom]` | `npm install -g` (installs Node if needed) |
| `git_get URL [dossier]` | clone/update in `$TOOLS_DIR` |
| `ensure_dep CMD [PKG]` | installs PKG if CMD is missing |
| `ensure_base / ensure_python / ensure_node / ensure_go / ensure_rust` | prerequisites |
| `has CMD` | true if the command exists |
| `run "desc" cmd…` | executes with logging, handles failure |
| `info / ok / warn / err / step` | colored output + log |

---

## Configuration

| Variable | Default | Role |
|----------|--------|------|
| `UFKIT_TOOLS_DIR` | `$HOME/ufkit-tools` | git clone directory |
| `UFKIT_LOG` | `$HOME/ufkit-install.log` | timestamped log file |

```bash
UFKIT_TOOLS_DIR=/opt/tools sudo -E ./UFKIT.sh
```

All operations are logged: in case of failure, check the indicated log.

---

## Notes & warnings

- Third-party installation scripts (Docker, Metasploit, Claude Code) download
  from their official sources; check your connection and your trust in these
  repositories.
- Some tools (Wireshark, aircrack, bettercap) require special permissions
  or a session reconnection for added groups (e.g. `docker`,
  `wireshark`).
- **Legal use only**: these tools are intended for authorized testing
  (authorized pentests, CTFs, research, defense). You are responsible for their use.

---

## License

Personal use. Adapt freely.
