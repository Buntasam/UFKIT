# UFKIT — Ultimate Field Kit

Installateur **modulaire** d'outils cyber pour provisionner rapidement tout nouveau
poste Linux/macOS : reverse, OSINT, réseau, offensif, web, blue team, wordlists,
virtualisation, cloud/DevSecOps, mobile — plus un environnement de dev complet (**git, VS Code,
Node.js, Claude Code CLI**).

Menu interactif par catégories, installations réelles (pas de simples `git clone`),
détection automatique de la distribution et gestion des dépendances.

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

## Installation rapide

```bash
git clone https://github.com/Buntasam/UFKIT.git && cd ufkit
chmod +x UFKIT.sh
sudo ./UFKIT.sh
```

> **Pourquoi sudo ?** L'installation de paquets système (apt/dnf/pacman…) requiert
> les droits root. Le script détecte s'il tourne en root ou via `sudo` et s'adapte.
> Les outils utilisateur (pipx, go, cargo, clones git) s'installent dans ton `$HOME`.

---

## Prérequis & dépannage

### Exigences système

| Critère | Minimum | Recommandé |
|---------|---------|-----------|
| **Espace disque** | 5 GB libres | 20+ GB (Ghidra, VirtualBox, bases OSINT) |
| **RAM** | 4 GB | 8+ GB (pour conteneurs, VMs) |
| **Connexion** | 1 Mbps stable | 10+ Mbps (téléchargements volumineux) |
| **OS** | Linux 4.4+, macOS 10.12+ | Ubuntu 20.04+, Fedora 32+, macOS 12+ |
| **Sudo** | (optionnel mais recommandé) | Accès sudoers configuré |

### Distributions testées

✅ **Entièrement supportées :**
- Ubuntu 20.04 LTS, 22.04 LTS, 24.04 LTS (apt)
- Debian 11, 12 (apt)
- Fedora 35+ (dnf)
- Rocky Linux 8, 9 (dnf)
- Arch Linux (pacman)
- openSUSE Leap 15.4+ (zypper)
- macOS 11+ Monterey (brew)

⚠️ **Compatibilité partielle (outils essentiels OK, certains manquent) :**
- Alpine Linux (pas de support pacman/apk complet)
- Kali Linux (spécialisée cyber, beaucoup pré-installés)

❌ **Non supportées :**
- Windows 10/11 natif (utilise WSL 2 : Ubuntu 20.04+ en subsystème)

### Permissions & groupes spéciaux

Certains outils nécessitent des permissions élevées ou l'adhésion à des groupes :

| Outil | Groupe/Permission | Correction |
|-------|------------------|-----------|
| **Docker** | `docker` group | `sudo usermod -aG docker $USER` + redémarrage session |
| **Wireshark** | `wireshark` group | `sudo usermod -aG wireshark $USER` + redémarrage session |
| **VirtualBox** | `vboxusers` group | `sudo usermod -aG vboxusers $USER` + redémarrage session |
| **aircrack-ng** | CAP_NET_ADMIN | Installe avec setcap automatiquement |
| **bettercap** | CAP_NET_ADMIN | Installe avec setcap automatiquement |

**Après `usermod -aG`, redémarre ta session :** logout + login, ou `newgrp docker`.

### Dépannage courant

#### ❌ `sudo: command not found` ou `Permission denied`
- **Cause :** Pas root et sudo introuvable
- **Solution :** `apt install sudo` (ou équivalent), puis ajoute-toi aux sudoers : `su - && usermod -aG sudo $USER`

#### ❌ `Aucun gestionnaire de paquets détecté`
- **Cause :** Distro inconnue (Alpine, musl, WSL non Ubuntu)
- **Solution :** Installe manuellement : `apk` (Alpine), `zypper` (openSUSE), ou bascule vers Ubuntu via WSL 2

#### ❌ `npm : command not found` après installation de Claude Code
- **Cause :** npm global bin non dans PATH
- **Solution :** 
  ```bash
  npm config get prefix  # Affiche le préfixe (ex: /home/user/.npm-global)
  export PATH="$(npm config get prefix)/bin:$PATH"
  echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
  ```
- **Puis :** Relance un terminal neuf, `claude --version` devrait fonctionner

#### ❌ `./UFKIT.sh: line XX: /lib/core.sh: No such file or directory`
- **Cause :** Lancement depuis mauvais répertoire
- **Solution :** `cd /chemin/vers/ufkit && sudo ./UFKIT.sh`

#### ❌ Erreur paquet : `E: Could not open lock file`
- **Cause :** apt verrouillé (autre processus, apt-daily, snapd)
- **Solution :**
  ```bash
  sudo killall apt apt-get  # tue les apt en cours
  sudo rm /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock*
  sudo dpkg --configure -a
  ```
- **Puis :** Réessaie

#### ❌ Wireshark : "This could be caused by permissions on a system file"
- **Cause :** Groupes wireshark/privileges pas appliqués
- **Solution :**
  ```bash
  sudo usermod -aG wireshark $USER
  newgrp wireshark  # applique immédiatement
  # Ou logout/login
  ```

