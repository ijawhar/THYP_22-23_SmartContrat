// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./CompteBanque.sol";

contract VoitureCollection is CompteBanque{

  struct Voiture{
        uint256 IdMatricule;
        string matricule;
        string nom;
        uint256 prix;
        StatusVoiture status;
        address vendeur;
        address acheteur;
        string imgVoiture;
    }

    enum StatusVoiture {Disponible, Vendu}

    // liste des voiture achetéé par une adresse du compte acheteur
    mapping (address => string[]) private listVoitureAcheter;

    // sauvegarde dans depot voiture
    mapping(string => Voiture) depotVoitures;

    //Liste des mtricules des voitures 
    string[] listeVoitures;

    address[20] listAcheteurs;

    uint256 nombreVoitures;
    

    constructor(){

        nombreVoitures = 0;
              ajouterVoiture(0,"A-12E4","JAGUAR Type E 4.2 Roadster - 1966",50,"");
              ajouterVoiture(1,"A-23F5","FIAT 500 Giardiniera -1972",100,"");
              ajouterVoiture(2,"A-34G6","1972 BMW 2002",30,"");
              ajouterVoiture(3,"A-45E7","FERRARI 360 MODENA F1 - 1999",40,"");
              ajouterVoiture(4,"A-56F8","MORRIS Mini COOPER 1000 MK2 - 1968",35,"");
              ajouterVoiture(5,"A-67G9","ROLLS ROYCE 20/25 HOOPER SPORT SALOON - 1932",60,"");
              ajouterVoiture(6,"A-78E10","JAGUAR MK2 3.8L - 1963",50,"");
              ajouterVoiture(7,"A-89F11","MG TA Midget - 1938",55,"");
              ajouterVoiture(8,"A-91G12","MERCEDES-BENZ 280 SL Pagode - 1970",25,"");
              ajouterVoiture(9,"A-101E13","FIAT 600 Cabriolet - 1973",40,"");
              
        }

        
    function isVide(string memory _chaine) pure private returns(bool _isVide){
        bytes memory bytesStringName = bytes(_chaine);
        if (bytesStringName.length == 0) {
            return true;
        } else {
            return false;
        }
    }
    function ajouterVoiture(uint256 _id, string memory _matricule,string memory _nom,uint256 _prix,string memory _imgVoiture) public isOwner() returns(bool ok)  {
        require(!isVide(_matricule), "le champ matricule est obligatoire.");
        require(!isVide(_nom),"Le champ nom est obligatoire.");
       // require(price > 0, "Le prix doit etre superieur à 0.");
        
        Voiture memory v = depotVoitures[_matricule];
        v.IdMatricule = _id;
        v.matricule = _matricule; 
        v.nom = _nom;
        v.prix = _prix;
        v.status = VoitureCollection.StatusVoiture.Disponible;
        v.vendeur = msg.sender;
        v.imgVoiture = _imgVoiture;
        listeVoitures.push(_matricule);  
        depotVoitures[_matricule] = v;
        nombreVoitures ++;
        return true;
}
    function getListVoitures() public view returns(string[] memory _listeVoitures){
        return listeVoitures;
    }
    
    function getVoitureByMatricule(string memory _matricule) private view returns(Voiture memory car){
        return depotVoitures[_matricule];   
    }

    function getVoitureStatutByMatricule(string memory _matricule) public view returns(string memory matricule,string memory nom, uint256 prix,string memory status,address acheteur,address vendeur,string memory imgVoiture){
        Voiture memory v = depotVoitures[_matricule];
        string memory statusTemp;
        if(v.status == StatusVoiture.Disponible){
            statusTemp = " Voiture disponible";
        }else if(v.status == StatusVoiture.Vendu){
            statusTemp = "Voiture vendu";
        }

        return (v.matricule,v.nom,v.prix,statusTemp,v.acheteur,v.vendeur,v.imgVoiture);
    }

    
    function getMyListVoitures() public view returns(string[] memory v){
        return listVoitureAcheter[msg.sender];
    }

    function acheterVoiture (string memory _matricule) public payable returns(bool success){
        Voiture memory v = getVoitureByMatricule(_matricule);

        //require(v.status == VoitureCollection.StatusVoiture.Disponible ," La voiture n'est pas disponible pour la vente");
        //require(msg.value >= v.prix," Vous n'avez pas assez d'argent pour acheter la voiture");

        //if (v.status == VoitureCollection.StatusVoiture.Disponible && msg.value >= v.prix)
        //{
            v.acheteur = msg.sender;
            v.status = VoitureCollection.StatusVoiture.Vendu;
            depotVoitures[_matricule] = v;
            listVoitureAcheter[msg.sender].push(v.matricule);
            transfer(msg.sender,getOwner(), v.prix);
            //payable(msg.sender).transfer(msg.value);
            return true;    
        //}
        //else
            //return false;
       
    }

    function acheter(uint matriculeId) public returns (uint) {
	  
	  listAcheteurs[matriculeId] = msg.sender;

	  return matriculeId;
	}

    function getAcheteurs() public view returns (address[20] memory) {
	  return listAcheteurs;
	}

    function getSoldeCompte() public view returns(uint256) {
      return getBalance(); 
} 
}
 