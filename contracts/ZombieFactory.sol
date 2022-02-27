
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;
// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!
import "./safemath.sol";
import "./ownable.sol";

contract ZombieFactory is Ownable{

	using SafeMath for uint256;
	using SafeMath16 for uint16;
	using SafeMath32 for uint32;

	event NewZombie(uint zombieId, string name, uint dna);

	uint dnaDigits = 16;
	uint dnaModulus = 10 ** dnaDigits;
	uint cooldownTime = 1 days;
	//structs are used for custom data types with more than one member
	struct Zombie{
		string name;
		uint dna;
		uint32 level;
		uint32 readyTime;
		uint16 winCount;
		uint16 lossCount;
	}

	Zombie[] public zombies;

	mapping (uint => address) public zombieToOwner;
	mapping (address => uint) public ownerZombieCount;

	function _createZombie(string memory _name, uint _dna) internal {
		zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0));
		uint id = zombies.length - 1;
		zombieToOwner[id] = msg.sender;
		ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
		emit NewZombie(id, _name, _dna);
	}

	function _generateRandomDna(string memory _name) private view returns (uint){
		uint rand = uint(keccak256(abi.encodePacked(_name)));
		return rand % dnaModulus;
	}

	function createRandomZombie(string memory _name) public {
		uint randDna = _generateRandomDna(_name);
		_createZombie(_name, randDna);
	}
}