#### ❌ Docker : `Cannot connect to the Docker daemon`
- **Cause :** Groupe docker pas appliqué ou daemon pas lancé
- **Solution :**
  ```bash
  sudo usermod -aG docker $USER
  newgrp docker
  sudo systemctl start docker  # démarre le service
  docker ps  # vérifie
  ```

#### ❌ Installation lente ou timeout réseau
- **Cause :** Connexion faible, miroirs de paquets loin, VPN interfère
- **Solution :**
  - Vérifie la connexion : `ping 8.8.8.8`
  - Désactive le VPN temporairement si actif
  - Augmente le timeout : `sudo UFKIT_TIMEOUT=300 ./UFKIT.sh`
  - Réessaie plus tard

### Après installation

#### Configurer git
```bash
git config --global user.name "Ton Nom"
git config --global user.email "ton@email.com"
```

#### Authentifier Claude Code
```bash
claude  # premier lancement = authentification
```

#### Première utilisation
```bash
./UFKIT.sh --list         # voir tous les outils disponibles
./UFKIT.sh --starter      # installer les essentiels sans menu
./UFKIT.sh                # menu interactif
```

#### Mettre à jour les outils
La plupart des outils s'auto-mettent à jour (`go install`, `cargo install`, `npm -g`, git clones).
Pour forcer une mise à jour complète : réexécute `./UFKIT.sh --install <tool>`.

---

## Utilisation

```bash
./UFKIT.sh                       # menu interactif
./UFKIT.sh --list                # liste toutes les catégories et outils
./UFKIT.sh --starter             # installe le "starter pack" sans passer par le menu
./UFKIT.sh --install nmap ffuf   # installe des outils précis par leur nom
./UFKIT.sh --help                # aide
```

### Installer des outils par leur nom

Pour scripter le provisionnement d'un poste sans passer par le menu, utilise
`--install` (ou `-i`) suivi d'un ou plusieurs noms d'outils :

```bash
./UFKIT.sh --install nmap ffuf trivy sherlock
```

Les noms acceptés sont ceux affichés par `./UFKIT.sh --list` (le préfixe `i_`
est optionnel : `nmap` comme `i_nmap`). Les outils inconnus ou en échec sont
signalés, mais l'installation continue pour les suivants et un résumé s'affiche
à la fin.

### Dans le menu

- Tape le **numéro** d'une catégorie pour ouvrir son sous-menu.
- Dans un sous-menu : un numéro installe un outil, **`99`** installe *tout* la
  catégorie, **`0`** revient en arrière.
- Depuis le menu principal : **`S`** lance le starter pack, **`0`** quitte.

### Starter pack

Sélection transversale des essentiels pour un poste neuf :
`git`, `VS Code`, `Claude Code`, utilitaires (htop/tmux/jq/fzf…), build tools,
`nmap`, `wireshark`, `netcat`, `sherlock`, `sqlmap`, `SecLists`.

---

## Environnement de dev (git, VS Code, Claude Code)

La catégorie **« Environnement de dev »** installe :

| Outil            | Méthode                                                        |
|------------------|---------------------------------------------------------------|
| **git**          | paquet système                                                |
| **GitHub CLI**   | dépôt officiel `cli.github.com`                               |
| **VS Code**      | dépôt Microsoft (apt/dnf), cask (brew), AUR (arch)           |
| **Node.js 20**   | NodeSource (apt/dnf) — requis par Claude Code (Node ≥ 18)     |
| **Claude Code**  | `npm install -g @anthropic-ai/claude-code`                    |

Après installation de Claude Code, lance simplement :

```bash
claude          # premier lancement = authentification
claude --version
```

Si la commande `claude` est introuvable, ajoute le préfixe npm global à ton `PATH`
(souvent `~/.npm-global/bin` ou `$(npm config get prefix)/bin`).

---

## Catégories & outils

| # | Catégorie | Outils |
|---|-----------|--------|
| 1 | **Environnement de dev** | git, GitHub CLI, VS Code, Node.js 20, Claude Code CLI |
| 2 | **Système & base** | mise à jour système, net-tools, utils (htop/tmux/jq/fzf/ripgrep/bat), shells (zsh/fish), build tools |
| 3 | **Reverse engineering** | Ghidra, Cutter/rizin, radare2, GDB, GEF, binwalk, pwntools, apktool |
| 4 | **OSINT** | Sherlock, Holehe, Maigret, theHarvester, SpiderFoot, Photon, Sublist3r, recon-ng, ExifTool, GHunt |
| 5 | **Réseau & recon** | Wireshark, Nmap, tcpdump, masscan, netcat, RustScan, naabu, subfinder, Responder, bettercap, proxychains |
| 6 | **Offensif & cracking** | John, hashcat, Hydra, Aircrack-ng, hashid, CrackMapExec/NetExec, impacket, Metasploit, BloodHound, evil-winrm |
| 7 | **Web & API** | ffuf, gobuster, nuclei, httpx, katana, dalfox, Nikto, sqlmap, WPScan, WhatWeb, OWASP ZAP |
| 8 | **Blue team & forensics** | Volatility3, Sleuth Kit, Autopsy, YARA, ClamAV, chkrootkit, rkhunter, Lynis, Wazuh |
| 9 | **Virtualisation & conteneurs** | virt-manager+KVM, Docker, docker-compose, Vagrant, kubectl |
| 10 | **Cloud & DevSecOps** | Trivy, Grype, Syft, Kubescape, Checkov, Gitleaks, TruffleHog, Prowler, ScoutSuite |
| 11 | **Wordlists & ressources** | SecLists, rockyou, paquet wordlists, FuzzDB, PayloadsAllTheThings, Assetnote |
| 12 | **Mobile & sans-fil** | adb, Frida, objection, MobSF, Reaver, wifite, hcxtools, Kismet |

