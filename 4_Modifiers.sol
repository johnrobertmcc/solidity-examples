pragma solidity >=0.7.0 < 0.9.0;

contract SimpleCoin {
    uint contractStartTime;
    address public minter;
    mapping ( address => uint) public balances;

    event Sent(address from, address to, uint amount);

    modifier onlyMinter {
        require(msg.sender == minter, "Only minter can call this function");
        _;
    }

    modifier amountGreaterThan(uint amount) {
        require(amount < 1e60);
        _;
    }

    modifier balanceGreaterThanAmount(uint amount) {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        _;
    }

    modifier oneWeekPassed(uint startTime) {
        require(block.timestamp >= startTime + 604800);
        _;
    }

    constructor() {
        minter = msg.sender;
        contractStartTime = block.timestamp;
    }

    function mint(address receiver, uint amount) public onlyMinter amountGreaterThan(amount) {
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public balanceGreaterThanAmount(amount) oneWeekPassed(contractStartTime) {
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}