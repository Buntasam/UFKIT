#!/bin/bash

function show_main_menu() {
    echo " 
    
╔───────────────────────────────────────────────────────────────────────╗
│     _/\/\____/\/\__/\/\/\/\/\/\__/\/\____/\/\__/\/\/\/\__/\/\/\/\/\/\_│
│    _/\/\____/\/\__/\/\__________/\/\__/\/\______/\/\________/\/\_____ │
│   _/\/\____/\/\__/\/\/\/\/\____/\/\/\/\________/\/\________/\/\_____  │
│  _/\/\____/\/\__/\/\__________/\/\__/\/\______/\/\________/\/\_____   │
│ ___/\/\/\/\____/\/\__________/\/\____/\/\__/\/\/\/\______/\/\_____    │
│__________________________________________________________________     │
╚───────────────────────────────────────────────────────────────────────╝
    "
    
    echo "------------------ Main Menu ------------------"
    echo "1. OS Updates"
    echo "2. Tools"
    echo "3. OSINT Tools"
    echo "4. VM Tools"
    echo "5. Packages"
    echo "6. Networking Tools"
    echo "7. Security Tools"
    echo "8. Custom Category"
    echo "0. Quit"
    echo "------------------------------------------------"
    echo " "
}

function os_updates() {
    echo " "
    echo "Executing OS Updates..."
    sudo apt update && sudo apt upgrade
}

function tools_menu() {
    while true; do
        echo " "
        echo "------------------ Tools Menu -----------------"
        echo "1. Sherlock"
        echo "2. Ghidra"
        echo "3. VS Code"
        echo "4. Virt Manager"
        echo "5. MaxP."
        echo "0. Back"
        echo "------------------------------------------------"
        echo " "

        read -p "Your choice : " choice_tools

        case $choice_tools in
            0)
                return ;;
            1)
                echo "Executing Sherlock commands..."
                git clone https://github.com/sherlock-project/sherlock.git ;;
            2)
                echo "Executing Ghidra commands..."
                git clone https://github.com/NationalSecurityAgency/ghidra.git ;;
            3)
                echo "Executing VS Code commands..."
                git clone https://github.com/microsoft/vscode.git ;;
            4)
                echo "Executing NOTHING commands..."
                sudo apt update ;;
            5)
                echo "Executing MaxP commands..."
                git clone https://github.com/KasRoudra/MaxPhisher.git ;;
            *)
                echo "Invalid choice. Please choose again." ;;
        esac
    done
}

function osint_tools_menu() {
    while true; do
        echo " "
        echo "---------------- OSINT Tools Menu --------------"
        echo "1. Sherlock"
        echo "2. Tool 2"
        echo "3. Tool 3"
        echo "0. Back"
        echo "------------------------------------------------"
        echo " "

        read -p "Your choice : " choice_osint

        case $choice_osint in
            0)
                return ;;
            1)
                echo "Executing OSINT Tool 1 commands..."
                git clone https://github.com/sherlock-project/sherlock.git
                ;;
            2)
                echo "Executing OSINT Tool 2 commands..."
                # Add git clone command for OSINT Tool 2
                ;;
            3)
                echo "Executing OSINT Tool 3 commands..."
                # Add git clone command for OSINT Tool 3
                ;;
            *)
                echo "Invalid choice. Please choose again." ;;
        esac
    done
}

function vm_tools_menu() {
    while true; do
        echo " "
        echo "------------------ VM Tools Menu ---------------"
        echo "1. Virt Manager"
        echo "2. Tool 2"
        echo "3. Tool 3"
        echo "0. Back"
        echo "------------------------------------------------"
        echo " "

        read -p "Your choice : " choice_vm

        case $choice_vm in
            0)
                return ;;
            1)
                echo "Executing virt-manager commands..."
                sudo apt install virt-manager
                ;;
            2)
                echo "Executing VM Tool 2 commands..."
                # Add git clone command for VM Tool 2
                ;;
            3)
                echo "Executing VM Tool 3 commands..."
                # Add git clone command for VM Tool 3
                ;;
            *)
                echo "Invalid choice. Please choose again." ;;
        esac
    done
}

