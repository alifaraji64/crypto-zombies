pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;
import "./ZombieFactory.sol";

interface KittyInterface{
  function getKitty(uint256 _id)
        external
        view
        returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory{

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);

  modifier onlyOwnerOf(uint _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId], 'not owner');
    _;
  }

  function _triggerCooldown(Zombie storage _zombie) private{
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie memory _zombie) internal view returns(bool){
    return (_zombie.readyTime<=now);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public onlyOwnerOf(_zombieId){
    Zombie storage myZombie = zombies[_zombieId];
    //require(_isReady(myZombie), "zombie is not ready yet");
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - (newDna % 100) + 22;
    }
    myZombie.dna = newDna;
    _triggerCooldown(myZombie);
  }

  function getKitty(uint _zombieId, uint _kittyId) public returns(uint kittyDna) {
    require(_kittyId!=0, 'kitty id not found');
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    //feedAndMultiply(_zombieId, kittyDna, "kitty");
    require(kittyDna!=0, 'kitty dna not found');
    return kittyDna;
  }
}
