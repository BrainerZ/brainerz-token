var MyContract = artifacts.require("BrainerzToken");

module.exports = function(deployer) {
    console.log("deployer stage 2");
    deployer.deploy(MyContract);
  };