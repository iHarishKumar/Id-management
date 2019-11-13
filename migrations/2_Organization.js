const Organization = artifacts.require("Organization");

module.exports = function(deployer) {
  deployer.deploy(Organization, {overwrite: false});
};
