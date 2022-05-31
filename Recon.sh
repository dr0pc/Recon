#!/usr/bin/bash							
# Autor: L.C							
# Automatizacion de recon de IPS por ICMP y SMB			
#################################################################

#Colores
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
PURPLE='\033[1;35m'
NC='\033[0m'

#Variables
nmap=$(which nmap)
dir=""
dirmk=""

########################################## EJEMPLO DE USO ##########################################
if [ "$1" == "" ]; then
	echo 
	echo "Example: `basename $0` segmentos.txt" 
	echo "Example: `basename $0` 10.10.10.0/24" && echo ""
	exit 0
fi

########################################## BANNER ##########################################
echo -e "
                                                                                                     
	${NC}@@@@@@@   @@@@@@@@   @@@@@@@   @@@@@@   @@@  @@@      @@@@@@   @@@@@@@      @@@@@@@   @@@  @@@@@@@@  
	@@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@ @@@     @@@@@@@@  @@@@@@@@     @@@@@@@@  @@@  @@@@@@@@  
	@@!  @@@  @@!       !@@       @@!  @@@  @@!@!@@@     @@!  @@@  @@!  @@@     @@!  @@@  @@!  @@!       
	!@!  @!@  !@!       !@!       !@!  @!@  !@!!@!@!     !@!  @!@  !@!  @!@     !@!  @!@  !@!  !@!       
	@!@!!@!   @!!!:!    !@!       @!@  !@!  @!@ !!@!     @!@  !@!  @!@!!@!      @!@  !@!  !!@  @!!!:!    
	!!@!@!    !!!!!:    !!!       !@!  !!!  !@!  !!!     !@!  !!!  !!@!@!       !@!  !!!  !!!  !!!!!:    
	!!: :!!   !!:       :!!       !!:  !!!  !!:  !!!     !!:  !!!  !!: :!!      !!:  !!!  !!:  !!:       
	:!:  !:!  :!:       :!:       :!:  !:!  :!:  !:!     :!:  !:!  :!:  !:!     :!:  !:!  :!:  :!:       
	::   :::   :: ::::   ::: :::  ::::: ::   ::   ::     ::::: ::  ::   :::      :::: ::   ::   :: ::::  
	 :   : :  : :: ::    :: :: :   : :  :   ::    :       : :  :    :   : :     :: :  :   :    : :: ::   
	${NC}Give me a bash and... I'll change your fucking world
"
echo -e ""
echo
echo -e "${GREEN}[+] $(date)${NC}"
sleep 1

#----------------------------- VALIDACION DE NMAP ######################################

nmap=$(which nmap)
if [ "$?" -eq "1" ]; then
	echo "No se encontro nmap... Intenta con  sudo apt install nmap"
	exit 0
fi


########################################## INTERRUPCION DEL SCRIPT ######################################

trap ctrl_c INT		#LLAMADA A LA FUNCION DEL INTERRUPCION

function ctrl_c(){
	echo
	echo "$(tput setaf 3)[!] $(tput setaf 7) Saliendo del script madafaked..."
	sleep 1
	exit 1
} 
