#!/usr/bin/env bash
# Module : Blue team & forensics

i_volatility() { pipx_install volatility3 || git_get https://github.com/volatilityfoundation/volatility3.git; }
i_sleuthkit()  { pkg sleuthkit; }
i_autopsy()    { pkg autopsy; }
i_yara()       { pkg yara; }
i_clamav()     { pkg clamav; }
i_chkrootkit() { pkg chkrootkit; }
i_rkhunter()   { pkg rkhunter; }
i_lynis()      { pkg lynis; }
i_wazuh_agent(){ warn "Wazuh : suis la doc officielle https://documentation.wazuh.com"; }

menu_blueteam() {
    submenu "Blue team & forensics" \
        "Volatility3" i_volatility \
        "Sleuth Kit"  i_sleuthkit \
        "Autopsy"     i_autopsy \
        "YARA"        i_yara \
        "ClamAV"      i_clamav \
        "chkrootkit"  i_chkrootkit \
        "rkhunter"    i_rkhunter \
        "Lynis (audit)" i_lynis \
        "Wazuh (agent)" i_wazuh_agent
}
register_category "Blue team & forensics" menu_blueteam
