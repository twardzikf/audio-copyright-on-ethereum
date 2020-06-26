// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;

contract Property{
    
    address private databaseReference; //reference to the database object - for security concerns (trust )
    
    string public hash;
    address payable public owner;
    
    uint public price;
    bool public isForSale;
    uint public ownersIndex; //<- importand for later so that we can remove it from ownersList without loop
    uint public sellingIndex; //<- importand for later so that we remove it from sellingList without loop
    //verification of owner happens inside trusted contract!
    modifier fromTrustedContract() {
        require(
            msg.sender == databaseReference,
            "Only trusted ipDatabase can make this call"
        );
        _;
    }
    
   
    event PropertySold(address oldOwner, address newOwner);
    event PropertyIsForSale();
    
    constructor(string memory _hash, address payable _owner, address _databaseReference) public {
        hash = _hash;
        owner = _owner;
        databaseReference = _databaseReference;
        isForSale = false;
    }
   
    function buy (address payable buyer) public payable fromTrustedContract{
        require(buyer!=owner, "Owner cannot be Buyer");
        require(isForSale, "Item is not for sell");
        require(price<= msg.value, "Insuficient funds recieved");
        isForSale = false;
        owner.transfer(msg.value); //transfer funds to the previous owner
        owner = buyer; //set the new owner
    }
    
    function startSelling(uint _price,uint _sellingIndex) public fromTrustedContract {
        price = _price;
        isForSale = true;
        sellingIndex = _sellingIndex;
    }
    
    function stopSelling() public fromTrustedContract{
        isForSale = false;
    }
    
    function setOwnersIndex(uint newIndex) public fromTrustedContract{
        ownersIndex = newIndex;
    }
    
} 

contract ipDatabase{
   
    //maps owners to their properties 
    mapping(address => Property[]) public ownerToHashes;
    //intellectual property Database - storing all Properties (music files)
    mapping(string => address) public hashDatabase;
    //stores properties that are for sale - to avoid loops
    Property[] itemsForSale;
    
    
    //displays selling properties
   function getItemsForSale() public view returns  (Property[] memory){
       return itemsForSale;
   }

    function addProperty(string memory hash) public payable returns (Property) {
       require(hashDatabase[hash]==address(0x0),"Hash already exists in the Database!");
       
        Property pnew = new Property(hash,msg.sender,address(this));
        hashDatabase[hash]= address(pnew);
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
        if(list.length>1){ 
            //if more than one element, switch last with the item to remove
            list[index]=list[list.length-1];
        }
        //decrease list size
        //list.length--; 
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
    

}
//for testing
contract MaliciousContract {
    //test - trying to start selling some property without beeing owner
    function startSellingOfSomeonesHash(address prop) public  {
        Property p = Property(address(prop));
        p.startSelling(1,1);
    }
}

