var MyContract = artifacts.require("CallRecover");

module.exports = function(deployer) {
    console.log("deployer stage 2");
    //deployer.deploy(MyContract);
    MyContract.deployed().then(a => {
      console.log(a);
      a.makeRecovery("123123",
      "0x928b8cc2b90eca19508aca884bd2fffee1465860f03c1856d3e74e728e262d2c16127dfc829a056acc69c8043562c1572321b4d263797b829b3dc8e1a47798c600");
    })
  };