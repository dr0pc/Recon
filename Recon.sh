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

########################################## INICIO DEL SCRIPT ######################################
for targets in $(cat $1)	#LECTURA DEL CONTENDIO DEL ARCHIVO CON SEGMENTOS IP
do

	dir=$(echo $targets | tr '/' '_' )	#CONVERSION DE / (1.1.1./24) A _ (1.1.1.1_24) 	

	dirmk=$(ls $dir 2>/dev/null)		#VALIDACION SI EXISTE UN DIRECTORIO CON EL NOMBRE DEL SEGMENTO EJE 10.10.10.10_24
	if [ "$?" != "0" ]; then		#EN EL CASO QUE NO EXISTA LA CARPETA SE CREA, SI EXISTE UNICAMENTE SE INGRESA 
		mkdir $dir
	fi
	

	cd $dir					#ACCESO AL DIRECOTORIO CON NOMBRE DEL SEGMENTO
	
	echo -e "${BLUE}[*] Realizando Recon en $targets un moment plis :3"
	nmap -sn $targets -oN NMAP_RECON_$dir >/dev/null  2>&1 						#RECON CON NMAP
	cat NMAP_RECON_$dir|  grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u >> IPS$dir	#EXTRACCION DE IPS DEL OUTPUT NMAP
	echo -e "${CYAN}    [+] Se encontraron $(wc IPS$dir| awk '{print $1}' ) IPS"
	sleep 1
	echo
	cd ..					#SALIENDO A LA CARPETA PRINCIPAL
	cat $dir/IPS$dir >> TOTAL_IPS		#CANTIDAD DE IPS ENCONTRADAS EN EL SEGMENTO

done
	
echo -e "${PURPLE}[+] Se encontro un total de $(wc TOTAL_IPS| awk '{print $1}' ) IPS"	#TOTAL DE IPS ENCONTRADAS

