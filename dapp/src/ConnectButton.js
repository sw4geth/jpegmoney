import Web3 from "web3";
import Web3Modal from "web3modal";
import WalletConnectProvider from "@walletconnect/web3-provider";

export default function ConnectButton({setAcct, setActive, active, setContract, minted, setMinted, setStarted}){
  const providerOptions = {
      walletconnect: {
        package: WalletConnectProvider, // required
        options: {
          infuraId: "875d3109274e4087a8fc18f3f6b2aed6",
          qrcodeModalOptions: {
            mobileLinks: [
              "rainbow",
              "metamask",
            ],
          },
        }
      }
    };

  const web3Modal = new Web3Modal({
    network: "mainnet", // optional
    cacheProvider: false, // optional
    providerOptions // required
  });

  //const provider = await web3Modal.connect();
  async function connect(){
    const provider = await web3Modal.connect();
    const web3 = new Web3(provider);
    const accounts = await web3.eth.getAccounts();
    setAcct(accounts[0]);
    setActive(true);
    provider.on("accountsChanged", (accounts: string[]) => {
    setAcct(accounts[0]);
    });

  // Subscribe to chainId change
    provider.on("chainChanged", (chainId: number) => {
    console.log(chainId);
    });

  // Subscribe to provider connection
    provider.on("connect", (info: { chainId: number }) => {
    console.log(info);
    });

  // Subscribe to provider disconnection
    provider.on("disconnect", (error: { code: number; message: string }) => {
    console.log(error);
    setActive(false);
    });
  }


  return(
    <div onClick={connect}>{active? <span>Connected</span> : <span>Connect Wallet</span>}</div>
  );
}