function packages_menu() {
    while true; do
        echo " "
        echo "------------------ Packages Menu ---------------"
        echo "1. Net-tools"
        echo "2. Package 2"
        echo "3. Package 3"
        echo "0. Back"
        echo "------------------------------------------------"
        echo " "

        read -p "Your choice : " choice_packages

        case $choice_packages in
            0)
                return ;;
            1)
                echo "Start installing net-tools..."
		sudo apt install net-tools
                ;;
            2)
                echo "Executing Package 2 commands..."
                # Add git clone command for Package 2
                ;;
            3)
                echo "Executing Package 3 commands..."
                # Add git clone command for Package 3
                ;;
            *)
                echo "Invalid choice. Please choose again." ;;
        esac
    done
}

function networking_tools_menu() {
    while true; do
        echo " "
        echo "--------------- Networking Tools Menu ------------"
        echo "1. Wireshark"
        echo "2. Nmap"
        echo "3. Tcpdump"
        echo "0. Back"
        echo "--------------------------------------------------"
        echo " "

        read -p "Your choice : " choice_networking

        case $choice_networking in
            0)
                return ;;
            1)
                echo "Start installing Wireshark..."
		sudo apt install wireshark
                ;;
            2)
                echo "Start installing Nmap..."
		sudo apt install nmap
                ;;
            3)
                echo "Start installing Tcpdump..."
		sudo apt install tcpdump
                ;;
            *)
                echo "Invalid choice. Please choose again." ;;
        esac
    done
}

function security_tools_menu() {
    while true; do
        echo " "
        echo "--------------- Security Tools Menu --------------"
        echo "1. John the Ripper"
        echo "2. Aircrack-ng"
        echo "3. Metasploit"
        echo "0. Back"
        echo "--------------------------------------------------"
        echo " "

        read -p "Your choice : " choice_security

        case $choice_security in
            0)
                return ;;
            1)
                echo "Start installing John the Ripper..."
		sudo apt install john
                ;;
            2)
                echo "Start installing Aircrack-ng..."
		sudo apt install aircrack-ng
                ;;
            3)
                echo "Start installing Metasploit..."
		sudo apt install metasploit-framework
                ;;
            *)
                echo "Invalid choice. Please choose again." ;;
        esac
    done
}

function custom_category_menu() {
    while true; do
        echo " "
        echo "-------------- Custom Category Menu --------------"
        echo "1. Custom Tool 1"
        echo "2. Custom Tool 2"
        echo "3. Custom Tool 3"
        echo "0. Back"
        echo "--------------------------------------------------"
        echo " "

        read -p "Your choice : " choice_custom

        case $choice_custom in
            0)
                return ;;
            1)
                echo "Executing Custom Tool 1 commands..."
                # Add git clone command for Custom Tool 1
                ;;
            2)
                echo "Executing Custom Tool 2 commands..."
                # Add git clone command for Custom Tool 2
                ;;
            3)
                echo "Executing Custom Tool 3 commands..."
                # Add git clone command for Custom Tool 3
                ;;
            *)
                echo "Invalid choice. Please choose again." ;;
        esac
    done
}

while true; do
    show_main_menu

    read -p "Your choice : " choice_main

    case $choice_main in
        0)
            echo "Goodbye!"
            exit ;;
        1)
            os_updates ;;
        2)
            tools_menu ;;
        3)
            osint_tools_menu ;;
        4)
            vm_tools_menu ;;
        5)
            packages_menu ;;
        6)
            networking_tools_menu ;;
        7)
            security_tools_menu ;;
        8)
            custom_category_menu ;;
        *)
            echo "Invalid choice. Please choose again." ;;
    esac
done

