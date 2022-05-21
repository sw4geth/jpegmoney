import Web3 from "web3";
import Web3Modal from "web3modal";
import WalletConnectProvider from "@walletconnect/web3-provider";
import {abi, contract} from './jpegmoney';
import {punkabi, punkcontract} from './Punks';

export default function ConnectButton({setAcct, acct, setActive, active, setVault, setColPrice, colPrice, punks, setPunks, setPunkBalance, setNetworth, setDebt}){
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
    network: "rinkeby", // optional
    cacheProvider: false, // optional
    providerOptions // required
  });

  //const provider = await web3Modal.connect();
  async function connect(){
    const provider = await web3Modal.connect();
    const web3 = new Web3(provider);
    const accounts = await web3.eth.getAccounts();
    const jpegmoney = new web3.eth.Contract(abi, contract);
    const cryptopunks = new web3.eth.Contract(punkabi, punkcontract);
    setVault(jpegmoney);
    setPunks(cryptopunks);
    const collatPrice = await jpegmoney.methods.getCollateralPriceUSD().call();
    const depositBalance = await jpegmoney.methods.bal(accounts[0]).call();
    const debt = await jpegmoney.methods.debt(accounts[0]).call();
    setDebt(debt);
    const nw = await jpegmoney.methods.calculateTotalUserValueUSD(accounts[0]).call();
    setNetworth(nw);
    const punkBalance = web3.utils.fromWei(await cryptopunks.methods.balanceOf(accounts[0]).call());
    setPunkBalance(punkBalance);
    setColPrice(collatPrice);
    setAcct(accounts[0]);
    console.log(accounts[0]);
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
    <div>
    <div className="connect" onClick={connect}>{active? <span>Connected</span> : <span>Connect</span>}</div>
    </div>
  );
}
