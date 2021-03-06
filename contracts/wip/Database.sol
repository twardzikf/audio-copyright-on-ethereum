// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;

import  './Property.sol';
import  './Auction.sol';

contract Database {

    // maps owners to their properties
    mapping(address => Property[]) public ownerToHashes;
    // intellectual property Database - storing all Properties (music files)
    mapping(string => address) public hashDatabase;
    // stores properties that are for sale - to avoid loops
    Property[] itemsForSale;
    
    mapping(string => Auction) public hashToAuction;
    Auction[] auctions;


    //displays selling properties
   function getItemsForSale() public view returns  (Property[] memory){
       return itemsForSale;
   }

    function addProperty(string memory hash) public payable returns (Property) {
       require(hashDatabase[hash]==address(0x0),"Hash already exists in the Database!");

        Property pnew = new Property(hash,msg.sender,address(this));
        hashDatabase[hash] = address(pnew);
        ownerToHashes[msg.sender].push(pnew);
        return pnew;
    }

    function buyProperty(string memory _hash) public payable {
        require(hashDatabase[_hash]!=address(0x0),"Hash doesnt exist");
        Property p = Property(address(hashDatabase[_hash]));
        require(p.owner()!=msg.sender, "Owner cannot buy his own property");
        //call buy function and pass the money to the buy function...
        address oldOwner = p.owner(); //need it for later to remove property from his list
        p.buy.value(msg.value)(msg.sender); //<- this is how you forward the money to the next function/contract

        //if we are here that means the property got sold
        //remove from listing
        removeProperty(itemsForSale,p.sellingIndex());
        //remove from old-owners list
        removeProperty(ownerToHashes[oldOwner],p.ownersIndex());
        //add to new owners list and update owners index inside the property
        p.setOwnersIndex(ownerToHashes[p.owner()].push(p)-1);
    }

    function removeProperty(Property[] storage list, uint index) private {
        if (list.length > 1) {
            //if more than one element, switch last with the item to remove
            list[index] = list[list.length-1];
        }
        //decrease list size
        //list.length--;
        list.pop();
    }
    
    function removeAuction(Auction[] storage list, uint index) private {
        if (list.length > 1) {
            list[index] = list[list.length-1];
        }
        list.pop();
    }

    function startSellingProperty(string memory _hash, uint price) public  {
        require(hashDatabase[_hash]!=address(0x0),"Hash doesnt exist");
        Property p = Property(address(hashDatabase[_hash]));
        require(p.isForSale()==false,"Property already for sale!");
        require(p.owner()==msg.sender, "Only owner can start selling his property");
        itemsForSale.push(p); //put the listing up
        //call buy function and pass the money to the buy function...
        p.startSelling(price,itemsForSale.length-1); //TODO doesnt work because msg.sender will be the contract itself..
    }

    function stopSellingProperty(string memory _hash) public {
        require(hashDatabase[_hash]!=address(0x0),"Hash doesnt exist");
        Property p = Property(address(hashDatabase[_hash]));
        require(p.isForSale()==true,"Property is not for sale!");
        require(p.owner()==msg.sender, "Only owner can stop selling his property");

        removeProperty(itemsForSale,p.sellingIndex());
        p.stopSelling();
    }

    function getOwnerOfHash(string memory _hash) public view returns (address) {
       require(hashDatabase[_hash]!=address(0x0),"Hash doesnt exist");
       Property p = Property(address(hashDatabase[_hash]));
       return p.owner();
    }
    
    function getMyProperties() public view returns (Property[] memory) {
        require(ownerToHashes[msg.sender].length!=0,"Owner has no posessions");
        return ownerToHashes[msg.sender];
    }
    
    function startAuction(string memory _hash, uint price) public {
        require(price >= 0, "Price can not be negative");
        require(hashDatabase[_hash]!=address(0x0),"Hash doesnt exist");
        Property p = Property(address(hashDatabase[_hash]));
        require(p.isForSale()==false,"Property already for sale!");
        require(p.owner()==msg.sender, "Only owner can start an auction");
        
        // check if the auction has already been started
        //require(!hashToAuction[_hash].running(), "Auction was already started");
        
        p.forSale(true, msg.sender);
        // create a new action
        Auction auction = new Auction();
        auction.start(p, msg.sender, price, auctions.length-1);
        // put it in the list of auctions
        hashToAuction[_hash] = auction;
        auctions.push(auction);
    }
    
    function bid(string memory _hash) public payable {
        Auction auction = hashToAuction[_hash];
        require(auction.running(), "There is no such auction running");
        require(auction.owner() != msg.sender, "Owner can not bid");
        require(msg.value > auction.highestOffer(), "The bid is too small");
        
        auction.bid(msg.value, msg.sender);
    }
    
    function stopAuctoin(string memory _hash) public payable {
        Auction auction = hashToAuction[_hash];
        //require(auction.running(), "There is no such auction running");
        require(auction.owner() == msg.sender, "Only owner can stop the auction");
        
        auction.stop();
        removeAuction(auctions, auction.index());
        // highest bidder buys the property 
        Property p = Property(address(hashDatabase[_hash]));
        p.buy.value(auction.highestOffer())(auction.highestBidder());
    }
}