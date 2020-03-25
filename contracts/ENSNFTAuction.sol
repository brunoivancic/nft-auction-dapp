pragma solidity 0.5.11;

//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol';
//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';
//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol';

import './openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';
import './openzeppelin-solidity/contracts/math/SafeMath.sol';
import './openzeppelin-solidity/contracts/ownership/Ownable.sol';


contract ENSNFTAuction is ERC721, Ownable {
    
    using SafeMath for uint256;


    address payable public auction_owner;
    address payable public highest_bidder;
    address public NFTContractAddress;
    uint256 public highest_bid;
    string public name;
    string public Itemdescription;
    uint256 public NFTID;
    uint256 public _totalbids;
    uint public _totalbidders;
    uint public auctionEndTime;
    address payable ens_addr = 0x227Fcb6Ddf14880413EF4f1A3dF2Bbb32bcb29d7;  
    
    
   
    mapping (address => uint) private bidovi; 
    mapping (uint => address payable  ) private  bideri; 
    
    enum State {deafult, active, ended}
    State public auctionState;

    
    
    
    function GetAuctions() public view returns(string memory, string memory, address, uint256, State, uint256 time) { return (
        name,
        Itemdescription, 
        NFTContractAddress,
        NFTID,
        auctionState,
        time =auctionEndTime - now
        );
    }
    



    function CreateAuction (address _contractAddress, uint _tokenID, string memory _name, string memory _description, uint _biddingTime)
        public {
        
        ERC721 ERC721Instance = ERC721(ens_addr);
        require (msg.sender == ERC721Instance.ownerOf(_tokenID));
        ERC721Instance.transferFrom(msg.sender, address(this), _tokenID);
        
        auctionEndTime = now + _biddingTime;
        auctionState = State.active;
        name = _name;
        Itemdescription = _description;
        auction_owner = msg.sender;
        NFTContractAddress = _contractAddress;
        NFTID = _tokenID;
        _totalbidders == 0;
        
    }
    
    
    modifier IsNotOwner(){
        require(msg.sender != auction_owner);
        _;
        
    }
    
    function TimeToEnd () public {
        
        
        
    }

    function CancelAuction () public{
        require (msg.sender == auction_owner);
        require ( auctionState == State.active);
        require (now <= auctionEndTime);
        
        ERC721 ERC721Instance = ERC721(ens_addr);
        ERC721Instance.transferFrom(address(this), auction_owner , NFTID);
        
        for (uint i=0; i <= _totalbidders; i++){   
            uint amount;
            amount = bidovi[bideri[i]];
            
            bideri[i].transfer(amount);
            delete bideri[i];
            delete bidovi[bideri[i]];
            
        }
        
        auctionState = State.ended;
        _totalbidders = 0;
        _totalbids = 0;
        auctionEndTime = 0;
        highest_bidder = address(0);
    }


    function Bid() public payable IsNotOwner returns (bool){

        uint256 newbid = bidovi[msg.sender].add (msg.value);
        require (now <= auctionEndTime);
        require (msg.value > 0);
        require ( auctionState == State.active);       
        require (newbid > highest_bid);
        
        
        bidovi[msg.sender] = newbid;              
        highest_bidder = msg.sender;
        highest_bid = newbid;
        
        
        bideri[_totalbidders] = msg.sender;
        _totalbidders++;
        
        return true;
    }
    
    
    function EndAuction() public {
        require (msg.sender == auction_owner);
      
        require(now >= auctionEndTime);
        require ( auctionState == State.active);
        ERC721 ERC721Instance = ERC721(ens_addr);
            
         
        for (uint i=0; i <= _totalbidders; i++){       
         
           if(bideri[i] == highest_bidder){
               
                ERC721Instance.transferFrom(address(this), highest_bidder, NFTID);
                delete bideri[i];
                delete bidovi[bideri[i]];
               
            }
           else {
                uint amount;
                amount = bidovi[bideri[i]];
                    
                bideri[i].transfer(amount);
                delete bideri[i];
                delete bidovi[bideri[i]];
                }
         
        }
        
        
    address payable sendto;
    uint amount;

    sendto = auction_owner;
    amount = highest_bid;

    sendto.transfer(amount);
    
    auctionState = State.ended;
    _totalbidders = 0;
    _totalbids = 0;
    auctionEndTime = 0;
    highest_bidder = address(0);
    
    }


}
