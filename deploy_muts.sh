#!/bin/bash

declare -a sepolia_links

# Colores usando tput
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

echo "${BLUE}"
echo "█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓██▓█▓ S E  P O L I A  █▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█"
echo "${YELLOW}"
echo "█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓ INICIO COMPILACION  █▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓"
echo "${RESET}"
echo " "
echo " "

# Migrar en la red Ethereum sepolia Testnet y capturar la salida
truffle migrate --network eth_sepolia_testnet | tee migration_output_sepolia.txt

# Extraer las direcciones de los contratos para sepolia
ADDRESS_MemoriaUrbanaToken_sepolia=$(sed -n '/MemoriaUrbanaToken/,/contract address:/p' migration_output_sepolia.txt | grep 'contract address:' | awk '{print $4}')
ADDRESS_Market_Place_sepolia=$(sed -n '/Market_Place/,/contract address:/p' migration_output_sepolia.txt | grep 'contract address:' | awk '{print $4}')

echo "${GREEN}█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓ FIN COMPILACION  █▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓${RESET}"
echo " "
echo "${MAGENTA}█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓ INICIO VERIFICACION  █▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓${RESET}"

if [ -z "$ADDRESS_MemoriaUrbanaToken_sepolia" ] || [ -z "$ADDRESS_Market_Place_sepolia" ]; then
    echo "${RED}Error: No se pudo extraer las direcciones para sepolia.${RESET}"
else
    truffle run verify MemoriaUrbanaToken@$ADDRESS_MemoriaUrbanaToken_sepolia --network eth_sepolia_testnet
    sepolia_links+=("MemoriaUrbanaToken: https://sepolia.etherscan.io/address/$ADDRESS_MemoriaUrbanaToken_sepolia")
    echo "${CYAN}${sepolia_links[0]}${RESET}"
    
    echo " "

    truffle run verify Market_Place@$ADDRESS_Market_Place_sepolia --network eth_sepolia_testnet
    sepolia_links+=("Market_Place: https://sepolia.etherscan.io/address/$ADDRESS_Market_Place_sepolia")
    echo "${CYAN}${sepolia_links[1]}${RESET}"
fi
echo "${GREEN}█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓ FIN VERIFICACION  █▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓${RESET}"
echo " "

echo "${YELLOW}█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓██▓█▓ S E  P O L I A  █▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█▓█${RESET}"
echo "Enlaces al explorador de bloques sepolia:"
for link in "${sepolia_links[@]}"; do
    echo " "
    echo "${YELLOW}$link${RESET}"
    echo " "
done



