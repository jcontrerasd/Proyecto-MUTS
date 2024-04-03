
# 🌐 **APLICACIÓN DApp Web3 MUTs** 🚀

# 🌆 Marketplace Memoria Urbana MUTs 🖼️
---

# Índice

- [1.- ARQUITECTURA GENERAL](#1--arquitectura-general)
- [2.- DESPLIEGUE DE PRODUCTO](#2--despliegue-de-producto)
  - [2.1.- Script deploy_muts.sh](#21--script-deploy_mutssh)
  - [2.2.- Compilación/Despliegue/Verificación](#22--compilacióndespliegueverificación)
- [3.- MANEJO DE EVENTOS (Event/Emit)](#3--manejo-de-eventos-eventemit)
  - [3.1.- EVENT SMART CONTRACT MEMORIAURBANATOKEN.SOL](#31--event-smart-contract-memoriaurbanatokensol)
  - [3.2.- EVENT SMART CONTRACT MARKET_PLACE.SOL](#32--event-smart-contract-market_placesol)
- [4.- USO DE IPFS NFT.Storage y METADATOS del NFT](#4--uso-de-ipfs-nftstorage-y-metadatos-del-nft)
- [5.- DESPLIGUE DE DApp EN IPFS USANDO NFT.Storage](#5--despligue-de-dapp-en-ipfs-usando-nftstorage)
- [6.- SMART CONTRACTS](#6--smart-contracts)
  - [6.1.- MemoriaUrbanToken](#61--memoriaurbantoken)
    - [6.1.1.- Read Contract](#611--read-contract)
    - [6.1.2.- Write Contract](#612--write-contract)
  - [6.2.- Marketplace](#62--marketplace)
    - [6.2.1.- Read Contract](#621--read-contract)
    - [6.2.2.- Write Contract](#622--write-contract)


---
## 1.- ARQUITECTURA GENERAL
---
> - **MetaMask:** _Actúa como puerta de entrada a la Blockchain, permitiendo la gestión de redes, cuentas y transacciones._
> - **Ethereum:** _La cadena de bloques principal, junto con Sepolia para pruebas._
> - **Truffle Suite:** _Herramienta para el desarrollo de Smart Contract._
> - **OpenZeppelin:** _Proporciona librería de Smart Contract seguros y probados._
> - **NFT.storage (IPFS):** _Garantiza la persistencia descentralizada de archivos, esencial para NFTs.


<img width="400" alt="image" src="https://github.com/jcontrerasd/Proyecto-MUTS/assets/27821228/4a34c4bc-b4c4-4fff-80ad-e7dfc92a8a04" style="display: block; margin-left: auto; margin-right: auto;">

> - **React:** _Framework JavaScript para la creación de interfaces de usuario interactivas y dinámicas_
> - **Material UI:** _Biblioteca de componentes de interfaz de usuario que facilita el desarrollo y mantiene la consistencia visual._
> - **Three.js:** _Biblioteca JavaScript para la creación de gráficos 3D en el navegador web, utilizada para la visualización de NFTs en el metaverso._
> - **Web3.js:** _Biblioteca JavaScript para la interacción con la BlockChain Ethereum, permitiendo la conexión con MetaMask y la gestión de NFTs._

<img width="400" alt="image" src="https://github.com/jcontrerasd/Proyecto-MUTs/assets/27821228/c2207e77-2082-4b7e-bb77-c6cb9e4d743f" style="display: block; margin-left: auto; margin-right: auto;">


---

## 2.- DESPLIEGUE DE PRODUCTO
---

Incorpora la automatización de la compilación, implementación y verificación de los Smart Contracts en la red Sepolia.

### 2.1.- Script deploy_muts.sh

<details>
<summary>deploy_muts.sh ⚙️</summary>

```js
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

```
</details>

### 2.2.- Compilación/Despliegue/Verificación
### 🎥 [Compilación/Despliegue/Verificación](https://github.com//jcontrerasd/Proyecto-MUTS/raw/main/0.-Compilación+Despliegue+Verificación[Sepolia].mp4)

<img width="800" alt="image" src="https://github.com/jcontrerasd/Proyecto-MUTs/assets/27821228/d24c06be-f4de-4112-9f57-16b430907d2d" style="display: block; margin-left: auto; margin-right: auto;">


---
<details>
<summary>1_deploy_contracts.js SMART CONTRACT ⚙️</summary>

```js
var MemoriaUrbanaToken = artifacts.require("./MemoriaUrbanaToken.sol");
var Market_Place = artifacts.require("./Market_Place.sol");

// El deploy debe ser anidado, dado que el contrato Marketplace requiere el contrato con el que
// estará vinculado

module.exports = function (deployer) {

  deployer.deploy(MemoriaUrbanaToken).then(function () {      
      return deployer.deploy(Market_Place, MemoriaUrbanaToken.address);
  });
};
```
</details>

> _Es importante tener en cuenta que los Smart Contracts están interconectados, por lo tanto, se requiere una configuración específica para la migración. En esta configuración, la Address del contrato MemoriaUrbanaToken se utiliza para el despliegue del Contrato Market_Place._

---
## 3.- MANEJO DE EVENTOS (Event/Emit)

---

### 3.1.- EVENT SMART CONTRACT MEMORIAURBANATOKEN.SOL
<img width="600" alt="image" src="https://github.com/jcontrerasd/Proyecto-MUTs/assets/27821228/0a837ac8-f13e-438b-8ee3-1ef29612d9ab"  style="display: block; margin-left: auto; margin-right: auto;">


### 3.2.- EVENT SMART CONTRACT MARKET_PLACE.SOL
<img width="600" alt="image" src="https://github.com/jcontrerasd/Proyecto-MUTs/assets/27821228/0bf4ffcb-8014-48f6-80d0-8478ce83a3ed" style="display: block; margin-left: auto; margin-right: auto;">

---
## 4.- USO DE IPFS NFT.Storage y METADATOS del NFT.
---
* ## Beneficio : Persistir los activos (NFT) que se vayan generando en el tiempo.
* ## 📽️ [Video Demostrativo Uso NFT.Storage](https://github.com//jcontrerasd/Proyecto-MUTS/raw/main/4.-IPFS_NFT.Storage_y_Metadatos_del_NFT.mp4)

    <img width="500" alt="image" src="https://github.com/jcontrerasd/Proyecto-MUTS/assets/27821228/6227242b-36ab-4e54-9fac-aa1fa64cb275" style="display: block; margin-left: auto; margin-right: auto;">

---
## 5.- DESPLIGUE DE DApp EN IPFS USANDO NFT.Storage
(❌❌❌ACTUALIZAR VIDEO Y LINK CON LA NUEVA INTERFAZ❌❌❌❌)
---
* ## Beneficio : Aumentar la tolerancia a fallos y la resiliencia en general.
* ## 📽️ [Video Demostrativo Despliegue Dapps Nfts.Storage](https://github.com//jcontrerasd/Proyecto-MUTS/raw/main/4.-Despliegue_de_Dapps_en_IPFS_usando_NFT.Storage.mp4)
    * ### [IPFS URL](https://bafybeid45lnfoihkit7igqlm2tv456y53ozytnfpp6spgtvgikhax56wjq.ipfs.nftstorage.link/)

    <img width="500" alt="image" src="https://github.com/jcontrerasd/Proyecto-MUTS/assets/27821228/5b894d90-8ef9-4f06-ace0-38d1b67ff54b" style="display: block; margin-left: auto; margin-right: auto;">

---
## 6.- SMART CONTRACTS
---

### 6.1.- MemoriaUrbanToken 
#### (Address [0x0B792DeefBc6f202c78cb34F8C3B4d186f6b2832](https://sepolia.etherscan.io/address/0x0B792DeefBc6f202c78cb34F8C3B4d186f6b2832)) 

El contrato crea un token ERC721 llamado MemT (MUT). El contrato puede ser utilizado para crear nuevos tokens, aprobar la custodia del NFT a un contrato que permita custodiar el NFT y comercializarlo.

#### 6.1.1.- Read Contract

**1. balanceOf :** _Devuelve la cantidad de un token que posee una dirección._
**2. getApproved :** _Devuelve la dirección que está autorizada para transferir un token en nombre de otra dirección._
**3. isApprovedForAll :** _Devuelve si una dirección está autorizada para transferir todos los tokens en nombre de otra dirección._
**4. name :** _Devuelve el nombre del token.
**5. ownerOf :** _Devuelve la dirección del propietario de un token._
**6. supportsInterface :** _Devuelve si un contrato implementa una interfaz._
**7. symbol :** _Devuelve el símbolo del token._
**8. tokenURI :** _Devuelve la URI del token._

#### 6.1.2.- Write Contract

**1. approve :** _Autoriza a una dirección para transferir un token en nombre de otra dirección._
**2. approveToMarketplace :** _Autoriza a un mercado para transferir un token en nombre de un usuario.
**3. awardItem :** _Crea un nuevo token y lo asigna a una dirección especificada._
**4. safeTransferFrom :** _Transfiere un token de una dirección a otra de forma segura, verificando que la transferencia es válida y que el receptor tiene suficiente saldo._
**5. safeTransferFrom :** _Transfiere un token de una dirección a otra de forma segura, verificando que la transferencia es válida y que el receptor tiene suficiente saldo._
**6. setApprovalForAll :** _Autoriza a una dirección para transferir todos los tokens en nombre de otra dirección._
**7.transferFrom :** _Transfiere un token de una dirección a otra._

#### ⚠️ IMPORTANTE 

**4.safeTransferFrom() (ERC721) :** _Transfiere un token de una dirección a otra. No verifica que el receptor tenga suficiente saldo._
**5.safeTransferFrom() (OpenZeppelin) :** _Transfiere un token de una dirección a otra de forma segura. 
                                                Verifica que el receptor tenga suficiente saldo y que el remitente esté autorizado para transferir el token._

### 6.2.- Marketplace
#### (Address [0xf290c169C0184adb2cCc5BAC23cf91Ff72cDdE30](https://sepolia.etherscan.io/address/0xf290c169C0184adb2cCc5BAC23cf91Ff72cDdE30))
Corresponde a un MarketPlace que permite a los usuarios comprar y vender tokens ERC721. En resumen permite comprar y vender tokens ERC721.


#### 6.2.1.- Read Contract 

**1. itemsForSale:** _Variable de estado que cuenta el número de NFTs en venta._
**2. balanceOf:** _Devuelve la cantidad de un token que posee una dirección._
**3. balanceOfBatch:** _Devuelve la cantidad de un token que poseen varias direcciones._
**4. getPrice:** _Devuelve el precio de un NFT en wei._
**5. isApprovedForAll:** Devuelve si una dirección está aprobada para transferir tokens en nombre de otra dirección._
**6. marketplaceOwner:** _Dirección del propietario del contrato Market_Place._
**7. supportsInterface:** _Devuelve si un contrato implementa una interfaz ERC721._
**8. uri:** _Devuelve la URI de un NFT._


#### 6.2.2.- Write Contract 

**1. acceptCommission:** _Permite al propietario del NFT aceptar o rechazar la comisión propuesta. Si se acepta la comisión, el NFT se pone a la venta automáticamente. Si se rechaza, la comisión pendiente se elimina._
**2. buyToken:** _Compra un NFT ERC721 del mercado, pagando el precio especificado por el vendedor. Ahora, cuando se compra un NFT, se calcula la comisión (2.5% del precio de venta) y se descuenta del monto que recibe el vendedor. La comisión se transfiere al propietario del mercado (marketplaceOwner)._
**3. onERC721Received:** _Recibe un NFT ERC721 en el contrato, verificando que el remitente está autorizado para transferirlo._
**4. proposeCommission:** _Permite al propietario de un NFT proponer una comisión al vendedor antes de poner el NFT a la venta. La comisión se calcula como un porcentaje del precio de venta (en este caso, el 2.5%)._
**5. safeBatchTransferFrom:** _Transfiere un lote de tokens ERC1155 de una dirección a otra de forma segura, verificando que la transferencia es válida y que el receptor tiene suficiente saldo._
**6. safeTransferFrom:** _Transfiere un token ERC721 de una dirección a otra de forma segura, verificando que la transferencia es válida y que el receptor tiene suficiente saldo._
**7. setApprovalForAll:** _Aprueba a una dirección para transferir todos los tokens ERC721 en nombre de otra dirección, otorgando permiso a un mercado para vender los tokens ERC721 de un usuario._
**8. setSale:** _Pone un NFT ERC721 a la venta en el mercado, especificando el precio al que se quiere vender. Ahora, antes de poner un NFT a la venta, se debe proponer y aceptar una comisión._
**9. unsetSale:** _Elimina un NFT ERC721 de la venta en el mercado, permitiendo al propietario eliminarlo en cualquier momento._


