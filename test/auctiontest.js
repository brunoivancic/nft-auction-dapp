var Market = artifacts.require("./NFTAuction.sol");
var NFT = artifacts.require("./NFT.sol");
var ERC721Token = artifacts.require("./contracts/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol");

contract ('Market', function (accounts){


  it("mint NFT tokenId 1 to account[0]", function() {
        return NFT.deployed().then(function(instance) {
          NFTInstance = instance;
    
          return NFTInstance.Mint('My Crypto Collectible','description', accounts[0], 1, 'metadata', {from: accounts[0]});
        })
  });


  it("account[0] can approve Auctioncontract ", function() {
    return NFT.deployed().then(function(instance) {
    NFTInstance = instance;
    
    return Market.deployed();
    }).then(function(instance) {
      MarketInstance = instance;
      return NFTInstance.approve(MarketInstance.address, 1, {from: accounts[0]});
      });
  });
    

  it("AUCTION takes ownership of account 0 NFT ID 1 and starts auction ", function() {
    return NFT.deployed().then(function(instance) {
    NFTInstance = instance;
    return Market.deployed();
    }).then(function(instance) {
      MarketInstance = instance;
      return MarketInstance.CreateAuction('MY NFT','my nft description',3, NFTInstance.address, 1 ,{from: accounts[0]});
    }).then(function(res) {
      return NFTInstance.ownerOf(1);
    }).then(function(account) {
      assert.equal(account, MarketInstance.address, "The NFT is not owned by AUCTION contract.");
    });
  });


  it("account[1] can bid 4 ETH on auction] ", function() {
    return NFT.deployed().then(function(instance) {
      NFTInstance = instance;

      return Market.deployed();
    }).then(function(instance) {
        MarketInstance = instance;
        MarketInstance.Bid( {from: accounts[1], value: 4000000000000000000}); //4eth
    });
  });


  it("account[2] can bid 5 ETH on auction] ", function() {
    return NFT.deployed().then(function(instance) {
      NFTInstance = instance;

      return Market.deployed();
    }).then(function(instance) {
        MarketInstance = instance;
        MarketInstance.Bid( {from: accounts[2], value: 5000000000000000000}); //5eth
    });
  });
  it("account[3] can bid 7 ETH on auction] ", function() {
    return NFT.deployed().then(function(instance) {
      NFTInstance = instance;

      return Market.deployed();
    }).then(function(instance) {
        MarketInstance = instance;
        MarketInstance.Bid( {from: accounts[3], value: 7000000000000000000}); //7eth
    });
  });

  it("account[1] can bid 4 ETH on auction] ", function() {
    return NFT.deployed().then(function(instance) {
      NFTInstance = instance;

      return Market.deployed();
    }).then(function(instance) {
        MarketInstance = instance;
        MarketInstance.Bid( {from: accounts[1], value: 4000000000000000000}); //4eth
        
      });
      });

  function sleep(seconds) 
{
  var e = new Date().getTime() + (seconds * 1000);
  while (new Date().getTime() <= e) {}
}

  it("account[0] can end auction and accounts 2 and 3 can Withdraw", function() {
    return NFT.deployed().then(function(instance) {
    NFTInstance = instance;

    return Market.deployed();
  }).then(function(instance) {
    MarketInstance = instance;
    
      
    sleep(4);
    MarketInstance.EndAuction({from: accounts[0]});
    MarketInstance.Withdraw({from: accounts[3]});
    MarketInstance.Withdraw({from: accounts[2]});
  }).then(function(res) {
    return NFTInstance.ownerOf(1);
  }).then(function(account) {
    console.log('owner of nft is', account);
    assert.equal(account, accounts[1], "The NFT is not owned by highest bidder.");
    })
  });
});






