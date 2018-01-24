let abi = [ { "constant": true, "inputs": [], "name": "maker", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "", "type": "address" } ], "name": "players", "outputs": [ { "name": "addr", "type": "address" }, { "name": "bettingMoney", "type": "uint256" }, { "name": "contribution", "type": "uint256" }, { "name": "balance", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "contractBalance", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "developer", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "addBalance", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": false, "inputs": [ { "name": "player_wallet_addr", "type": "address" }, { "name": "final_balance", "type": "uint256" } ], "name": "settlement", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "winMoney", "type": "uint256" } ], "name": "playerWin", "type": "event" }, { "constant": false, "inputs": [], "name": "money_received", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "constant": false, "inputs": [ { "name": "applicant", "type": "address" } ], "name": "finish", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_maker", "type": "address" } ], "name": "setMaker", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" } ]
let guess1000Contract = web3.eth.contract(abi);
let contractInstance = guess1000Contract.at('0x7507652E678e1BcA3C0A9e9a77544D6318E51687');
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
let contractFunctions = ['maker','contractBalance','developer']
setInterval(() => {
  for (let contractFunction of contractFunctions) {
    contractInstance[contractFunction].call((e, result) => {
      document.getElementById(contractFunction).innerText =  parseFloat(result.toString()) ? parseFloat(result.toString())/1000000000000000000 : result.toString()
    })
  }
}, 1000);



/**
 * @description 模擬交易過程
 * @param {string} contractFunction 合約名稱
 * @param {args} args 參數 
 */
function call(contractFunction, ...args) {
  return Rx.Observable.create((observer) => { // Observable 可觀察對象, observer觀察者
    contractInstance[contractFunction].call(...args, (e, result) => { // .call 模擬交易 ,ES6 ...args 陣列展開,如 console.log(...[1,2,3]) 等同 console.log(1,2,3)
      console.log('call', e, result);
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
    let address=document.getElementById('playersAddress').value;
    return call('players',address);
}).retry().subscribe((data)=>{
    data=JSON.stringify(data,null,2)
    document.getElementById('playersResult').innerText=data;
})




Rx.Observable.fromEvent($('#money_receivedBtn'), 'click')
.mergeMap((result) => { // 本合約沒有回傳值,故不做call模擬
    let ether = parseFloat(document.getElementById('ether').value); // 抓 ether 值
    return send('money_received', {
        value: web3.toWei(ether)
    }) // 送出交易 (跳出 MetaMask 視窗)
}).retry().subscribe();


Rx.Observable.fromEvent($('#setMakerBtn'), 'click')
.mergeMap(() => {
    let makerAddress=document.getElementById('setMakerValue').value
    return send('setMaker',makerAddress) // 送出 setMaker 交易
}).retry().subscribe()



Rx.Observable.fromEvent($('#addBalanceBtn'), 'click')
.mergeMap(() => {
    let ether = parseFloat(document.getElementById('ether').value); // 抓 ether 值
    return send('addBalance',{
        value: web3.toWei(ether)
    }) // 送出 setMaker 交易
}).retry().subscribe()

Rx.Observable.fromEvent($('#settlementBtn'), 'click')
.mergeMap(() => {
    let address = document.getElementById('settlementAddressValue').value;
    let balance = web3.toWei(parseFloat(document.getElementById('settlementBalanceValue').value));
    return send('settlement',address,balance);
}).retry().subscribe()


Rx.Observable.fromEvent($('#finishBtn'), 'click')
.mergeMap(() => {
    let address = document.getElementById('finishValue').value;
    return send('settlement',address);
}).retry().subscribe()






function loginView() {
    let devOb=Rx.Observable.create((observer) => {
        contractInstance['developer'].call((e, developer) => {
            observer.next(developer.toString()===web3.eth.coinbase);
        })
    })
    let makerOb=Rx.Observable.create((observer) => {
        contractInstance['maker'].call((e, maker) => {
            observer.next(maker.toString()===web3.eth.coinbase);
        })
    })
    devOb.zip(makerOb,(dev,maker)=>{
        if(!web3.eth.coinbase){
            $('#noLogin').css({
                display: 'block'
            })
            $('#forDeveloper').css({
                display: 'none'
            })
            $('#forMaker').css({
                display: 'none'
            })
            $('#forPlayer').css({
                display: 'none'
            })
            return 1
        }
        $('#noLogin').css({
            display: 'none'
        })
        $('#forDeveloper').css({
            display: 'none'
        })
        $('#forMaker').css({
            display: 'none'
        })
        $('#forPlayer').css({
            display: 'none'
        })
        if(dev){
            $('#forDeveloper').css({
                display: 'block'
            })
        }
        if(maker){
            $('#forMaker').css({
                display: 'block'
            })
        }
        if(dev || maker){return 1;}
        $('#forPlayer').css({
            display: 'block'
        })
        return 1;
    }).subscribe()
}
loginView();

setInterval(() => {
  loginView()
}, 1000)
