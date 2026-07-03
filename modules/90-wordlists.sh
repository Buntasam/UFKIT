#!/usr/bin/env bash
# Module : Wordlists & ressources

i_seclists()   { pkg seclists 2>/dev/null || git_get https://github.com/danielmiessler/SecLists.git; }
i_rockyou()    {
    local f="/usr/share/wordlists/rockyou.txt"
    [[ -f "$f" ]] && { ok "rockyou déjà présent : $f"; return; }
    [[ -f "$f.gz" ]] && { run "Décompression rockyou" $SUDO gunzip -k "$f.gz"; return; }
    git_get https://github.com/brannondorsey/naive-hashcat.git naive-hashcat
    warn "Sinon récupère rockyou via le paquet 'wordlists'."
}
i_wordlists_pkg(){ pkg wordlists; }
i_fuzzdb()     { git_get https://github.com/fuzzdb-project/fuzzdb.git; }
i_payloads()   { git_get https://github.com/swisskyrepo/PayloadsAllTheThings.git; }
i_assetnote()  { git_get https://github.com/assetnote/commonspeak2-wordlists.git; }

menu_wordlists() {
    submenu "Wordlists & ressources" \
        "SecLists"                 i_seclists \
        "rockyou.txt"              i_rockyou \
        "Paquet 'wordlists'"       i_wordlists_pkg \
        "FuzzDB"                   i_fuzzdb \
        "PayloadsAllTheThings"     i_payloads \
        "Assetnote wordlists"      i_assetnote
}
register_category "Wordlists & ressources" menu_wordlists
