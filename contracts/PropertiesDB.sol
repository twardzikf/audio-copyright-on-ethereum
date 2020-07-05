// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

contract PropertiesDB {

    struct Property {
        string fingerprint;
        string title;
    }

    struct PropertyForSaleDTO {
        string fingerprint;
        string title;
        address owner;
        uint price;
    }


    address[] propertyOwners;
    mapping (address => Property[]) properties;

    string[] propertiesForSale;
    mapping (string => uint) salePrices;

    /* Actions on the database */

    function addProperty (string memory _fingerprint, string memory _title) public {
        require(!isPropertyPresent(_fingerprint), "Property already exists in the database!");

        if (!isOwnerPresent(msg.sender)) propertyOwners.push(msg.sender);
        properties[msg.sender].push(Property(_fingerprint, _title));
    }

    function fetchProperties() public view returns (Property[] memory){
        return properties[msg.sender];
    }

    function fetchPropertiesForSale() public view returns (PropertyForSaleDTO[] memory) {
        uint propertiesForSaleWithoutOwnLength = 0;
        for (uint i = 0; i < propertiesForSale.length; i++) {
            if (!isOwner(propertiesForSale[i], msg.sender)) {
                propertiesForSaleWithoutOwnLength++;
            }
        }
        PropertyForSaleDTO[] memory _propertiesForSale = new PropertyForSaleDTO[](propertiesForSaleWithoutOwnLength);
        uint j = 0;
        for (uint i = 0; i < propertiesForSale.length; i++) {
            if (!isOwner(propertiesForSale[i], msg.sender)) {
                _propertiesForSale[j] = createPropertyForSaleDto(propertiesForSale[i]);
                j++;
            }
        }
        return _propertiesForSale;
    }

    function offerPropertyForSale(string memory _fingerprint, uint _price) public {
        require(isPropertyPresent(_fingerprint), "There is no such properrty saved on the blockchain");
        require(isOwner(_fingerprint, msg.sender), "Only the owner can call this function");
        require(!isPropertyForSale(_fingerprint), "This property is already for sale");

        propertiesForSale.push(_fingerprint);
        salePrices[_fingerprint] = _price;
    }

    function buyProperty(string memory _fingerprint) public payable {
        require(isPropertyPresent(_fingerprint), "There is no such property saved on the blockchain");
        require(isPropertyForSale(_fingerprint), "This property is not for sale");
        require(!isOwner(_fingerprint, msg.sender), "The owner can not be the buyer");
        require(msg.value >= getPropertyPrice(_fingerprint), "The funds are not sufficient");

        uint price = getPropertyPrice(_fingerprint);
        address payable owner = address(uint160(getPropertyOwner(_fingerprint)));
        Property memory property =  getProperty(_fingerprint);

        properties[msg.sender].push(property);
        deleteFromPropertiesForSale(_fingerprint);
        deleteFromProperties(_fingerprint, owner);
        owner.transfer(price);
    }



    /* Queries on the database */

    function isOwner (string memory _fingerprint, address userAddress) private view returns (bool) {
        Property[] memory userProperties = properties[userAddress];
        for (uint i = 0; i < userProperties.length; i++) {
          if (areStringsEqual(userProperties[i].fingerprint, _fingerprint)) return true;
        }
        return false;
    }
    function createPropertyForSaleDto(string memory fingerprint) private view returns (PropertyForSaleDTO memory) {
        Property memory property = getProperty(fingerprint);
        address owner = getPropertyOwner(fingerprint);
        uint price = getPropertyPrice(fingerprint);
        return PropertyForSaleDTO(fingerprint, property.title, owner, price);
    }
    function isPropertyForSale (string memory _fingerprint) private view returns (bool) {
        for (uint i = 0; i < propertiesForSale.length; i++) {
            if (areStringsEqual(propertiesForSale[i], _fingerprint)) return true;
        }
        return false;
    }
    function isOwnerPresent (address ownerAddress) private view returns (bool) {
        for (uint i = 0; i < propertyOwners.length; i++) {
            if (propertyOwners[i] == ownerAddress) return true;
        }
        return false;
    }
    function isPropertyPresent (string memory _fingerprint) private view returns (bool) {
        for (uint i = 0; i < propertyOwners.length; i++) {
          for (uint j = 0; j < properties[propertyOwners[i]].length; j++) {
              if (areStringsEqual(properties[propertyOwners[i]][j].fingerprint, _fingerprint)) return true;
          }
        }
        return false;
    }
    function areStringsEqual (string memory _string1, string memory _string2) private pure returns (bool) {
        return keccak256(bytes(_string1)) == keccak256(bytes(_string2));
    }

    function getProperty(string memory _fingerprint)  private view returns (Property memory) {
        for (uint i = 0; i < propertyOwners.length; i++) {
            for (uint j = 0; j < properties[propertyOwners[i]].length; j++) {
                if (areStringsEqual(properties[propertyOwners[i]][j].fingerprint, _fingerprint)) {
                    return properties[propertyOwners[i]][j];
                }
            }
        }
    }
    function getPropertyOwner (string memory _fingerprint) private view returns (address) {
        for (uint i = 0; i < propertyOwners.length; i++) {
            for (uint j = 0; j < properties[propertyOwners[i]].length; j++) {
                if (areStringsEqual(properties[propertyOwners[i]][j].fingerprint, _fingerprint)) return propertyOwners[i];
            }
        }
        return address(0);
    }
    function getPropertyPrice (string memory _fingerprint) private view returns (uint) {
        for (uint i = 0; i < propertiesForSale.length; i++) {
            if (areStringsEqual(propertiesForSale[i], _fingerprint)) {
                return salePrices[propertiesForSale[i]];
            }
        }
        return 0;
    }
    
    function deleteFromPropertiesForSale(string memory _fingerprint)  private {
        uint index = 0;
        for (uint i = 0; i < propertiesForSale.length; i++) {
            if (areStringsEqual(propertiesForSale[i], _fingerprint)) {
                index = i;
            }
        }

        if (index >= propertiesForSale.length) return;

        for (uint i = index; i < propertiesForSale.length-1; i++){
            propertiesForSale[i] = propertiesForSale[i+1];
        }
        delete propertiesForSale[propertiesForSale.length-1];
        propertiesForSale.length--;
    }

    function deleteFromProperties(string memory _fingerprint, address _owner)  private {
        uint index = 0;
        for (uint i = 0; i < properties[_owner].length; i++) {
            if (areStringsEqual(properties[_owner][i].fingerprint, _fingerprint)) {
                index = i;
            }
        }

        if (index >= properties[_owner].length) return;

        for (uint i = index; i<properties[_owner].length-1; i++){
            properties[_owner][i] = properties[_owner][i+1];
        }
        delete properties[_owner][properties[_owner].length-1];
        properties[_owner].length--;
    }
    
    
}