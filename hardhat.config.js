require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config();


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const defaultNetwork = "rinkeby";

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  defaultNetwork,

  /**
   * gas reporter configuration that let's you know
   * an estimate of gas for contract deployments and function calls
   * More here: https://hardhat.org/plugins/hardhat-gas-reporter.html
   */
  gasReporter: {
    currency: "USD",
    coinmarketcap: process.env.COINMARKETCAP || null,
  },

  // if you want to deploy to a testnet, mainnet, or xdai, you will need to configure:
  // 1. An Infura key (or similar)
  // 2. A private key for the deployer
  // DON'T PUSH THESE HERE!!!
  // An `example.env` has been provided in the Hardhat root. Copy it and rename it `.env`
  // Follow the directions, and uncomment the network you wish to deploy to.
  etherscan: {
   // Your API key for Etherscan
   // Obtain one at https://etherscan.io/
   apiKey: "ZU95HJSW1FB4FGQKUXY6YA5IZ17346MXRG"
 },
  networks: {
    localhost: {
      url: "http://localhost:8545",
      /*
        notice no mnemonic here? it will just use account 0 of the hardhat node to deploy
        (you can put in a mnemonic here to set the deployer locally)
      */
    },

    // rinkeby: {
    //   url: `https://rinkeby.infura.io/v3/${process.env.RINKEBY_INFURA_KEY}`,
    //   accounts: [`${process.env.RINKEBY_DEPLOYER_PRIV_KEY}`],
    // },
    // kovan: {
    //   url: `https://rinkeby.infura.io/v3/${process.env.KOVAN_INFURA_KEY}`,
    //   accounts: [`${process.env.KOVAN_DEPLOYER_PRIV_KEY}`],
    // },
    // mainnet: {
    //   url: `https://mainnet.infura.io/v3/${process.env.MAINNET_INFURA_KEY}`,
    //   accounts: [`${process.env.MAINNET_DEPLOYER_PRIV_KEY}`],
    // },
    // ropsten: {
    //   url: `https://ropsten.infura.io/v3/${process.env.ROPSTEN_INFURA_KEY}`,
    //   accounts: [`${process.env.ROPSTEN_DEPLOYER_PRIV_KEY}`],
    // },
    // goerli: {
    //   url: `https://goerli.infura.io/v3/${process.env.GOERLI_INFURA_KEY}`,
    //   accounts: [`${process.env.GOERLI_DEPLOYER_PRIV_KEY}`],
    // },
    // xdai: {
    //   url: 'https://dai.poa.network',
    //   gasPrice: 1000000000,
    //   accounts: [`${process.env.XDAI_DEPLOYER_PRIV_KEY}`],
    // },

    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/A0R66DG7FQPkDJFfRewezVwrbeWV673j", // <---- YOUR INFURA ID! (or it won't work)

      //    url: "https://speedy-nodes-nyc.moralis.io/XXXXXXXXXXXXXXXXXXXXXXX/eth/rinkeby", // <---- YOUR MORALIS ID! (not limited to infura)

      accounts: [`${process.env.PRIVATE_KEY}`],
    },
    mainnet: {
      url: "https://mainnet.infura.io/v3/460f40a260564ac4a4f4b3fffb032dad", // <---- YOUR INFURA ID! (or it won't work)

      //      url: "https://speedy-nodes-nyc.moralis.io/XXXXXXXXXXXXXXXXXXXXXXXXX/eth/mainnet", // <---- YOUR MORALIS ID! (not limited to infura)
      accounts: [`${process.env.PRIVATE_KEY}`],
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: false,
            runs: 200,
          },
        },
      },
      {
        version: "0.6.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  ovm: {
    solcVersion: "0.7.6",
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
    },
  },
};
