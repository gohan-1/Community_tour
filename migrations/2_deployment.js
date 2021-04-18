const Migrations = artifacts.require("Community");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
