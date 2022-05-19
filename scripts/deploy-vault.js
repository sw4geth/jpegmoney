async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const Vault = await ethers.getContractFactory("SimpleVault");
    const vault = await Vault.deploy("0x286AaF440879dBeAF6AFec6df1f9bfC907101f9D", "0xA163479C1283900923D436fCFa06f24f199ee564", "0xDF7301699291603a23EC7Ed8A33CB3bd891b511D");

    console.log("Contract address:", vault.address);
  }

  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
