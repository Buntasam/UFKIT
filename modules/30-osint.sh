#!/usr/bin/env bash
# Module : OSINT

i_sherlock()    { pipx_install sherlock-project sherlock || git_get https://github.com/sherlock-project/sherlock.git; }
i_holehe()      { pipx_install holehe; }
i_maigret()     { pipx_install maigret; }
i_theharvester(){ pkg theharvester || pipx_install theHarvester; }
i_spiderfoot()  { git_get https://github.com/smicallef/spiderfoot.git; }
i_photon()      { git_get https://github.com/s0md3v/Photon.git; }
i_sublist3r()   { pipx_install sublist3r || git_get https://github.com/aboul3la/Sublist3r.git; }
i_recon_ng()    { pipx_install recon-ng || git_get https://github.com/lanmaster53/recon-ng.git; }
i_exiftool()    { pkg libimage-exiftool-perl 2>/dev/null || pkg exiftool; }
i_ghunt()       { pipx_install ghunt; }

menu_osint() {
    submenu "OSINT" \
        "Sherlock"      i_sherlock \
        "Holehe"        i_holehe \
        "Maigret"       i_maigret \
        "theHarvester"  i_theharvester \
        "SpiderFoot"    i_spiderfoot \
        "Photon"        i_photon \
        "Sublist3r"     i_sublist3r \
        "recon-ng"      i_recon_ng \
        "ExifTool"      i_exiftool \
        "GHunt (Google)" i_ghunt
}
register_category "OSINT" menu_osint
