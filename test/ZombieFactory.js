const ZombieHelper = artifacts.require("ZombieHelper");

function convertToWei(eth){
  return eth * Math.pow(10,18);
}
function convertToEth(wei){
  return wei / Math.pow(10,18);
}

contract('ZombieHelper', (accounts) => {
  let zombieHelper;
  before(async () => {
   zombieHelper = await ZombieHelper.deployed()
 })
  it('deploys successfully', async () => {
      const address = await zombieHelper.address
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })
    before(async()=>{
      await zombieHelper.createRandomZombie("hasbulla");
    })
    /*it('test for feeding a zombie',async()=>{
      //await zombiefeeding.feedAndMultiply(0, 2365792483523523, "kitty",{from:accounts[0]});
      //await zombiefeeding.getKitty(0,1524447);
      console.log(await zombieHelper.getKitty(0,2010919));
    })*/
    let levelUpFee;
    it('test for level up fee', async ()=>{
      levelUpFee = await zombieHelper.levelUpFee();
      assert.notEqual(levelUpFee, 0);
    })

    it('test for SET level up fee', async ()=>{
      assert.equal(convertToEth(levelUpFee.toNumber()),0.002);
      await zombieHelper.setLevelUpFee(convertToWei(0.003));
      levelUpFee = await zombieHelper.levelUpFee();
      assert.equal(convertToEth(levelUpFee.toNumber()), 0.003);
      assert.notEqual(levelUpFee, 0);
    })

    it('test for leveling up the zombie', async()=>{
      let zombie = await zombieHelper.zombies(0);
      assert.equal(zombie.level.toNumber(), 1);
      await zombieHelper.levelUp(0,{from:accounts[0], value:convertToWei(18)});
      zombie = await zombieHelper.zombies(0);
      assert.equal(zombie.level.toNumber(), 2);
    })

    it('test for changing the name', async()=>{
      let zombie = await zombieHelper.zombies(0);
      assert.equal(zombie.name, 'hasbulla');
      await zombieHelper.changeName(0,'hasbulla_2.0');
      zombie = await zombieHelper.zombies(0);
      assert.equal(zombie.name, 'hasbulla_2.0');
    })
});
