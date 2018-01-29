let abi = [ { "constant": true, "inputs": [], "name": "totalMakerReceived", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "contractBalance", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "playersCount", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "", "type": "uint256" } ], "name": "playersAddressList", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "", "type": "address" } ], "name": "players", "outputs": [ { "name": "id", "type": "uint256" }, { "name": "addr", "type": "address" }, { "name": "bettingMoney", "type": "uint256" }, { "name": "contribution", "type": "uint256" }, { "name": "balance", "type": "uint256" }, { "name": "totalBettingMoney", "type": "uint256" }, { "name": "totalContribution", "type": "uint256" }, { "name": "winOrLose", "type": "int256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "developer", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "maker", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "moneyReceived", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "constant": false, "inputs": [], "name": "addBalance", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_maker", "type": "address" } ], "name": "setMaker", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "winMoney", "type": "uint256" } ], "name": "playerWin", "type": "event" }, { "constant": false, "inputs": [ { "name": "applicant", "type": "address" } ], "name": "finish", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "money", "type": "uint256" } ], "name": "insufficientBalance", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "winMoney", "type": "uint256" } ], "name": "moneySendedEvent", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "money", "type": "uint256" } ], "name": "makerReceivedEvent", "type": "event" }, { "constant": false, "inputs": [ { "name": "player_wallet_addr", "type": "address" }, { "name": "final_balance", "type": "uint256" } ], "name": "settlement", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "money", "type": "uint256" } ], "name": "moneyReceivedEvent", "type": "event" } ]
let duboContract = web3.eth.contract(abi);
let contractInstance = duboContract.at('0x2f410142194842AF84eF2F35016487fBD1F647Ea');
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


/**
 * 定時抓取特定某些狀態
 */
setInterval(() => {
  contractInstance['maker'].call((e, result) => {
    document.getElementById('maker').innerText = result.toString();
  })
  contractInstance['contractBalance'].call((e, result) => {
    document.getElementById('contractBalance').innerText = result.toString() / 1000000000000000000;
  })
  contractInstance['developer'].call((e, result) => {
    document.getElementById('developer').innerText = result.toString()
  })
}, 1000);



/**
 * @description 模擬交易過程
 * @param {string} contractFunction 合約名稱
 * @param {args} args 參數 
 */
function call(contractFunction, ...args) {
  return Rx.Observable.create((observer) => { // Observable 可觀察對象, observer觀察者
    contractInstance[contractFunction].call(...args, (e, result) => { // .call 模擬交易 ,ES6 ...args 陣列展開,如 console.log(...[1,2,3]) 等同 console.log(1,2,3)
      if (e) observer.error(e); // 如果有 e (error) 則拋出 observer.error 例外
      else observer.next(result); // 否則將 result 用 observer.next 送出使 Observable 觀察
      observer.complete();
    })
  })
}

/**
 * @description 送出交易
 * @param {string} contractFunction 合約名稱
 * @param {args} args 參數 
 */
function send(contractFunction, ...args) {
  return Rx.Observable.create((observer) => {
    contractInstance[contractFunction](...args, (e, txid) => { // 送出交易
      console.log('send', e, txid);
      if (e) observer.error(e);
      else observer.next(txid);
      observer.complete();
    })
  })
}

/**
 * @description 取得交易logs
 * @param {string} txid 
 */
function getReceipt(txid) {
  console.log(txid)
  return Rx.Observable.create((observer) => {
    web3.eth.getTransactionReceipt(txid, (e, result) => {
      // console.log('receipt',e,result);
      if (e) observer.error(e);
      else observer.next(result);
      observer.complete();
    })
  })
}


Rx.Observable.fromEvent($('#playersBtn'), 'click')
  .mergeMap(() => {
    let address = document.getElementById('playersAddress').value;
    return call('players', address);
  }).retry().subscribe((data) => {
    data = JSON.parse(JSON.stringify(data));
    //document.getElementById('playersResult').innerText=data;
    document.getElementById('playerID').value = data[0];
    document.getElementById('playerAddress').value = data[1];
    document.getElementById('playerBetting').value = data[2] / 1000000000000000000;
    document.getElementById('playerContribution').value = data[3] / 1000000000000000000;
    document.getElementById('playerBalance').value = data[4] / 1000000000000000000;
    document.getElementById('playerTotalBettingMoney').value = data[5] / 1000000000000000000;
    document.getElementById('playerTotalContribution').value = data[6] / 1000000000000000000;
    document.getElementById('playerWinOrLose').value = data[7] / 1000000000000000000;
  })


Rx.Observable.fromEvent($('#money_receivedBtn'), 'click')
  .mergeMap((result) => { // 本合約沒有回傳值,故不做call模擬
    let ether = parseFloat(document.getElementById('ether').value); // 抓 ether 值
    return send('moneyReceived', {
      value: web3.toWei(ether)
    }) // 送出交易 (跳出 MetaMask 視窗)
  }).retry().subscribe();


Rx.Observable.fromEvent($('#setMakerBtn'), 'click')
  .mergeMap(() => {
    let makerAddress = document.getElementById('setMakerValue').value
    return send('setMaker', makerAddress) // 送出 setMaker 交易
  }).retry().subscribe()



