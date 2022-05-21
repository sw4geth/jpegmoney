import React, { useState, useEffect } from "react";
import ConnectButton from './ConnectButton';
import User from './User';
import Deposit from './Deposit';
import Borrow from './Borrow';
import Repay from './Repay';
import Title from './DappTitle';

  function Main({Component, pageProps}) {
    const [acct, setAcct] = useState('');
    const [active, setActive] = useState(false);
    const [vault, setVault] = useState();
    const [colPrice, setColPrice] = useState('');
    const [depositAmt, setDeposit] = useState('');
    const [punks, setPunks] = useState();
    const [punkBalance, setPunkBalance] = useState('');
    const [borrowAmt, setBorrow] = useState('');
    const [netWorth, setNetworth] = useState('');
    const [debt, setDebt] = useState('');

    return (
      <div>
      <Title />
      <ConnectButton setAcct={setAcct} acct={acct} setActive={setActive} active={active} setVault={setVault} setColPrice={setColPrice} setPunks={setPunks} punks={punks} setPunkBalance={setPunkBalance} setNetworth={setNetworth} setDebt={setDebt} />
      <User colPrice={colPrice} vault={vault} acct={acct} netWorth={netWorth} setNetworth={setNetworth} />
      <Deposit acct={acct} setDeposit={setDeposit} depositAmt={depositAmt} vault={vault} punks={punks} punkBalance={punkBalance} colPrice={colPrice}/>
      <Borrow acct={acct} setBorrow={setBorrow} borrowAmt={borrowAmt} vault={vault} debt={debt}/>
      <Repay />
      </div>
    );
  }
  export default Main;
