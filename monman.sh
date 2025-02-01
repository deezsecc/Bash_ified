#!/bin/bash

#Script to turn on monitor mode without using airgeddon or airmon.
#I'm too lazy to type those 4 commands by myself. 
#Add this in your ./bashrc and set an alias to run easily. e.g. alias monman=bash monman.sh
#That should start the script when you run '$ sudo monman'

##############
# By Deezsec #
##############

# Checking if the script is being run as root or not.
echo -e "\e[31m<---------------------(The MonMan is here)------------------------>"
echo -e "\e[37m[War mode]"
echo -e "[*] Checking if you are running this as root or not..."
sleep 0.5
if [ "$(id -u)" -eq 0 ]; then
    echo -e "[*] Root permissions granted."
    echo -e " "
    
    # Main func starts here		
    echo -e "[*] Hello there! I'm MonMan."
    echo -e "[*] I know why you're here. Let's start."
    read -p "[*] MonMode On or Off?(on/off):" mon_resp

    if [ "${mon_resp}" == "on" ]; then
        read -p "[*] Did you plug-in your adapter? (y/n):" ad_resp
        if [ "${ad_resp}" == "y" ]; then
            echo -e "[*] Cool."
            echo -e "[*] Killing processes that may interfere..."
            sudo systemctl stop NetworkManager
            sudo systemctl stop wpa_supplicant
            echo -e "[*] Done."
            echo -e "[*] Running the essential commands to start monmode..."
            sudo ip link set wlan0 down
            sudo iw dev wlan0 set type monitor
            sudo ip link set wlan0 up
            sleep 2
            check=$(iw dev | grep "type")
            echo -e "[*] Your monitor mode status:" ${check}
            sleep 1
            echo -e "[*] All Done."
            echo -e "\e[31m<-----------------(MonMan at your Service)---------------------->\e[0m"
            exit 1
        elif [ "${ad_resp}" == "n" ]; then
            echo -e "\e[37m[*] No worries, plug it in 10 seconds."
            sleep 10
            echo -e "[*] Relaunching the script..."
            clear && bash monman.sh
            exit 1
        else
            echo -e "\e[37m[!] MonMan: Missing an input.\e[0m"
            echo -e "\e[31m<-------------------(MonMan at your Service)---------------------->\e[0m"
            exit 1
        fi
    fi

    if [ "${mon_resp}" == "off" ]; then
        echo -e "[*] Okay, turning the monmode off and restarting networkmanager..."
        sudo ip link set wlan0 down
        sudo iw dev wlan0 set type managed
        sudo ip link set wlan0 up
        sudo systemctl start NetworkManager
        sudo systemctl start wpa_supplicant
        stat=$(iw dev | grep type)  # Removed spaces around =
        echo -e "Interface status:" ${stat}
        echo -e "[*] All done."
        echo -e "\e[31m<-----------------(MonMan at your Service)---------------------->\e[0m"
    else
            echo -e "[!] MonMan: Missing an input."
            echo -e "\e[31m<-----------------(MonMan at your Service)---------------------->\e[0m"
        exit 1
    fi

else
    echo -e "\e[37m[!] MonMan: You have to run this script as root or with sudo."
fi
