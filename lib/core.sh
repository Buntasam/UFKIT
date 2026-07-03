#!/usr/bin/env bash
#
# UFKIT — bibliothèque commune (lib/core.sh)
# Sourcé par le launcher. Fournit : couleurs, logging, détection plateforme,
# primitives d'installation et le registre de catégories.

# ----------------------------------------------------------------------------
# État global
# ----------------------------------------------------------------------------
export UFKIT_VERSION="3.0"
export TOOLS_DIR="${UFKIT_TOOLS_DIR:-$HOME/ufkit-tools}"
export LOG_FILE="${UFKIT_LOG:-$HOME/ufkit-install.log}"

PKG_MGR=""; PKG_INSTALL=""; PKG_UPDATE=""; SUDO=""

# Registre des catégories : indices parallèles
CAT_TITLES=()      # titre affiché
CAT_FUNCS=()       # fonction de menu associée

# ----------------------------------------------------------------------------
# Couleurs
# ----------------------------------------------------------------------------
if [[ -t 1 ]]; then
    C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
    C_RED=$'\033[31m';  C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'
    C_BLUE=$'\033[34m'; C_MAGENTA=$'\033[35m'; C_CYAN=$'\033[36m'
else
    C_RESET=""; C_BOLD=""; C_DIM=""; C_RED=""; C_GREEN=""
    C_YELLOW=""; C_BLUE=""; C_MAGENTA=""; C_CYAN=""
fi

# ----------------------------------------------------------------------------
# Logging & affichage
# ----------------------------------------------------------------------------
log()   { printf '%s [%s] %s\n' "$(date '+%F %T')" "$1" "$2" >> "$LOG_FILE"; }
info()  { printf '%s[*]%s %s\n' "$C_CYAN" "$C_RESET" "$1"; log INFO "$1"; }
ok()    { printf '%s[+]%s %s\n' "$C_GREEN" "$C_RESET" "$1"; log OK "$1"; }
warn()  { printf '%s[!]%s %s\n' "$C_YELLOW" "$C_RESET" "$1"; log WARN "$1"; }
err()   { printf '%s[x]%s %s\n' "$C_RED" "$C_RESET" "$1" >&2; log ERROR "$1"; }
step()  { printf '\n%s==>%s %s%s%s\n' "$C_MAGENTA" "$C_RESET" "$C_BOLD" "$1" "$C_RESET"; }
pause() { printf '\n%sAppuie sur Entrée pour continuer...%s' "$C_DIM" "$C_RESET"; read -r _; }

# ----------------------------------------------------------------------------
# Détection plateforme
# ----------------------------------------------------------------------------
detect_platform() {
    if [[ $EUID -ne 0 ]]; then
        if command -v sudo >/dev/null 2>&1; then SUDO="sudo"
        else warn "Pas root et pas de sudo : les installs système échoueront."; fi
    fi

    if command -v apt-get >/dev/null 2>&1; then
        PKG_MGR="apt"; PKG_UPDATE="$SUDO apt-get update"; PKG_INSTALL="$SUDO apt-get install -y"
    elif command -v dnf >/dev/null 2>&1; then
        PKG_MGR="dnf"; PKG_UPDATE="$SUDO dnf check-update || true"; PKG_INSTALL="$SUDO dnf install -y"
    elif command -v pacman >/dev/null 2>&1; then
        PKG_MGR="pacman"; PKG_UPDATE="$SUDO pacman -Sy"; PKG_INSTALL="$SUDO pacman -S --noconfirm --needed"
    elif command -v zypper >/dev/null 2>&1; then
        PKG_MGR="zypper"; PKG_UPDATE="$SUDO zypper refresh"; PKG_INSTALL="$SUDO zypper install -y"
    elif command -v brew >/dev/null 2>&1; then
        PKG_MGR="brew"; PKG_UPDATE="brew update"; PKG_INSTALL="brew install"
    else
        PKG_MGR=""; warn "Aucun gestionnaire de paquets connu détecté."
    fi
}

