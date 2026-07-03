#!/usr/bin/env bash
#
# UFKIT — Ultimate Field Kit (launcher)
# Installateur modulaire d'outils cyber pour tout nouveau poste.
#
#   ./UFKIT.sh              menu interactif
#   ./UFKIT.sh --list       liste catégories & outils
#   ./UFKIT.sh --starter    installe le starter pack sans menu
#   ./UFKIT.sh --help       aide
#
# Architecture :
#   lib/core.sh       primitives (couleurs, log, install, registre)
#   modules/*.sh      une catégorie chacun, s'auto-enregistre
#
set -u

# Racine du projet (marche même via symlink / autre cwd)
UFKIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------------------------------------------------------
# Chargement
# ----------------------------------------------------------------------------
if [[ ! -f "$UFKIT_ROOT/lib/core.sh" ]]; then
    echo "Erreur : lib/core.sh introuvable dans $UFKIT_ROOT" >&2
    exit 1
fi
# shellcheck source=lib/core.sh
source "$UFKIT_ROOT/lib/core.sh"

load_modules() {
    local m
    for m in "$UFKIT_ROOT"/modules/*.sh; do
        [[ -f "$m" ]] || continue
        # shellcheck disable=SC1090
        source "$m"
    done
}

# ----------------------------------------------------------------------------
# Starter pack : sélection transversale d'essentiels
# ----------------------------------------------------------------------------
starter_pack() {
    step "Starter pack — base indispensable pour un nouveau poste"
    ensure_base; ensure_python
    i_git; i_vscode; i_claude       # environnement de dev
    i_utils; i_build
    i_nmap; i_wireshark; i_netcat
    i_sherlock; i_sqlmap
    i_seclists
    ok "Starter pack terminé."
}

# ----------------------------------------------------------------------------
# Menu principal (construit depuis le registre)
# ----------------------------------------------------------------------------
main_menu() {
    while true; do
        show_banner
        printf '\n %s┌──────────────── Menu Principal ────────────────┐%s\n' "$C_BOLD" "$C_RESET"
        local i
        for i in "${!CAT_TITLES[@]}"; do
            printf ' │  %s%2d.%s %-42s│\n' "$C_GREEN" $((i+1)) "$C_RESET" "${CAT_TITLES[$i]}"
        done
        printf ' │  %sS.%s %s%-42s%s│\n' "$C_CYAN" "$C_RESET" "$C_BOLD" "Starter pack (essentiel)" "$C_RESET"
        printf ' │  %s0.%s %-42s│\n' "$C_RED" "$C_RESET" "Quitter"
        printf ' %s└─────────────────────────────────────────────────┘%s\n' "$C_BOLD" "$C_RESET"

        read -rp $'\nTon choix : ' choice
        case "$choice" in
            0)        ok "À bientôt !"; exit 0 ;;
            [Ss])     starter_pack; pause ;;
            ''|*[!0-9]*) warn "Choix invalide."; sleep 1 ;;
            *)
                if (( choice >= 1 && choice <= ${#CAT_FUNCS[@]} )); then
                    "${CAT_FUNCS[$((choice-1))]}"
                else
                    warn "Choix invalide."; sleep 1
                fi ;;
        esac
    done
}

# ----------------------------------------------------------------------------
# Modes non-interactifs
# ----------------------------------------------------------------------------
cmd_list() {
    printf '%sCatégories UFKIT :%s\n' "$C_BOLD" "$C_RESET"
    local i
    for i in "${!CAT_TITLES[@]}"; do
        printf '  %2d. %s\n' $((i+1)) "${CAT_TITLES[$i]}"
    done
    printf '\nOutils déclarés (fonctions i_*) :\n'
    declare -F | awk '{print $3}' | grep '^i_' | sed 's/^i_/  - /' | sort
}

usage() {
    cat <<EOF
UFKIT v$UFKIT_VERSION — Ultimate Field Kit (installateur modulaire)

Usage : $0 [option]

  (aucun)     Menu interactif
  --list      Liste catégories et outils
  --starter   Installe le starter pack sans menu
  --help      Cette aide

Variables d'environnement :
  UFKIT_TOOLS_DIR   Dossier des clones git (défaut: \$HOME/ufkit-tools)
  UFKIT_LOG         Fichier de log (défaut: \$HOME/ufkit-install.log)

Ajouter un outil   : édite le module concerné dans modules/, ajoute une
                     fonction i_xxx() et une ligne dans son submenu.
Ajouter une catégorie : crée modules/NN-nom.sh avec une fonction menu_xxx
                     et un appel register_category "Titre" menu_xxx.

Astuce : lance avec sudo pour les paquets système.
EOF
}

# ----------------------------------------------------------------------------
# Entrée
# ----------------------------------------------------------------------------
main() {
    : > "$LOG_FILE" 2>/dev/null || true
    log INFO "UFKIT $UFKIT_VERSION démarré"
    detect_platform
    load_modules

    case "${1:-}" in
        --help|-h)  usage ;;
        --list|-l)  cmd_list ;;
        --starter)  ensure_base; starter_pack ;;
        "")         ensure_base; main_menu ;;
        *)          err "Option inconnue : $1"; usage; exit 1 ;;
    esac
}

main "$@"
