#!/bin/bash

UPDATE= 'sudo dnf update'
SEARCHA='dnf list available'
SEARCHI='dnf list installed'
SEARCHGA='dnf group list available'
SEARCHGI='dnf group list installed'
INFO='dnf info'
INFOG='dnf info'

function install 
{
	#declaration of local variables 
	local pkg
	local argument_input	
	#selecting of packages to install
	#flags multi to be able to pick multiple packages
	#exact to match exact match
	#no sort self explanatory
	#cycle to enable cycle scroll
	#reverse to set orientation to reverse
	#margin for margins
	#inline info to display info inline
	#preview to show the package description 
	#header and promp to give info for people to know how to do stuff 
	pkg="$( $SEARCHA | sort -k1,1 -u | 
		fzf -i -m -e \
                    --no-sort \
                    --select-1 \
                    --query="$argument_input" \
                    --cycle \
                    --reverse \
                    --margin="4%,1%,1%,2%" \
                    --inline-info \
                    --preview "$INFO {1}"\
                    --preview-window=right:55%:wrap \
                    --header="TAB key to (un)select. ENTER to install. ESC to quit." \
                    --prompt="filter> " |
                awk '{print $1}'                                                  
            )"
            
            pkg="$( echo "$pkg" | paste -sd " " )"
            if [[ -n "$pkg" ]]
            then 
            clear
            sudo dnf install $pkg
            fi
}

function erase
{
	local pkg
	local argument_input	
	pkg="$( $SEARCHI | sort -k1,1 -u | 
		fzf -i -m -e \
                    --no-sort \
                    --select-1 \
                    --query="$argument_input" \
                    --cycle \
                    --reverse \
                    --margin="4%,1%,1%,2%" \
                    --inline-info \
                    --preview "$INFO {1}" \
                    --preview-window=right:55%:wrap \
                    --header="TAB key to (un)select. ENTER to erase. ESC to quit." \
                    --prompt="filter> " |
                awk '{print $1}'                                                  
            )"
            
            pkg="$( echo "$pkg" | paste -sd " " )"
            if [[ -n "$pkg" ]]
            then 
            clear
            sudo dnf erase $pkg
            fi
}

function maintain
{
	sudo dnf cleanall
	sudo dnf autoremove	
	}

function ui
{
while true
do
clear
echo
    echo -e "                     \e[7m FedoraUI - Package manager \e[0m                     "
    echo -e " ┌───────────────────────────────────────────────────────────────┐"
    echo -e " │    1   \e[1mU\e[0mpdate System           2   \e[1mM\e[0maintain System            │"
    echo -e " │    3   \e[1mI\e[0mnstall Packages        4   \e[1mE\e[0mrase package              │"
    echo -e " └───────────────────────────────────────────────────────────────┘"
    
    echo -e "  Enter number or marked letter(s)   -   0   \e[1mQ\e[0muit "
    read -r choice
    choice="$(echo "$choice" | tr '[:upper:]' '[:lower:]' )"
    echo
    
    case "$choice" in
        1|u|update|update-system )
            $UPDATE                                                                
            echo
            echo -e " \e[41m System updated. To return to FedoraUI press ENTER \e[0m"
            # wait for input, e.g. by pressing ENTER:
            read
            ;;
        2|m|maintain|maintain-system )
            maintain
            echo
            echo -e " \e[41m System maintenance finished. To return to FedoraUI press ENTER \e[0m"
            read
            ;;
        3|i|install|install-packages )
            install
            echo
            echo -e " \e[41m Package installation finished. To return to FedoraUI press ENTER \e[0m"
            read
            ;;
        4|r|remove|remove-packages-and-deps| e | erase )
            erase
            echo
            echo -e " \e[41m Package(s) erased. To return to FedoraUI press ENTER \e[0m"
            read
            ;;
        0|q|quit|$'\e'|$'\e'$'\e' )
        clear && exit
            ;;
            
            * )                                                                         
            echo -e " \e[41m Wrong option \e[0m"
            echo -e "  Please try again...  "
            sleep 2
            ;;
            
      esac   
      done
	}
	
ui