Rx.Observable.fromEvent($('#addBalanceBtn'), 'click')
  .mergeMap(() => {
    let ether = parseFloat(document.getElementById('ether').value); // 抓 ether 值
    return send('addBalance', {
      value: web3.toWei(ether)
    }) // 送出 setMaker 交易
  }).retry().subscribe()

Rx.Observable.fromEvent($('#settlementBtn'), 'click')
  .mergeMap(() => {
    let address = document.getElementById('settlementAddressValue').value;
    let balance = web3.toWei(parseFloat(document.getElementById('settlementBalanceValue').value));
    return send('settlement', address, balance);
  }).retry().subscribe()


Rx.Observable.fromEvent($('#finishBtn'), 'click')
  .mergeMap(() => {
    let address = document.getElementById('finishValue').value;
    return send('settlement', address);
  }).retry().subscribe()






function loginView() {
  let devOb = Rx.Observable.create((observer) => {
    contractInstance['developer'].call((e, developer) => {
      observer.next(developer.toString() === web3.eth.coinbase);
    })
  })
  let makerOb = Rx.Observable.create((observer) => {
    contractInstance['maker'].call((e, maker) => {
      observer.next(maker.toString() === web3.eth.coinbase);
    })
  })
  devOb.zip(makerOb, (dev, maker) => {
    if (!web3.eth.coinbase) {
      $('#noLogin').css({ display: 'block' })
      $('#forDeveloper').css({ display: 'none' })
      $('#forMaker').css({ display: 'none' })
      $('#forPlayer').css({ display: 'none' })
      return 1
    }
    $('#noLogin').css({ display: 'none' })
    $('#forDeveloper').css({ display: 'none' })
    $('#forMaker').css({ display: 'none' })
    $('#forPlayer').css({ display: 'none' })
    if (dev) {
      $('#forDeveloper').css({ display: 'block' })
    }
    if (maker) {
      $('#forMaker').css({ display: 'block' })
    }
    if (dev || maker) {
      return 1;
    }
    $('#forPlayer').css({ display: 'block' })
    return 1;
  }).subscribe()
}
loginView();

setInterval(() => {
  loginView()
}, 1000)



let moneyReceivedEvent = contractInstance.moneyReceivedEvent(null, { fromBlock: 0, toBlock: 'latest' });

moneyReceivedEvent.watch(async(e, r) => {
    if( e ) {
        console.error(e);
        return;
    }
    
    let result = JSON.parse(JSON.stringify(r));
    let timestamp = await new Promise((resolve,reject)=>{
      web3.eth.getBlock(result.blockNumber,(e,r)=>{
        e || resolve(r.timestamp)
      })
    })
    let date=new Date(timestamp*1000).Format('yyyy-MM-dd HH:mm:ss');
    let row = `<tr><td>${result.args['player']}</td><td>${result.args['money']/1000000000000000000}</td><td>${date}</td></tr>`;
    document.getElementById('moneyReceivedEventHistory').innerHTML += row;
})


let playersCountOb = Rx.Observable.interval(1000).mergeMap(()=>{
  return call('playersCount')
}).map(r=>JSON.parse(JSON.stringify(r)))


let playersGlobal=[];
playersCountOb.mergeMap((data)=>{
  return Rx.Observable.create((observer) => {
    for(let i=0 ;i< data;i++){
      contractInstance['playersAddressList'].call(i,(e,r)=>{
        e && observer.error(e);
        e || observer.next(r);   
      })
    }
  })
}).map(data=>{
  playersGlobal=[]
  contractInstance['players'].call(data,(e,player)=>{
    player = JSON.parse(JSON.stringify(player));
    playersGlobal.push(player)
  })
  
}).subscribe()


Rx.Observable.interval(1000).subscribe({
  next:()=>{
    let players=[...playersGlobal];
    players.sort((a,b)=>{
      return a[5]-b[5];
    })
    document.getElementById('bettingMoneyRanking').innerHTML=''
    result='';
    for(let player of players){
      result+=`<tr><td>${player[1]}</td><td>${player[5]/1000000000000000000}</td></tr>` 
    }
    document.getElementById('bettingMoneyRanking').innerHTML=result;
  }
}) 

Rx.Observable.interval(1000).subscribe({
  next:()=>{
    let players=[...playersGlobal];
    players.sort((a,b)=>{
      return a[6]-b[6];
    })
    document.getElementById('contributionRanking').innerHTML=''
    result='';
    for(let player of players){
      result+=`<tr><td>${player[1]}</td><td>${player[6]/1000000000000000000}</td></tr>` 
    }
    document.getElementById('contributionRanking').innerHTML=result;
  }
}) 

Rx.Observable.interval(1000).subscribe({
  next:()=>{
    let players=[...playersGlobal];
    players.sort((a,b)=>{
      return a[7]-b[7];
    })
    document.getElementById('winOrLoseRanking').innerHTML=''
    result='';
    for(let player of players){
      result+=`<tr><td>${player[1]}</td><td>${player[7]/1000000000000000000}</td></tr>` 
    }
    document.getElementById('winOrLoseRanking').innerHTML=result;
  }
}) 