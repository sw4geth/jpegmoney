import Web3 from "web3";

export default function Borrow({setBorrow, borrowAmt, vault, acct, debt}) {

  const web3 = new Web3(new Web3.providers.HttpProvider("https://rinkeby.infura.io/v3/04a944092bf1448bb6ccbbae196e56f1"));

  const handleChange = (e) => {
    setBorrow(web3.utils.toWei(e.target.value));
  };

  async function borrowUSD() {
    const account = acct;
    await vault.methods.borrow(borrowAmt).send({
      from: account
    })
  }
  return(
    <div className="borrow">
    <div className="topdiv">
    <form>
    <label for="borrow">Borrow $JPEGUSD.  Your debt is ${debt}</label>
    <br>
    </br>
    <br>
    </br>
    <input type="number" id="borrow" name="borrow" onChange={handleChange}>
    </input>
    </form>
    </div>
    <div className="button" onClick={borrowUSD}>Borrow</div>
    </div>
  )
}
