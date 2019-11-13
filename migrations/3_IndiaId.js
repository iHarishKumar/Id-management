const IndiaId = artifacts.require("IndiaId");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(IndiaId, "0x676d2254Ea562B34db575d13A08FF75b6a5FDbf5", {from: accounts[1], overwrite: true});
};