Liste toujours à jour via `./UFKIT.sh --list`.

---

## Architecture

```
UFKIT.sh                    launcher : charge le core + les modules, construit le menu
lib/
  core.sh                   moteur : couleurs, logs, détection distro, primitives, registre
modules/
  05-devenv.sh              Environnement de dev
  10-system.sh              Système & base
  20-reversing.sh           Reverse engineering
  30-osint.sh               OSINT
  40-network.sh             Réseau & recon
  50-offensive.sh           Offensif & cracking
  60-web.sh                 Web & API
  70-blueteam.sh            Blue team & forensics
  80-virt.sh                Virtualisation & conteneurs
  85-cloud.sh               Cloud & DevSecOps
  90-wordlists.sh           Wordlists & ressources
  95-mobile-wireless.sh     Mobile & sans-fil
```

Le launcher source `lib/core.sh` puis tous les `modules/*.sh` par ordre alphabétique
(d'où la numérotation `NN-`). Chaque module s'**auto-enregistre** via
`register_category`, et le menu principal se construit tout seul depuis ce registre.
**Tu n'as jamais à modifier `UFKIT.sh`** pour ajouter du contenu.

### Compatibilité

Détection automatique du gestionnaire de paquets : **apt**, **dnf**, **pacman**,
**zypper**, **brew**. Un même outil retombe sur une méthode alternative si le paquet
n'existe pas (pipx, `go install`, `cargo install`, clone git).

---

## Étendre UFKIT

### Ajouter un outil à une catégorie existante

Édite le module concerné : ajoute une fonction `i_xxx` et une ligne dans son `submenu`.

```bash
# dans modules/40-network.sh
i_monoutil() { pkg mon-paquet; }        # ou pipx_install / go_install / git_get

menu_network() {
    submenu "Réseau & recon" \
        ...
        "Mon outil"  i_monoutil
}
```

### Ajouter une catégorie

Crée `modules/NN-nom.sh` :

```bash
#!/usr/bin/env bash
i_truc() { pkg truc; }

menu_matruc() {
    submenu "Ma catégorie" \
        "Truc"  i_truc
}
register_category "Ma catégorie" menu_matruc
```

Elle apparaît automatiquement au menu principal, au bon rang selon son numéro.

### Primitives disponibles (dans `lib/core.sh`)

| Fonction | Rôle |
|----------|------|
| `pkg NOM…` | installe un paquet système (multi-distro) |
| `pipx_install PKG [nom]` | installe un outil Python isolé |
| `go_install PKG@ver [nom]` | `go install` (installe Go au besoin) |
| `cargo_install PKG [nom]` | `cargo install` (installe Rust au besoin) |
| `npm_global PKG [nom]` | `npm install -g` (installe Node au besoin) |
| `git_get URL [dossier]` | clone/màj dans `$TOOLS_DIR` |
| `ensure_dep CMD [PKG]` | installe PKG si CMD manque |
| `ensure_base / ensure_python / ensure_node / ensure_go / ensure_rust` | prérequis |
| `has CMD` | vrai si la commande existe |
| `run "desc" cmd…` | exécute en loggant, gère l'échec |
| `info / ok / warn / err / step` | affichage coloré + log |

---

## Configuration

| Variable | Défaut | Rôle |
|----------|--------|------|
| `UFKIT_TOOLS_DIR` | `$HOME/ufkit-tools` | dossier des clones git |
| `UFKIT_LOG` | `$HOME/ufkit-install.log` | fichier de log horodaté |

```bash
UFKIT_TOOLS_DIR=/opt/tools sudo -E ./UFKIT.sh
```

Toutes les opérations sont journalisées : en cas d'échec, consulte le log indiqué.

---

## Notes & avertissements

- Les scripts d'installation tiers (Docker, Metasploit, Claude Code) téléchargent
  depuis leurs sources officielles ; vérifie ta connexion et ta confiance envers ces
  dépôts.
- Certains outils (Wireshark, aircrack, bettercap) nécessitent des permissions
  spéciales ou une reconnexion de session pour les groupes ajoutés (ex : `docker`,
  `wireshark`).
- **Usage légal uniquement** : ces outils sont destinés à des tests autorisés
  (pentest sous mandat, CTF, recherche, défense). Tu es responsable de leur emploi.

---

## Licence

Usage personnel. Adapte librement.
