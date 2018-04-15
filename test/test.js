

var MyContract = artifacts.require("Recover");

// const web3 = new Web3();
module.exports = function(callback) {
    // perform actions
    console.log(web3);
    
    console.log(web3.eth.defaultAccount = web3.eth.accounts[0]);
    console.log("data", web3.eth.sign(web3.eth.accounts[0], "123123"));

    console.log("account: ", web3.eth.accounts[0]);

    MyContract.deployed().then( a => {
        console.log(a);
        a.makeRecovery( m("123123"), "0x928b8cc2b90eca19508aca884bd2fffee1465860f03c1856d3e74e728e262d2c16127dfc829a056acc69c8043562c1572321b4d263797b829b3dc8e1a47798c600");
        console.log(a.addrRecovered());
    })

    //web3.eth.call({to: '0x8cdaf0cd259887258bc13a92c0a6da92698644c0'})

    //web3.eth.call('CONTRACT', '0x928b8cc2b90eca19508aca884bd2fffee1465860f03c1856d3e74e728e262d2c16127dfc829a056acc69c8043562c1572321b4d263797b829b3dc8e1a47798c600')
  }
