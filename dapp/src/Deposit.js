import Web3 from "web3";

export default function Deposit({setDeposit, depositAmt, acct, vault, punks, punkBalance, colPrice}) {

  const walletvalue = (punkBalance * colPrice).toString();
  const web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/v3/04a944092bf1448bb6ccbbae196e56f1"));
  const punksvalue = web3.utils.fromWei(walletvalue);
  const handleChange = (e) => {
    setDeposit(web3.utils.toWei(e.target.value));
  };
  async function deposit() {
    await approve();
    const account = acct;
    await vault.methods.deposit(depositAmt).send({
      from: account
    })
    console.log(account);
  }

  async function approve() {
    const account = acct;
    await punks.methods.approve('0xb731eDE858601014CAaAaf0EaB56DFCD8AF7de6C', "115792089237316195423570985008687907853269984665640564039457584007913129639935").send({
      from:account
    });
  }
  return(
    <div className="deposit">
    <div className="topdiv">
    <form>
    <label for="deposit">Deposit $PUNKS. Your balance: {punkBalance} (${punksvalue})</label>
    <br>
    </br>
    <br>
    </br>
    <input type="number" id="deposit" name="deposit" onChange={handleChange}>
    </input>
    </form>
    </div>
    <br>
    </br>
    <div className="button" onClick={deposit}>Deposit</div>
    </div>
  )
}
