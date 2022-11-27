const CompteBanque = artifacts.require("CompteBanque");
const VoitureCollection = artifacts.require("VoitureCollection");

module.exports = function(deployer) {
  deployer.deploy(CompteBanque);
  deployer.link(CompteBanque, VoitureCollection);
  deployer.deploy(VoitureCollection);
};
