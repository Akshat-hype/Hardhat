const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token Contract", function () {
  let Token, token, owner, addr1, addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    Token = await ethers.getContractFactory("Token");
    token = await Token.deploy();
    await token.deployed();
  });

  it("Should assign total supply to owner", async function () {
    const ownerBalance = await token.getBalance(owner.address);
    expect(await token.TotalSupply()).to.equal(ownerBalance);
  });

  it("Should transfer tokens between accounts", async function () {
    await token.transfer(addr1.address, 50);

    expect(await token.getBalance(addr1.address)).to.equal(50);
    expect(await token.getBalance(owner.address)).to.equal(
      (await token.TotalSupply()).sub(50)
    );
  });

  it("Should allow approved accounts to transfer tokens", async function () {
    await token.approve(addr1.address, 100);
    await token.connect(addr1).transferFrom(owner.address, addr2.address, 50);

    expect(await token.getBalance(addr2.address)).to.equal(50);
  });

  it("Should only allow owner to mint tokens", async function () {
    await token.mint(addr1.address, 100);
    expect(await token.getBalance(addr1.address)).to.equal(100);
  });

  it("Should allow burning tokens", async function () {
    const initialSupply = await token.TotalSupply();
    await token.burn(100);
    expect(await token.TotalSupply()).to.equal(initialSupply.sub(100));
  });

  it("Should transfer ownership", async function () {
    await token.transferOwnership(addr1.address);
    expect(await token.getOwner()).to.equal(addr1.address);
  });
});
