// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contracts/Mytoken.sol";

contract TokenSender {

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    mapping(bytes32 => bool) executed;

    function getHash(address from, uint amount, address to, address token, uint nonce) public pure returns(bytes32 hash){

        hash = keccak256(abi.encodePacked(from, amount, to, token, nonce));
    }

    function transfer(address from, uint amount, address to, address token, uint nonce, bytes memory signature) public {

        bytes32 hash = getHash(from, amount, to, token, nonce);

        bytes32 ethSignedHash = hash.toEthSignedMessageHash();

        require(!executed[ethSignedHash], "Already Executed!!!");

        require(ethSignedHash.recover(signature) == from, "Signature Doesn't Belong to Sender!!!");

        executed[ethSignedHash] = true;

        bool success = IERC20(token).transferFrom(from, to, amount);

        require(success, "Transfer Failed!");
    }
}

// From: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
// Amount: 5500000000000000000000;
// To: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
// Hash: 0x27df693a2787385f9c8efd019838620f3d95f5a4601677bf0cc981672b4e52c7;
// Signature:  ;

// HASH : 0x761cfef2e9134996094b8b2d1d80dd1bc501b85377bbbb79aafc607238b9aa98 ;
// SIGNATURE : 0x094ed263a5505ab75034f3ece3ef25eb79a265d6b363bd98cc96430af4797f3e50f87eb8d69494a70a4b855c148027140289309ef337e04097ad7cb353b1ad8b1b ;

