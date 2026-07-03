#!/usr/bin/env bash
# Module : Réseau & recon

i_wireshark() { pkg wireshark; }
i_nmap()      { pkg nmap; }
i_tcpdump()   { pkg tcpdump; }
i_masscan()   { pkg masscan; }
i_netcat()    { pkg netcat-openbsd 2>/dev/null || pkg netcat 2>/dev/null || pkg nmap-ncat; }
i_rustscan()  { cargo_install rustscan; }
i_naabu()     { go_install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest naabu; }
i_subfinder() { go_install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest subfinder; }
i_responder() { git_get https://github.com/lgandx/Responder.git; }
i_bettercap() { pkg bettercap; }
i_proxychains(){ pkg proxychains-ng 2>/dev/null || pkg proxychains; }

menu_network() {
    submenu "Réseau & recon" \
        "Wireshark"   i_wireshark \
        "Nmap"        i_nmap \
        "tcpdump"     i_tcpdump \
        "masscan"     i_masscan \
        "netcat"      i_netcat \
        "RustScan"    i_rustscan \
        "naabu"       i_naabu \
        "subfinder"   i_subfinder \
        "Responder"   i_responder \
        "bettercap"   i_bettercap \
        "proxychains" i_proxychains
}
register_category "Réseau & recon" menu_network
