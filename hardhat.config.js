require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-web3");

const dotenv = require('dotenv');
dotenv.config();

const GOERLI_ACCOUNTS = process.env.GOERLI_ACCOUNTS.split(',');
const ALCHEMY_KEY = process.env.ALCHEMY_KEY;
const BSC_TESTNET_ACCOUNTS = process.env.BSC_TESTNET_ACCOUNTS.split(',');
const ETHER_SCAN_KEY = process.env.ETHER_SCAN_KEY;

module.exports = {
  defaultNetwork: "goerli",
  solidity: "0.8.0",
  networks: {
    hardhat: {

    },
    goerli: {
      url: "https://eth-goerli.alchemyapi.io/v2/" + ALCHEMY_KEY,
      accounts: GOERLI_ACCOUNTS,
    },
    bsc_testnet: {
      url: "https://data-seed-prebsc-1-s3.binance.org:8545/",
      accounts: BSC_TESTNET_ACCOUNTS,
    },
  },
  etherscan: {
    apiKey: ETHER_SCAN_KEY
  }
};

