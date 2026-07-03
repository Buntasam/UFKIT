#!/usr/bin/env bash
# Module : Web & API

i_ffuf()      { go_install github.com/ffuf/ffuf/v2@latest ffuf; }
i_gobuster()  { go_install github.com/OJ/gobuster/v3@latest gobuster; }
i_nuclei()    { go_install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest nuclei; }
i_httpx()     { go_install github.com/projectdiscovery/httpx/cmd/httpx@latest httpx; }
i_katana()    { go_install github.com/projectdiscovery/katana/cmd/katana@latest katana; }
i_dalfox()    { go_install github.com/hahwul/dalfox/v2@latest dalfox; }
i_nikto()     { pkg nikto || git_get https://github.com/sullo/nikto.git; }
i_sqlmap()    { pkg sqlmap || pipx_install sqlmap; }
i_wpscan()    { pkg wpscan 2>/dev/null || run "wpscan (gem)" bash -c "$SUDO gem install wpscan"; }
i_whatweb()   { pkg whatweb; }
i_zap()       {
    case "$PKG_MGR" in
        brew) run "OWASP ZAP" brew install --cask owasp-zap ;;
        *)    pkg zaproxy 2>/dev/null || warn "ZAP : télécharge depuis zaproxy.org" ;;
    esac
}

menu_web() {
    submenu "Web & API" \
        "ffuf"       i_ffuf \
        "gobuster"   i_gobuster \
        "nuclei"     i_nuclei \
        "httpx"      i_httpx \
        "katana (crawler)" i_katana \
        "dalfox (XSS)" i_dalfox \
        "Nikto"      i_nikto \
        "sqlmap"     i_sqlmap \
        "WPScan"     i_wpscan \
        "WhatWeb"    i_whatweb \
        "OWASP ZAP"  i_zap
}
register_category "Web & API" menu_web
