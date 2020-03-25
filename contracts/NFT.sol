pragma solidity 0.5.11;

//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol';
//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol';
//import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';


import './openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';
import './openzeppelin-solidity/contracts/ownership/Ownable.sol';
import './openzeppelin-solidity/contracts/math/SafeMath.sol';

contract NFT is Ownable, ERC721  {

    using SafeMath for uint256;

    string public description;
    string public name;
    string public constant symbol = "UNFT";

    address  NFTowner;

    mapping (uint256 => string) private metaData;
    mapping (uint256 => address)  NFTowners;


    function TokenMetadata (uint256 _tokenId) external view  returns (string memory) {
        string memory _tokenURL = metaData[_tokenId];
        return _tokenURL;
    }
  

    function Mint (string memory _name, string memory _description,address _to, uint256 _tokenId, string memory _tokenURL) onlyOwner public {
        require(_to != address(0));
        name = _name;
        description = _description;
        _mint(_to, _tokenId);
     
        metaData[_tokenId] = _tokenURL;
     
        NFTowners[_tokenId]= _to;
     
    }
  

}


