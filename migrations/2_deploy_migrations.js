var NFT = artifacts.require("./NFT.sol");
//var AUCTIONFACTORY = artifacts.require("./NFTAuctionFactory.sol");
var AUCTION = artifacts.require("./NFTAuction.sol");

module.exports = function(deployer) {
  deployer.deploy(NFT);
  //deployer.deploy(AUCTIONFACTORY);
  deployer.deploy(AUCTION);
};

