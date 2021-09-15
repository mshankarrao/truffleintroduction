const Migrations = artifacts.require('Migrations');
const VolcanoCoin = artifacts.require('VolcanoCoin');
const VolcanoToken = artifacts.require('VolcanoToken');

module.exports = async function (deployer) {
  await deployer.deploy(Migrations);
  await deployer.deploy(VolcanoCoin);
  await deployer.deploy(VolcanoToken);
};