# ----------------------------------------------------------------------------
# Primitives d'installation
# ----------------------------------------------------------------------------
has() { command -v "$1" >/dev/null 2>&1; }

run() {
    local desc="$1"; shift
    info "$desc"; log CMD "$*"
    if "$@" >>"$LOG_FILE" 2>&1; then ok "$desc — terminé"; return 0
    else err "$desc — échec (voir $LOG_FILE)"; return 1; fi
}

pkg() {
    if [[ -z "$PKG_MGR" ]]; then err "Pas de gestionnaire de paquets : $* ignoré"; return 1; fi
    info "Installation paquet(s) : $*"; log CMD "$PKG_INSTALL $*"
    if $PKG_INSTALL "$@" >>"$LOG_FILE" 2>&1; then ok "Paquet(s) OK : $*"
    else err "Échec paquet(s) : $* (voir $LOG_FILE)"; return 1; fi
}

ensure_dep() {
    local cmd="$1" package="${2:-$1}"
    has "$cmd" && return 0
    warn "Dépendance manquante : $cmd — installation de $package"
    pkg "$package"
}

ensure_base() { ensure_dep git git; ensure_dep curl curl; ensure_dep wget wget; }

ensure_python() {
    ensure_dep python3 python3
    case "$PKG_MGR" in
        apt)    pkg python3-pip python3-venv pipx ;;
        dnf)    pkg python3-pip pipx ;;
        pacman) pkg python-pip python-pipx ;;
        zypper) pkg python3-pip ;;
        brew)   pkg pipx ;;
    esac
    has pipx && { pipx ensurepath >>"$LOG_FILE" 2>&1 || true; }
}

ensure_go() {
    has go && return 0
    case "$PKG_MGR" in
        apt|dnf|zypper|brew) pkg golang 2>/dev/null || pkg go ;;
        pacman)              pkg go ;;
    esac
}

ensure_rust() {
    has cargo && return 0
    run "Installation Rust (rustup)" bash -c \
        "curl -fsSL https://sh.rustup.rs | sh -s -- -y"
    [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
}

ensure_node() {
    # Node.js >= 18 requis (ex: Claude Code). Installe via NodeSource si trop vieux.
    if has node; then
        local major
        major="$(node -v 2>/dev/null | sed 's/^v\([0-9]*\).*/\1/')"
        [[ "${major:-0}" -ge 18 ]] && return 0
        warn "Node $(node -v) trop ancien, mise à niveau vers 20 LTS"
    fi
    case "$PKG_MGR" in
        apt)
            run "Dépôt NodeSource 20.x" bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO -E bash -"
            pkg nodejs ;;
        dnf)
            run "Dépôt NodeSource 20.x" bash -c "curl -fsSL https://rpm.nodesource.com/setup_20.x | $SUDO -E bash -"
            pkg nodejs ;;
        pacman) pkg nodejs npm ;;
        zypper) pkg nodejs20 npm20 2>/dev/null || pkg nodejs npm ;;
        brew)   pkg node ;;
        *)      warn "Node : installe manuellement pour $PKG_MGR" ;;
    esac
}

# npm_global PKG [nom] -> installe un paquet npm en global
npm_global() {
    local target="$1" name="${2:-$1}"
    ensure_node
    has npm || { err "npm indisponible, $name non installé"; return 1; }
    # Évite sudo si un préfixe npm utilisateur est configuré
    if [[ -w "$(npm config get prefix 2>/dev/null)/lib" ]] 2>/dev/null; then
        run "Installation $name (npm -g)" npm install -g "$target"
    else
        run "Installation $name (npm -g)" bash -c "$SUDO npm install -g $target"
    fi
}

pipx_install() {
    local target="$1" name="${2:-$1}"
    ensure_python
    has pipx || { err "pipx indisponible, $name non installé"; return 1; }
    run "Installation $name (pipx)" pipx install "$target"
}

