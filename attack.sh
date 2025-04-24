#!/bin/bash

USER=$(whoami)
HOME=$(pwd)

if [ $USER == "root" ]; then
echo "user is root, continue."
else
echo "user is not root, exiting."
exit 1
fi

function VAILD() {
    if [[ ! $target =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "Invalid IP address format. Please enter a valid IP address or range."
        exit 1
        else
        echo "Vaild IP address, continue."
    fi
}

function LS(){
	echo "we finish the scan, you want to see what you getting? (y/n)"
	read LS_CHOISE
	if [ "$LS_CHOISE" == "y" ]; then
	echo "here what you got from the scan's"
	ls -l "/$HOME/$DIR"
	else
	echo "you choose to continue, continuing."
	fi
}

function FIND(){
	echo "you can search inside the files on "$HOME/$DIR" choose (y/n)"
	read FIND_CHOISE
	if [ "$FIND_CHOISE" == "y" ]; then
	read -p "enter what you wanna find on the file in:" FIND_OPTIONS
    grep -i "$FIND_OPTIONS" "$HOME/$DIR"/* 2>/dev/null	
    else
	echo "you choose to continue, continuing."
	fi
}

function ZIP(){
	echo "you want to zip the all files in "$/HOME/$DIR"? (y/n)"
	read ZIP_CHOISE
	if [ "$ZIP_CHOISE" == "y" ]; then
	read -p "enter a name for the zip file will named: " ZIP_NAME
	zip -r "$ZIP_NAME" ./*
	else
	echo "you choose to continue, continuing."
	fi
}


echo "Give a name for a directory to work in: " 
read DIR
mkdir "$DIR"
echo "Directory created here: "$HOME/$DIR""
cd "$DIR"

function BUILDIN(){
	
if [ ! -f "user_pass.txt" ]; then
echo "not found any list, downloading"
wget https://raw.githubusercontent.com/Bxci/MostCommonUSER-PASS/refs/heads/main/user_pass.txt -O $HOME/$DIR/user_pass.txt >/dev/null 2>&1;
echo "downloaded"
echo "Using default USER:PASS list."
else
echo "this file downladed before"
fi
}

function CUSTOM() {
    echo "Do you want to use a custom password list or the built-in one? (n = built-in, y = custom):"
    read -r CUSTOM_PSWD

    if [ "$CUSTOM_PSWD" == "n" ]; then
        echo "Using built-in password list."
        BUILDIN
    elif [ "$CUSTOM_PSWD" == "y" ]; then
        echo "Insert the full path of the passlist:"
        read -r CUSTOM_PASS_LIST

        if [ -f "$CUSTOM_PASS_LIST" ]; then
            echo "Using custom passlist: $CUSTOM_PASS_LIST"
        else
            echo "The file '$CUSTOM_PASS_LIST' does not exist. Using the built-in password list instead."
            BUILDIN
        fi
    else
        echo "Invalid option. Please enter 'n' for built-in or 'y' for custom."
        CUSTOM
    fi
}
CUSTOM

function BASIC(){
	echo "Basic scan starting NOTE: it will take some time!"
	sudo nmap "$target" -sC -sV -T4 >> $HOME/$DIR/nmap_results.txt
	sudo nmap "$target" --script=vuln >> $HOME/$DIR/vuln_basic_nmap.txt
	sudo masscan -pU:1-65535 "$target" --min-rate=1000 -oG "$HOME/$DIR/basic_udp_scan.txt"
	
	echo "Basic scan results will be found on "$PWD/$DIR/nmap_results.txt""
	
	#CALLING THE FUNCTION OF THE SEARCHES.
	LS
	FIND
	ZIP
	
}

function FULL(){
    
	echo "Full scan method selected NOTE: it will take some time!"
	# 3.1
	sudo nmap -p- -sV --script=vuln "$target" -oN "$HOME/$DIR/vuln_full_scan.txt"
	echo "Full scan ended you can find the file here: "$PWD/$DIR/full_nmap_scan.txt""
	
	if [ "$CUSTOM_PSWD" == "y" ]; then
	echo "Starting Brute Force with Custom Password file"
	medusa -h "$target" -U "$CUSTOM_PASS_LIST" -P "$CUSTOM_PASS_LIST" -M ssh
	medusa -h "$target" -U "$CUSTOM_PASS_LIST" -P "$CUSTOM_PASS_LIST" -M telnet
	medusa -h "$target" -U "$CUSTOM_PASS_LIST" -P "$CUSTOM_PASS_LIST" -M ftp
	medusa -h "$target" -U "$CUSTOM_PASS_LIST" -P "$CUSTOM_PASS_LIST" -M rdp
	else
	#DFLIST
	medusa -h "$target" -U "$HOME/$DIR/user_pass.txt" -P "$HOME/$DIR/user_pass.txt" -M ssh
	medusa -h "$target" -U "$HOME/$DIR/user_pass.txt" -P "$HOME/$DIR/user_pass.txt" -M telnet
	medusa -h "$target" -U "$HOME/$DIR/user_pass.txt" -P "$HOME/$DIR/user_pass.txt" -M ftp
	medusa -h "$target" -U "$HOME/$DIR/user_pass.txt" -P "$HOME/$DIR/user_pass.txt" -M rdp
	fi
	
	echo "full scan detected you have the option to look for CVE's"
	
	# - 3.2
    cves=$(grep -oP 'CVE-\d{4}-\d+' "$HOME/$DIR/vuln_basic_nmap.txt")
	echo "do you want to take a look of the cves's? (y/n)"
	read CVE
	
	if [ "$CVE" == "y" ]; then
	echo "starting looking for cves."	
	for cves in $cves; do
	searchsploit --cve "$cves" >> cves.txt
	done
	else
	echo "you choose to continue, continuing!"
	fi
	
	#CALLING THE FUNCTION OF THE SEARCHES.
	LS
	FIND
	ZIP
}


function MENU() {
    echo "Choose method to work on:
    1 - Basic
    2 - Full
    3 - Exit"
    read CHOISE
    echo "Enter an IP address or range to scan:"
    read target
    VAILD

    case $CHOISE in
        1)
            BASIC
            ;;
        2)
            FULL
            ;;
        3)
            exit 0
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
}
MENU
