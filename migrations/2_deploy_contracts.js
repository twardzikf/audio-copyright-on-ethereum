// const Database = artifacts.require('idDatabase')
// const DB = artifacts.require('Database')
// const Property = artifacts.require('Property')
const PropertiesDB = artifact.require('PropertiesDB')

module.exports = async (deployer) => {
  const OWNER = '0xA4CA6b32b5093C3d9B0Bee41e62dD9E85aaf9819';
  try {
    // deployer.then(() => {
    //   return Database.new();
    // }).then((database) => {
    //   console.log('database: ' + database.address);
    //   // return Property.new('string', OWNER, database.address);
    // });
    // // .then((property) => {
    // //   console.log('property: ' + property.address);
      
    // // });
    // // TODO deploy Property using address from deployed Database

    deployer.deploy(PropertiesDB);

    // deployer.deploy(DB).then(function (data) {
    //   console.log(data.address);
    // });

    // deployer.deploy(Property).then(function (data) {
    //   console.log(data.address);
    // });


    
  } catch (error) {
    console.error(error);
  }
};
