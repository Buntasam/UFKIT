#!/usr/bin/env bash
# Module : Virtualisation & conteneurs

i_virtmanager() { pkg virt-manager qemu-kvm libvirt-daemon-system 2>/dev/null || pkg virt-manager; }
i_docker()      {
    has docker && { ok "Docker déjà présent"; return; }
    run "Docker (script officiel)" bash -c "curl -fsSL https://get.docker.com | $SUDO sh"
    $SUDO usermod -aG docker "${SUDO_USER:-$USER}" 2>/dev/null || true
}
i_dockercompose(){ pkg docker-compose 2>/dev/null || pkg docker-compose-plugin; }
i_vagrant()     { pkg vagrant; }
i_kubectl()     {
    has kubectl && { ok "kubectl déjà présent"; return; }
    ensure_base
    run "kubectl" bash -c "curl -fsSLo /tmp/kubectl 'https://dl.k8s.io/release/\$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl' && $SUDO install -m0755 /tmp/kubectl /usr/local/bin/kubectl"
}

menu_virt() {
    submenu "Virtualisation & conteneurs" \
        "virt-manager + KVM" i_virtmanager \
        "Docker"             i_docker \
        "docker-compose"     i_dockercompose \
        "Vagrant"            i_vagrant \
        "kubectl"            i_kubectl
}
register_category "Virtualisation & conteneurs" menu_virt
