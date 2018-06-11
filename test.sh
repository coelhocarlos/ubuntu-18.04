#!/bin/bash
#title:         menu.sh
#description:   Menu which allows multiple items to be selected
#author:        
#               Based on script from MestreLion
#created:       
#updated:       N/A
#version:       1.0
#usage:         ./menu.sh
#==============================================================================

#Menu options
options[0]="Mysql"
options[1]="Apache"
options[2]="Php 7"
options[3]="Maria DB"
options[4]="Mysql-Server"
options[5]="SSL CERT"
options[6]="PhpMyAdmin"
options[7]="Webmin"

#Actions to take based on selection
function ACTIONS {
    if [[ ${choices[0]} ]]; then
        #Option 1 selected
        echo "Option Mysql selected"
    fi
    if [[ ${choices[1]} ]]; then
        #Option 2 selected
        echo "Option Apache selected"
    fi
    if [[ ${choices[2]} ]]; then
        #Option 3 selected
        echo "Option Php 7 selected"
    fi
    if [[ ${choices[3]} ]]; then
        #Option 4 selected
        echo "Option Maria Db selected"
    fi
    if [[ ${choices[5]} ]]; then
        #Option 5 selected
        echo "Option Mysql server selected"
    fi
    if [[ ${choices[6]} ]]; then
        #Option 5 selected
        echo "Option SSL selected"
    fi
    if [[ ${choices[7]} ]]; then
        #Option 5 selected
        echo "Option PhpMyAdmin selected"
    fi
    if [[ ${choices[8]} ]]; then
        #Option 5 selected
        echo "Option Webim selected"
    fi
    if [[ ${choices[9]} ]]; then
        #Option 5 selected
        echo "Option 5 selected"
    fi
}

#Variables
ERROR=" "

#Clear screen for menu
clear

#Menu function
function MENU {
    echo "Menu Options"
    for NUM in ${!options[@]}; do
        echo "[""${choices[NUM]:- }""]" $(( NUM+1 ))") ${options[NUM]}"
    done
    echo "$ERROR"
}

#Menu loop
while MENU && read -e -p "Select the desired options using their number (again to uncheck, ENTER when done): " -n1 SELECTION && [[ -n "$SELECTION" ]]; do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done

ACTIONS
