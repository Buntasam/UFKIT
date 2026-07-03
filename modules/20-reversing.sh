#!/usr/bin/env bash
# Module : Reverse engineering & dev

i_ghidra()  { pkg ghidra || git_get https://github.com/NationalSecurityAgency/ghidra.git; }
i_cutter()  { pkg cutter || git_get https://github.com/rizinorg/cutter.git; }
i_radare2() { pkg radare2 || git_get https://github.com/radareorg/radare2.git; }
i_gdb()     { pkg gdb; }
i_gef()     { ensure_base; run "GEF (extension GDB)" bash -c "curl -fsSL https://gef.blah.cat/sh | sh"; }
i_binwalk() { pkg binwalk || pipx_install binwalk; }
i_pwntools(){ pipx_install pwntools; }
i_apktool() { pkg apktool; }

menu_reversing() {
    submenu "Reverse engineering" \
        "Ghidra"           i_ghidra \
        "Cutter / rizin"   i_cutter \
        "radare2"          i_radare2 \
        "GDB"              i_gdb \
        "GEF (GDB enhanced)" i_gef \
        "binwalk"          i_binwalk \
        "pwntools"         i_pwntools \
        "apktool"          i_apktool
}
register_category "Reverse engineering" menu_reversing