git_get() {
    local url="$1" name="${2:-$(basename "$1" .git)}"
    local dest="$TOOLS_DIR/$name"
    ensure_base; mkdir -p "$TOOLS_DIR"
    if [[ -d "$dest/.git" ]]; then
        info "$name déjà cloné — mise à jour"
        (cd "$dest" && git pull --ff-only) >>"$LOG_FILE" 2>&1 \
            && ok "$name à jour" || warn "Màj impossible : $name"
    else
        run "Clonage $name -> $dest" git clone --depth 1 "$url" "$dest"
    fi
}

go_install() {
    local target="$1" name="${2:-$1}"
    ensure_go
    has go || { err "Go indisponible, $name non installé"; return 1; }
    run "Installation $name (go install)" go install "$target"
}

cargo_install() {
    local target="$1" name="${2:-$1}"
    ensure_rust
    has cargo || { err "cargo indisponible, $name non installé"; return 1; }
    run "Installation $name (cargo)" cargo install "$target"
}

# ----------------------------------------------------------------------------
# Registre de catégories (appelé par chaque module)
# ----------------------------------------------------------------------------
register_category() {
    CAT_TITLES+=("$1")
    CAT_FUNCS+=("$2")
}

# ----------------------------------------------------------------------------
# Sous-menu générique
#   submenu "Titre" label1 fn1 label2 fn2 ...
# Gère l'affichage, la saisie, "99 = tout" et "0 = retour".
# ----------------------------------------------------------------------------
submenu() {
    local title="$1"; shift
    local labels=() funcs=()
    while [[ $# -gt 0 ]]; do labels+=("$1"); funcs+=("$2"); shift 2; done

    while true; do
        show_banner
        printf '\n%s─────────── %s ───────────%s\n' "$C_BOLD" "$title" "$C_RESET"
        local i
        for i in "${!labels[@]}"; do
            printf '  %s%2d.%s %s\n' "$C_GREEN" $((i+1)) "$C_RESET" "${labels[$i]}"
        done
        printf '  %s99.%s Tout installer\n' "$C_CYAN" "$C_RESET"
        printf '  %s 0.%s Retour\n' "$C_RED" "$C_RESET"

        read -rp $'\nTon choix : ' c
        case "$c" in
            0)  return ;;
            99) for f in "${funcs[@]}"; do "$f"; done; pause ;;
            ''|*[!0-9]*) warn "Choix invalide." ; sleep 1 ;;
            *)
                if (( c >= 1 && c <= ${#funcs[@]} )); then
                    "${funcs[$((c-1))]}"; pause
                else
                    warn "Choix invalide." ; sleep 1
                fi ;;
        esac
    done
}

# ----------------------------------------------------------------------------
# Bannière
# ----------------------------------------------------------------------------
show_banner() {
    clear 2>/dev/null || true
    printf '%s%s' "$C_CYAN" "$C_BOLD"
    cat <<'BANNER'
 ╔═══════════════════════════════════════════════════════════════════════╗
 ║   _/\/\____/\/\__/\/\/\/\/\/\__/\/\____/\/\__/\/\/\/\__/\/\/\/\/\/\_   ║
 ║  _/\/\____/\/\__/\/\__________/\/\__/\/\______/\/\________/\/\_____    ║
 ║ _/\/\____/\/\__/\/\/\/\/\____/\/\/\/\________/\/\________/\/\_____     ║
 ║_/\/\____/\/\__/\/\__________/\/\__/\/\______/\/\________/\/\_____      ║
 ║___/\/\/\/\____/\/\__________/\/\____/\/\__/\/\/\/\______/\/\_____      ║
 ╚═══════════════════════════════════════════════════════════════════════╝
BANNER
    printf '%s' "$C_RESET"
    printf '   %sUltimate Field Kit v%s%s   ' "$C_DIM" "$UFKIT_VERSION" "$C_RESET"
    printf '%s[%s | %s]%s\n' "$C_DIM" "${PKG_MGR:-inconnu}" "$TOOLS_DIR" "$C_RESET"
}
