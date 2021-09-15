//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract VolcanoToken is ERC721("Volcano","VTN"), Ownable{
    uint256 tokenID;
    
    
    struct Metadata{
        uint256 tokenID;
        uint256 timestamp;
        string tokenURI;
    }
    
    mapping(address => Metadata[]) tokenOwners;
    
     function getTokenID() internal returns (uint256) {
        uint256 newTokenID = tokenID;
        tokenID++;
        return newTokenID;
    }
    
       function purgeMetadata(uint256 tokenID) internal {
       for(uint256 i=0; i<tokenOwners[msg.sender].length; i++) {
            if(tokenOwners[msg.sender][i].tokenID == tokenID) {
                delete tokenOwners[msg.sender][i];
            }
        }
    }

    function safemint(address user, string memory tokenURI) public {
        uint256 tokenID = getTokenID();
        _safeMint(user, tokenID);

        tokenOwners[user].push(
            Metadata({timestamp: block.timestamp, tokenID: tokenID, tokenURI: tokenURI})
        );
    }

    function burnToken(uint256 tokenID) public {
        require(ownerOf(tokenID) == msg.sender, "Only owner is  allowed");
        _burn(tokenID);
        purgeMetadata(tokenID);
    }

 
    
}