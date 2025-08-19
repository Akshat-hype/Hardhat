//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Token {
    string public Name = "Akshat Token";
    string public Symbol = "AKT";
    uint256 public TotalSupply = 1000000 * (10 ** 18);
    uint8 public Decimals = 18;
    address public Owner;
    mapping(address => uint256) public BalanceOf;
    mapping(address => mapping(address => uint256)) public Allowance;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    modifier onlyOwner() {
        require(msg.sender == Owner, "Not the contract owner");
        _;
    }
    constructor() {
        Owner = msg.sender;
        BalanceOf[Owner] = TotalSupply;
        emit Transfer(address(0), Owner, TotalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Invalid address");
        require(BalanceOf[msg.sender] >= value, "Insufficient balance");
        BalanceOf[msg.sender] -= value;
        BalanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Invalid address");
        Allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(from != address(0) && to != address(0), "Invalid address");
        require(BalanceOf[from] >= value, "Insufficient balance");
        require(Allowance[from][msg.sender] >= value, "Allowance exceeded");
        BalanceOf[from] -= value;
        BalanceOf[to] += value;
        Allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function mint(address to, uint256 value) public onlyOwner returns (bool) {
        require(to != address(0), "Invalid address");
        TotalSupply += value;
        BalanceOf[to] += value;
        emit Mint(to, value);
        emit Transfer(address(0), to, value);
        return true;
    }

    function burn(uint256 value) public returns (bool) {
        require(BalanceOf[msg.sender] >= value, "Insufficient balance");
        BalanceOf[msg.sender] -= value;
        TotalSupply -= value;
        emit Burn(msg.sender, value);
        emit Transfer(msg.sender, address(0), value);
        return true;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(Owner, newOwner);
        Owner = newOwner;
    }

    function getOwner() public view returns (address) {
        return Owner;
    }

    function getBalance(address account) public view returns (uint256) {
        return BalanceOf[account];
    }
}