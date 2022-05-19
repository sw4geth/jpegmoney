import React, { useState, useEffect } from "react";
import ConnectButton from './ConnectButton';

  function Main({Component, pageProps}) {
    const [acct, setAcct] = useState('');
    const [active, setActive] = useState(false);

    return (
      <div>
      <ConnectButton setAcct={setAcct} setActive={setActive} active={active} />

      </div>
    );
  }
  export default Main;
