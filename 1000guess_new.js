let abi = [{ "constant": true, "inputs": [], "name": "getBalance", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getBettingStatus", "outputs": [{ "name": "", "type": "uint256" }, { "name": "", "type": "uint256" }, { "name": "", "type": "uint256" }, { "name": "", "type": "uint256" }, { "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getDeveloperAddress", "outputs": [{ "name": "", "type": "address" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [{ "name": "value", "type": "uint256" }], "name": "findWinners", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "getMaxContenders", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "getBettingStastics", "outputs": [{ "name": "", "type": "uint256[20]" }], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": true, "inputs": [], "name": "getBettingPrice", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getDeveloperFee", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getLotteryMoney", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [{ "name": "_contenders", "type": "uint256" }, { "name": "_bettingprice", "type": "uint256" }], "name": "setBettingCondition", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "state", "outputs": [{ "name": "", "type": "uint8" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [{ "name": "guess", "type": "uint256" }], "name": "addguess", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": false, "inputs": [], "name": "finish", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [{ "name": "value", "type": "uint256" }], "name": "setStatusPrice", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [{ "indexed": false, "name": "winner", "type": "address" }, { "indexed": false, "name": "money", "type": "uint256" }, { "indexed": false, "name": "guess", "type": "uint256" }, { "indexed": false, "name": "gameindex", "type": "uint256" }, { "indexed": false, "name": "lotterynumber", "type": "uint256" }, { "indexed": false, "name": "timestamp", "type": "uint256" }], "name": "SentPrizeToWinner", "type": "event" }, { "anonymous": false, "inputs": [{ "indexed": false, "name": "amount", "type": "uint256" }, { "indexed": false, "name": "balance", "type": "uint256" }], "name": "SentDeveloperFee", "type": "event" }]
contractaddress = "0x5a96d6a948aaa5019a1224c46a0d458f3276602a";
developerAddress ="0xa878C38b27D0C7b3b30Fbf5DBE417f56357D06Fb";
web3js= new Web3(window.ethereum);
ethereum.request({ method: 'eth_accounts' }).then(result => myMetaMaskWallet = result);
contractInstance = new web3js.eth.Contract(abi,contractaddress);
console.log('contractInstance', contractInstance);

Date.prototype.Format = function (fmt) { //author: meizz
    var o = {
        "M+": this.getMonth() + 1, //月份
        "d+": this.getDate(), //日
        "H+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

setInterval(() => {
  contractInstance.methods.state().call((e, result) => {
    temp = result;
    document.getElementById("state").innerText = temp;
  });
  contractInstance.methods.getBalance().call((e, result) => {
    document.getElementById("getBalance").innerText = result/1000000000000000000;
  });
  contractInstance.methods.getLotteryMoney().call((e, result) => {
    document.getElementById("getLotteryMoney").innerText = result/1000000000000000000
  });
  contractInstance.methods.getDeveloperFee().call((e, result) => {
    document.getElementById("getDeveloperFee").innerText = result/1000000000000000000
  });
  contractInstance.methods.getBettingPrice().call((e, result) => {
    document.getElementById("getBettingPrice").innerText = result/1000000000000000000
  });
  contractInstance.methods.getMaxContenders().call((e, result) => {
    document.getElementById('getMaxContenders').innerText = result
  });
  contractInstance.methods.getDeveloperAddress().call((e, result) => {
    document.getElementById('getDeveloperAddress').innerText = result
  });
  contractInstance.methods.getBettingStatus().call((e, result) => {
    result[0] = Number( result[0] );
    result[1] = Number( result[1] );
    result[2] = result[2] / 1000000000000000000;
    result[3] = result[3] / 1000000000000000000;
    result[4] = result[4] / 1000000000000000000;
    document.getElementById('getBettingStatus').innerText =
    `合約狀態：${result[0]?'上鎖':'開放下注中'}
      累積猜測次數:${result[1]}
      累積樂透淨額:${result[2]}
      合約餘額:${result[3]}
      每注金額:${result[4]}`
  });
}, 1500);

function betting(){
  let ether = parseFloat(document.getElementById('ether').value);// 抓 ether 值
  amount = ether * Math.pow(10,18)
  let guess = parseInt(document.getElementById('addguessValue').value); // 抓 guess 值
  contractInstance.methods.addguess(guess)
  .send({from: myMetaMaskWallet[0], value:amount.toString() })
  .then(console.log);
  }

  /**
 * @description 取得交易logs
 * @param {string} txid
 */
function getReceipt(txid) {
  return Rx.Observable.create((observer) => {
    web3js.eth.getTransactionReceipt(txid, (e, result) => {
      // console.log('receipt',e,result);
      if (e) observer.error(e);
      else observer.next(result);
      observer.complete();
    })
  })
}


  function finish(){
  contractInstance.methods.finish().send({from: myMetaMaskWallet[0]})
  .then(res =>console.log(res))
  .then(txid =>getReceipt(txid));
  }

function decodeSentPrizeToWinner(data) {
  let winner = "0x" + data.substr(2 + 24, 40)
  let money = parseInt(data.substr(2 + 64, 64), 16) + ""
  let guess = parseInt(data.substr(2 + 64 * 2, 64), 16) + ""
  let gameindex = parseInt(data.substr(2 + 64 * 3, 64), 16) + ""
  let lotterynumber = parseInt(data.substr(2 + 64 * 4, 64), 16) + ""
  let timestamp = parseInt(data.substr(2 + 64 * 5, 64), 16) + ""

  let SentPrizeToWinner = {
    winner: winner,
    money: money/1000000000000000000,
    guess: guess,
    gameindex: gameindex,
    lotterynumber: lotterynumber,
    timestamp: new Date(Number(timestamp)*1000).Format('yyyy年MM月dd日 HH時mm分ss秒')
  }
  return SentPrizeToWinner
}

function decodeSentDeveloperFee(data) {
  let amount = parseInt(data.substr(2, 64), 16) + ""
  let balance = parseInt(data.substr(2 + 64, 64), 16) + ""
  let SentDeveloperFee = {
    amount: amount/1000000000000000000,
    balance: balance/1000000000000000000
  };
  return SentDeveloperFee;
}

function loginView() {
  if (window.ethereum.isMetaMask) {
    contractInstance.methods.getDeveloperAddress.call((e, developer) => {
      if (developerAddress === developer) {
        $('#noLogin').css({
          display: 'none'
        })
        $('#forPlayer').css({
          display: 'none'
        })
        $('#forFounder').css({
          display: 'block'
        })
      } else {
        $('#noLogin').css({
          display: 'none'
        })
        $('#forPlayer').css({
          display: 'block'
        })
        $('#forFounder').css({
          display: 'none'
        })
      }
    })
  } else {
    $('#noLogin').css({
      display: 'block'
    })
    $('#forPlayer').css({
      display: 'none'
    })
    $('#forFounder').css({
      display: 'none'
    })
  }
}
// loginView();

// setInterval(() => {
//   loginView()
// }, 1000)
