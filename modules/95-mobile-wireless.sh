#!/usr/bin/env bash
# Module : Mobile & sans-fil

i_adb()       { pkg android-tools-adb 2>/dev/null || pkg android-tools 2>/dev/null || pkg adb; }
i_frida()     { pipx_install frida-tools; }
i_objection() { pipx_install objection; }
i_mobsf()     { git_get https://github.com/MobSF/Mobile-Security-Framework-MobSF.git MobSF; }
i_reaver()    { pkg reaver; }
i_wifite()    { pkg wifite; }
i_hcxtools()  { pkg hcxtools hcxdumptool 2>/dev/null || pkg hcxtools; }
i_kismet()    { pkg kismet; }

menu_mobile() {
    submenu "Mobile & sans-fil" \
        "adb (Android)"   i_adb \
        "Frida"           i_frida \
        "objection"       i_objection \
        "MobSF"           i_mobsf \
        "Reaver (WPS)"    i_reaver \
        "wifite"          i_wifite \
        "hcxtools"        i_hcxtools \
        "Kismet"          i_kismet
}
register_category "Mobile & sans-fil" menu_mobile
