const contract = require('truffle-contract');

const Database = artifacts.require('./Database.sol')
const Property = artifacts.require('./Property.sol')

module.exports = async (deployer) => {
  try {
    const x = await deployer.deploy(Database);
    console.log(x, 'kurwa pierdolona')
    // TODO deploy Property using address from deployed Database
  } catch (error) {
    console.error(error);
  }
};
