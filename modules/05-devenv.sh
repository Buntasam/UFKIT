#!/usr/bin/env bash
# Module : Environnement de développement (git, éditeurs, Claude Code)

i_git() {
    pkg git
    # Config de base si absente (n'écrase rien)
    if has git && [[ -z "$(git config --global user.name 2>/dev/null)" ]]; then
        info "git installé — pense à configurer : git config --global user.name / user.email"
    fi
}

i_gh() {
    # GitHub CLI
    case "$PKG_MGR" in
        apt)
            ensure_base
            run "Clé GitHub CLI" bash -c "curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | $SUDO dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | $SUDO tee /etc/apt/sources.list.d/github-cli.list >/dev/null
            eval "$PKG_UPDATE"; pkg gh ;;
        dnf|pacman) pkg gh 2>/dev/null || pkg github-cli ;;
        brew) pkg gh ;;
        *) pkg gh 2>/dev/null || warn "GitHub CLI : voir https://cli.github.com" ;;
    esac
}

i_vscode() {
    has code && { ok "VS Code déjà présent"; return; }
    case "$PKG_MGR" in
        apt)
            ensure_base
            run "Clé Microsoft" bash -c "curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | $SUDO tee /etc/apt/trusted.gpg.d/microsoft.gpg >/dev/null"
            echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/repos/code stable main" | $SUDO tee /etc/apt/sources.list.d/vscode.list >/dev/null
            eval "$PKG_UPDATE"; pkg code ;;
        dnf)
            run "Clé Microsoft" bash -c "$SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc"
            printf '[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n' | $SUDO tee /etc/yum.repos.d/vscode.repo >/dev/null
            pkg code ;;
        pacman) pkg code 2>/dev/null || warn "VS Code : dispo via AUR (visual-studio-code-bin)" ;;
        brew)   run "VS Code" brew install --cask visual-studio-code ;;
        *)      warn "VS Code : télécharge depuis https://code.visualstudio.com" ;;
    esac
}

i_nodejs() { ensure_node; has node && ok "Node $(node -v) prêt"; }

i_claude() {
    # Claude Code CLI officiel (npm). Nécessite Node >= 18.
    if has claude; then ok "Claude Code déjà présent ($(claude --version 2>/dev/null))"; return; fi
    npm_global @anthropic-ai/claude-code claude-code
    if has claude; then
        ok "Claude Code installé — lance 'claude' pour t'authentifier."
    else
        warn "Claude Code : si 'claude' est introuvable, vérifie ton PATH npm (~/.npm-global/bin)."
    fi
}

menu_devenv() {
    submenu "Environnement de dev" \
        "git"                 i_git \
        "GitHub CLI (gh)"     i_gh \
        "VS Code"             i_vscode \
        "Node.js 20 LTS"      i_nodejs \
        "Claude Code CLI"     i_claude
}
register_category "Environnement de dev" menu_devenv
