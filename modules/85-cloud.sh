#!/usr/bin/env bash
# Module : Cloud & DevSecOps
# Scanners de vulnérabilités conteneurs/IaC, posture Kubernetes, détection de
# secrets et audit de configuration cloud (AWS/Azure/GCP).

# Installe un binaire via un script officiel « curl | sh -s -- -b <dir> ».
# Sur macOS (brew) on écrit dans /usr/local/bin sans sudo, ailleurs avec $SUDO.
_install_script() {
    local name="$1" url="$2"
    has "$name" && { ok "$name déjà présent"; return 0; }
    local bindir="/usr/local/bin" sudo="$SUDO"
    [[ "$PKG_MGR" == "brew" ]] && sudo=""
    ensure_base
    run "Installation $name (script officiel)" bash -c \
        "curl -fsSL '$url' | $sudo sh -s -- -b $bindir"
}

i_trivy() {
    case "$PKG_MGR" in
        brew|pacman) has trivy && { ok "trivy déjà présent"; return; }; pkg trivy ;;
        *) _install_script trivy \
             "https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh" ;;
    esac
}

i_grype() {
    _install_script grype \
        "https://raw.githubusercontent.com/anchore/grype/main/install.sh"
}

i_syft() {
    _install_script syft \
        "https://raw.githubusercontent.com/anchore/syft/main/install.sh"
}

i_kubescape() {
    has kubescape && { ok "kubescape déjà présent"; return; }
    ensure_base
    run "Installation Kubescape (script officiel)" bash -c \
        "curl -fsSL https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash"
}

i_gitleaks() {
    case "$PKG_MGR" in
        brew|pacman) has gitleaks && { ok "gitleaks déjà présent"; return; }; pkg gitleaks ;;
        *) go_install github.com/gitleaks/gitleaks/v8@latest gitleaks ;;
    esac
}

i_trufflehog() {
    _install_script trufflehog \
        "https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh"
}

i_checkov()    { pipx_install checkov; }
i_prowler()    { pipx_install prowler; }
i_scoutsuite() { pipx_install scoutsuite ScoutSuite; }

menu_cloud() {
    submenu "Cloud & DevSecOps" \
        "Trivy (scan conteneurs/IaC)" i_trivy \
        "Grype (vulnérabilités)"      i_grype \
        "Syft (SBOM)"                 i_syft \
        "Kubescape (posture K8s)"     i_kubescape \
        "Checkov (IaC/Terraform)"     i_checkov \
        "Gitleaks (secrets)"          i_gitleaks \
        "TruffleHog (secrets)"        i_trufflehog \
        "Prowler (audit cloud)"       i_prowler \
        "ScoutSuite (audit cloud)"    i_scoutsuite
}
register_category "Cloud & DevSecOps" menu_cloud
