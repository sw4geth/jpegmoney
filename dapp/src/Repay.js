import Web3 from "web3";

export default function Repay({vault, acct}) {

  const web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/v3/04a944092bf1448bb6ccbbae196e56f1"));

  return(
    <div className="repay">
    <div className="button">Repay</div>
    <div className="button">Withdraw</div>
    </div>
  )
}
