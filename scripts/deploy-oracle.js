async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Oracle = await ethers.getContractFactory("UniswapV2Twap");
    const oracle = await Oracle.deploy("0x1a8818eABE7F88F9c2a2DD39f2e7a9B55354f87a");

    console.log("Contract address:", oracle.address);
  }

  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
