require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-ethers");

module.exports = {
  networks: {
    mumbai: {
      url: "https://polygon-testnet.public.blastapi.io",
      chainId: 80001,
      gasPrice: 300000000000,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    'mumbai-mainnet': {
      url: "https://polygon-rpc.com",
      chainId: 137,
      gasPrice: 40000000000,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    'bsc-test': {
      url: "https://bsctestapi.terminet.io/rpc",
      chainId: 97,
      gasPrice: 20000000000,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    fuji: {
      url: "https://rpc.ankr.com/avalanche_fuji",
      gasPrice: 40000000000,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    'fantom-testnet': {
      url: "https://rpc.ankr.com/fantom_testnet",
      gasPrice: 3000000000,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    'op': {
      url: "https://opt-goerli.g.alchemy.com/v2/JYXQ7D1AGOtQZYk0tUboHrpXfdKaC6_h",
      gasPrice: 30000000000,
      gas:9000000,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    goerli: {
      url:  `https://eth-goerli.g.alchemy.com/v2/rXT81OXA_g-Mj7IjavCHWmAB4UIvNcEV`,//'https://goerli.blockpi.network/v1/rpc/public'
      gasPrice: 800*100000000,
      chainId: 5,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    
    // hardhat: {
    //   allowUnlimitedContractSize: true
    // },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },

  solidity: {
    compilers: [
      {
        version: "0.8.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          }
        }
      }
    ]
  },
};