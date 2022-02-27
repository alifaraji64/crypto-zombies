const ZombieHelper = artifacts.require("ZombieHelper");
//const SafeMath = artifacts.require("SafeMath");
//const Ownable = artifacts.require("Ownable");

module.exports = function(deployer) {
  //deployer.deploy(ConvertLib);
  //deployer.link(ConvertLib, MetaCoin);
  //or we can use this method to link the library to an array of contracts
  deployer.deploy(ZombieHelper);
};
