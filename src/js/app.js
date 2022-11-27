App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    // Load voiture.
    $.getJSON('../voitures.json', function(data) {
      var voituresRow = $('#voituresRow');
      var voitureTemplate = $('#voitureTemplate');

      for (i = 0; i < data.length; i ++) {
        voitureTemplate.find('.Id').text(data[i].id);
        voitureTemplate.find('.panel-title').text(data[i].nom);
        voitureTemplate.find('img').attr('src', data[i].imgVoiture);
        voitureTemplate.find('.matricule').text(data[i].matricule);
        voitureTemplate.find('.prix').text(data[i].prix);
        voitureTemplate.find('.statusVoiture').text(data[i].status);
        voitureTemplate.find('.vendeur').text(data[i].vendeur);
        voitureTemplate.find('.acheteur').text(data[i].acheteur);
        voitureTemplate.find('.btn-acheter').attr('data-id', data[i].id);
        voituresRow.append(voitureTemplate.html());
      }
    });


    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('VoitureCollection.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var VoitureCollectionArtifact = data;
      App.contracts.VoitureCollection = TruffleContract(VoitureCollectionArtifact);
  
      // Set the provider for our contract
      App.contracts.VoitureCollection.setProvider(App.web3Provider);
  
      // Use our contract to retrieve and mark the adopted pets
      return App.markVendu();
    });
  
      return App.bindEvents();
    },
  

  bindEvents: function() {
    $(document).on('click', '.btn-acheter', App.acheter);
  },

  markVendu: function() {
    var voitureCollectionInstance;

    App.contracts.VoitureCollection.deployed().then(function(instance) {
      voitureCollectionInstance = instance;

      return voitureCollectionInstance.getAcheteurs.call();
    }).then(function(listAcheteurs) {
      for (i = 0; i < listAcheteurs.length; i++) {
        if (listAcheteurs[i] !== '0x0000000000000000000000000000000000000000') {
          $('.panel-voiture').eq(i).find('.btn-acheter').hide();
          $('.panel-voiture').eq(i).find('.statusVoiture').text("Vendu");
          $('.panel-voiture').eq(i).find('.acheteur').text(listAcheteurs[i].substring(0,16));
        } else {
          $('.panel-voiture').eq(i).find('.btn-acheter').show();
          $('.panel-voiture').eq(i).find('.statusVoiture').text("Disponible");
          $('.panel-voiture').eq(i).find('.acheteur').text("");
        }
      }
    }).catch(function(err) {
      console.log(err.message);
    });
  },

  acheter: function(event) {
    event.preventDefault();

    var matriculeId = parseInt($(event.target).data('id'));
    var voitureCollectionInstance;

    web3.eth.getAccounts(function(error, accounts) {  
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      

      App.contracts.VoitureCollection.deployed().then(function(instance) {
        voitureCollectionInstance = instance;

        // Execute adopt as a transaction by sending account
        return voitureCollectionInstance.acheter(matriculeId, {from: account});
      }).then(function(result) {
        return App.markVendu();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});