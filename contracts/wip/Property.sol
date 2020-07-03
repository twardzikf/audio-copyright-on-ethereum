// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;

contract Property {

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
        require(price <= msg.value, "Insuficient funds recieved");
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
//for testing
/* contract MaliciousContract {
    //test - trying to start selling some property without beeing owner
    function startSellingOfSomeonesHash(address prop) public  {
        Property p = Property(address(prop));
        p.startSelling(1,1);
    }
} */

