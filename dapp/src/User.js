import Web3 from "web3";

export default function User({colPrice, acct, setNetworth, netWorth}) {
  const web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/v3/04a944092bf1448bb6ccbbae196e56f1"));
  return(
    <div className="user">
    <span>Your total protocol value is ${web3.utils.fromWei(netWorth)}</span>
    </div>
  );

}
