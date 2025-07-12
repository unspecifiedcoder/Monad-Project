// require("dotenv").config();
// require("@nomicfoundation/hardhat-toolbox");
// require("@nomicfoundation/hardhat-ignition");

// module.exports = {
//   solidity: "0.8.20",
//   networks: {
//     sepolia: {
//       url: process.env.SEPOLIA_RPC_URL,
//       accounts: [process.env.PRIVATE_KEY],
//     },
//   },
// };
require("@nomicfoundation/hardhat-toolbox-viem");

const config = {
  solidity: {
    version: "0.8.24",
    settings: {
      metadata: {
        bytecodeHash: "none", // disable ipfs
        useLiteralContent: true, // use source code
      },
    },
  },
  networks: {
    monadTestnet: {
      url: "https://testnet-rpc.monad.xyz",
      chainId: 10143,
    },
  },

  sourcify: {
    enabled: true,
    apiUrl: "https://sourcify-api-monad.blockvision.org",
    browserUrl: "https://testnet.monadexplorer.com",
  },

  etherscan: {
    enabled: false,
  },
};

module.exports = config;