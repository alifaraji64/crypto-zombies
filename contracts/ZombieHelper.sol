pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;
import './ZombieFeeding.sol';

contract ZombieHelper is ZombieFeeding{
  uint public levelUpFee = 0.002 ether;

  function withdraw() external onlyOwner{
    address _owner = owner();
    payable(_owner).transfer(address(this).balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner{
    levelUpFee = _fee;
  }

  function levelUp(uint _zombieId) external payable returns(uint){
    require(msg.value >= levelUpFee,'amount is not enough');
    zombies[_zombieId].level++;
    return msg.value;
  }

  function changeName(uint _zombieId, string calldata _newName) external onlyOwnerOf(_zombieId){
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external onlyOwnerOf(_zombieId){
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[] memory){
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for(uint i = 0; i < zombies.length; i++){
      if(zombieToOwner[i] == _owner){
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
}
