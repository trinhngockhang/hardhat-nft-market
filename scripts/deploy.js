const hre = require("hardhat");
require("@nomiclabs/hardhat-web3");
const { BigNumber } = require("@ethersproject/bignumber");
const Web3 = require('web3');
const nftAbi = require('../abi/nft.json');

async function main() {
  const [owner] = await ethers.getSigners();
  // write script here!!!
  const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy("NFT", "TNK");
  console.log("NFT DEPLOYED TO: ", nft.address);
 

  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy("Khang", "KHG", owner.address, BigNumber.from('1000000000000000000000000'));
  console.log("Token DEPLOYED TO: ", token.address);

  const PiggyBank = await ethers.getContractFactory("PiggyBank");
  const piggyBank = await PiggyBank.deploy(token.address);
  console.log("Piggy bank DEPLOYED TO: ", piggyBank.address);

  const Market = await ethers.getContractFactory("Market");
  const market = await Market.deploy(
    piggyBank.address,
    token.address,
    nft.address
  );
  console.log("MARKET address: ", market.address);
  
  // Mint a NFT
  const newNft = await nft.mint(owner.address);
  const transactionHash = newNft.hash;
  
  // Gen contract
  const nftContract = genNftContract(nft.address);
  await newNft.wait();

  // get events
  const events = await nftContract.getPastEvents('Transfer', {
    toBlock: 'latest',
  });
 
  // find token id
  const event = events.find(e => e.transactionHash == transactionHash);
  const tokenId = event.returnValues.tokenId;

  // approve
  await nft.approve(market.address, tokenId);
  await token.approve(market.address, BigNumber.from("100000000000000000000"));

  // list item
  await market.listItem(tokenId, 1);

  // Buy a NFT
  await market.buy(tokenId - 1 , 1);
}

const genNftContract = (address) => {
  const ws = new Web3.providers.WebsocketProvider(
    'ws://localhost:8545',
  );
  const web3 = new Web3(ws);
  return new web3.eth.Contract(nftAbi, address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    // process.exit(1);
  });
