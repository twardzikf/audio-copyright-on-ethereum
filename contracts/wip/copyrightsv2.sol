// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;
contract idDatabase{

    struct Account {
        // string userName;
        Copyright[] copyrights;
        uint index; // to remember its index in the userAddresses array and avoid loops
    }

    struct Copyright {
        string fingerprint;
        address payable owner;
        // string name;
        // string comment;
        bool isForSale;
        uint price;
        uint sellingIndex;
        bool exists;
    }

    address[] userAddresses;
    mapping (address => Account) accounts;

    string[] fingerprints;
    mapping (string => Copyright) copyrights;

    Copyright[] itemsForSale;
    
    function addCopyright (string memory _fingerprint) private {
        require(copyrights[_fingerprint].exists == false, "Fingerprint already exists in the database!");

        Copyright memory newCopyright = Copyright(_fingerprint, msg.sender, false, uint(-1), uint(-1), true);
        accounts[msg.sender].copyrights.push(newCopyright);

        copyrights[_fingerprint] = newCopyright;
        fingerprints.push(_fingerprint);
    }

    function sellCopyright(string memory _fingerprint, uint _price) private {
        Copyright storage copyright = copyrights[_fingerprint];
        require(copyright.exists == true, "There is no such copyright saved on the blockchain");
        require(msg.sender == copyright.owner, "Only the owner can call this function");
        require(copyright.isForSale == false,
        "This copyright is already for sale");

        copyright.isForSale = true;
        copyright.price = _price;
        copyright.sellingIndex = itemsForSale.length-1;

        // todo ... accounts[msg.sender].copyrights ...

        itemsForSale.push(copyright);
    }

    function buyCopyright(string memory _fingerprint) public payable {
        Copyright storage copyright = copyrights[_fingerprint];
        require(copyright.exists == true && copyrights[_fingerprint].isForSale == true,
        "Is not for sale!");
        require(msg.sender != copyright.owner, "The owner can not be the buyer");
        require(msg.value >= copyright.price, "The funds are not sufficient");

        copyright.owner.transfer(msg.value);
        copyright.owner = msg.sender;

        // todo delete the copyright from the sellers account
        // todo add the copyright to the buyers account

        // delete from itemsForSale
        if(itemsForSale.length>1){ 
            uint index = copyright.sellingIndex;
            itemsForSale[index]=itemsForSale[itemsForSale.length-1];
        }
        itemsForSale.pop();

    }

}