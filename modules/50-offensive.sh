#!/usr/bin/env bash
# Module : Sécurité offensive & cracking

i_john()      { pkg john; }
i_hashcat()   { pkg hashcat; }
i_hydra()     { pkg hydra; }
i_aircrack()  { pkg aircrack-ng; }
i_hashid()    { pkg hashid || pipx_install hashid; }
i_crackmapexec(){ pipx_install crackmapexec || pipx_install netexec; }
i_impacket()  { pipx_install impacket; }
i_metasploit(){
    pkg metasploit-framework 2>/dev/null && return
    run "Metasploit (installer officiel)" bash -c \
        "curl -fsSL https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb -o /tmp/msf.sh && chmod +x /tmp/msf.sh && $SUDO /tmp/msf.sh"
}
i_bloodhound(){ pipx_install bloodhound-ce 2>/dev/null || pipx_install bloodhound; }
i_evilwinrm() { run "evil-winrm (gem)" bash -c "$SUDO gem install evil-winrm"; }

menu_offensive() {
    submenu "Offensif & cracking" \
        "John the Ripper"     i_john \
        "hashcat"             i_hashcat \
        "Hydra"               i_hydra \
        "Aircrack-ng"         i_aircrack \
        "hashid"              i_hashid \
        "CrackMapExec/NetExec" i_crackmapexec \
        "impacket"            i_impacket \
        "Metasploit"          i_metasploit \
        "BloodHound.py"       i_bloodhound \
        "evil-winrm"          i_evilwinrm
}
register_category "Offensif & cracking" menu_offensive
