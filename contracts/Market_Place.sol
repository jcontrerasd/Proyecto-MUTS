// SPDX-License-Identifier: MIT


// En resumen permite comprar y vender tokens ERC721.

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Market_Place is ERC1155 {
    mapping(uint256 => uint256) private prices;
    address private _NFT_Address;
    IERC721 items;
    uint256 public _itemsForSale;
    address payable public marketplaceOwner; // Dirección del propietario del contrato Market_Place
    // uint256 public commissionFunds; // Variable para almacenar los fondos de la comisión



    // Evento para registrar cuando se pone un token a la venta..
    event TokenSetForSale(address indexed owner, uint256 tokenId, uint256 price);

    // Evento para registrar cuando se quita un token de la venta
    event TokenUnsetForSale(address indexed owner, uint256 tokenId);

    // Evento para registrar una compra exitosa
    event TokenPurchased(address indexed buyer, address indexed seller, uint256 tokenId, uint256 price);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Evento para notificar cuando se propone una comisión
    event CommissionProposed(address indexed seller, uint256 tokenId, uint256 price, uint256 commission);

    // Evento para registrar si el vendedor aceptó o rechazó la comisión
    event CommissionAccepted(address indexed seller, uint256 tokenId, bool accepted);

    // Mapping para almacenar las comisiones pendientes de aprobación
    mapping(uint256 => uint256) private pendingCommissions;

    // Función para proponer una comisión al vendedor antes de poner el NFT a la venta
function proposeCommission(uint256 _tokenId, uint256 _price) public {
    require(items.ownerOf(_tokenId) == _msgSender(), "Solo el propietario del NFT puede proponer una comision.");
    uint256 commission = (_price * 25) / 1000; // Calcular la comisión del 2,5%
    pendingCommissions[_tokenId] = commission;
    emit CommissionProposed(_msgSender(), _tokenId, _price, commission);
}

// Función para que el vendedor acepte o rechace la comisión propuesta
function acceptCommission(uint256 _tokenId, bool _accepted) public {
    require(items.ownerOf(_tokenId) == _msgSender(), "Solo el propietario del NFT puede aceptar/rechazar la comision.");
    require(pendingCommissions[_tokenId] > 0, "No hay comision pendiente para este NFT.");
    emit CommissionAccepted(_msgSender(), _tokenId, _accepted);
    if (_accepted) {
        setSale(_tokenId, prices[_tokenId]);
    } else {
        delete pendingCommissions[_tokenId];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    constructor(address NFT_Address) ERC1155("") {
        _NFT_Address = NFT_Address;
        items = IERC721(_NFT_Address);
        marketplaceOwner = payable(msg.sender); // Establecer el propietario del contrato
    }

    // function setSale(uint256 _tokenId, uint256 _price) public {
    //     require(items.ownerOf(_tokenId) == _msgSender(), "Solo el Owner puede poner a la Venta.");

    //     prices[_tokenId] = _price;

    //     // Emitir evento cuando se pone un token a la venta
    //     emit TokenSetForSale(_msgSender(), _tokenId, _price);
    // }
    // Modificar la función setSale para que solo se pueda llamar después de aceptar la comisión
    function setSale(uint256 _tokenId, uint256 _price) public {
    require(items.ownerOf(_tokenId) == _msgSender(), "Solo el propietario del NFT puede poner a la venta.");
    // require(pendingCommissions[_tokenId] > 0, "Debe aceptar la comision antes de poner el NFT a la venta.");
    prices[_tokenId] = _price;
    // delete pendingCommissions[_tokenId];
    emit TokenSetForSale(_msgSender(), _tokenId, _price);
}


    function unsetSale(uint256 _tokenId) public {
        require(items.ownerOf(_tokenId) == _msgSender(), "Solo el Owner puede retirar la Venta.");
        prices[_tokenId] = 0;

        // Emitir evento cuando se quita un token de la venta
        emit TokenUnsetForSale(_msgSender(), _tokenId);
    }

    // function buyToken(uint256 _tokenId) public payable {
    //     uint256 price = prices[_tokenId];
    //     // Verificar si el token está en venta
    //     require(price > 0, "El NFT no esta a la venta");
    //     // Verificar que el valor enviado es el correcto
    //     require(msg.value == price, "Fondos enviados insuficientes");
    //     // Obtener la dirección del dueño del token
    //     address tokenOwner = items.ownerOf(_tokenId);
    //     // Verificar que el comprador no sea el mismo que el vendedor
    //     require(tokenOwner != msg.sender, "No puedes comprarte tu propio NFT");
    //     // Transferir el token al comprador
    //     items.transferFrom(tokenOwner, msg.sender, _tokenId);
    //     // Transferir el ether al vendedor
    //     payable(tokenOwner).transfer(msg.value);
    //     // Eliminar el token del mercado
    //     prices[_tokenId] = 0;
    //     // Emitir evento de compra exitosa
    //     emit TokenPurchased(msg.sender, tokenOwner, _tokenId, price);
    // }


// Modificar la función buyToken para descontar la comisión al vendedor
function buyToken(uint256 _tokenId) public payable {
    uint256 price = prices[_tokenId];
    require(price > 0, "El NFT no esta a la venta");
    require(msg.value == price, "Fondos enviados insuficientes");
    address tokenOwner = items.ownerOf(_tokenId);
    require(tokenOwner != msg.sender, "No puedes comprarte tu propio NFT");

    uint256 commission = (price * 25) / 1000; // Calcular la comisión del 2.5%
    uint256 sellerAmount = price - commission; // Monto a pagar al vendedor después de descontar la comisión

    items.transferFrom(tokenOwner, msg.sender, _tokenId);
    payable(tokenOwner).transfer(sellerAmount);
    prices[_tokenId] = 0;
    marketplaceOwner.transfer(commission);

    emit TokenPurchased(msg.sender, tokenOwner, _tokenId, price);
}


    // // Función para recibir la comisión
    // function receiveCommission(uint256 commission) internal {
    //     commissionFunds += commission;
    // }

    // Función para obtener el precio de un NFT en la unidad especificada
    function getPrice(uint256 _tokenId) public view returns (uint256) {
        return prices[_tokenId];
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
