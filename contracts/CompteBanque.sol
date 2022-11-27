
// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract CompteBanque {

mapping(address => uint256) balance;
address owner; 

constructor() { 

owner = msg.sender; 
 
} 

modifier isOwner(){
        require(owner == msg.sender, " cette fonctionalite n'est autorisee que pour le proprietaire du contrat");
        _;
    }

function getBalance() public view returns(uint256)  {
 return balance[msg.sender]; 
} 

function setBalance(uint256 montant) public returns(uint256)  {
 return balance[msg.sender] += montant; 
} 

function getOwner() public view returns(address) {
 return owner; 
} 


function transfer(address acheteur, address  vendeur, uint256 montant) public { 
  //require( balance[msg.sender]>=montant, "Le solde du compte est insuffisant"); 
  require(acheteur != vendeur, "Vous pouvez pas transferer de l'argent a vous meme");
    balance[acheteur] -= montant;
    balance[vendeur] += montant; 
}

    receive() external payable{
        balance[msg.sender] +=  msg.value;
    }

}