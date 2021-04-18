const Migrations = artifacts.require("CommunityTour");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
