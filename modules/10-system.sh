#!/usr/bin/env bash
# Module : Système & paquets de base

sys_update() {
    step "Mise à jour du système ($PKG_MGR)"
    [[ -n "$PKG_UPDATE" ]] && eval "$PKG_UPDATE" 2>&1 | tee -a "$LOG_FILE"
    case "$PKG_MGR" in
        apt)    run "Upgrade" bash -c "$SUDO apt-get upgrade -y" ;;
        dnf)    run "Upgrade" bash -c "$SUDO dnf upgrade -y" ;;
        pacman) run "Upgrade" bash -c "$SUDO pacman -Syu --noconfirm" ;;
        zypper) run "Upgrade" bash -c "$SUDO zypper update -y" ;;
        brew)   run "Upgrade" bash -c "brew upgrade" ;;
    esac
}
i_nettools() { pkg net-tools; }
i_utils()    { pkg htop tmux jq tree unzip ripgrep fzf bat; }
i_shells()   { pkg zsh fish; }
i_build()    {
    case "$PKG_MGR" in
        apt)    pkg build-essential ;;
        dnf)    pkg gcc gcc-c++ make ;;
        pacman) pkg base-devel ;;
        *)      pkg gcc make ;;
    esac
}

menu_system() {
    submenu "Système & base" \
        "Mise à jour complète du système" sys_update \
        "net-tools"                       i_nettools \
        "Utilitaires (htop/tmux/jq/fzf…)" i_utils \
        "Shells (zsh, fish)"              i_shells \
        "Outils de compilation"           i_build
}
register_category "Système & base" menu_system
