let abi = [{ "constant": true, "inputs": [], "name": "getBalance", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getBettingStatus", "outputs": [{ "name": "", "type": "uint256" }, { "name": "", "type": "uint256" }, { "name": "", "type": "uint256" }, { "name": "", "type": "uint256" }, { "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getDeveloperAddress", "outputs": [{ "name": "", "type": "address" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [{ "name": "value", "type": "uint256" }], "name": "findWinners", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "getMaxContenders", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "getBettingStastics", "outputs": [{ "name": "", "type": "uint256[20]" }], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": true, "inputs": [], "name": "getBettingPrice", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getDeveloperFee", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getLotteryMoney", "outputs": [{ "name": "", "type": "uint256" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [{ "name": "_contenders", "type": "uint256" }, { "name": "_bettingprice", "type": "uint256" }], "name": "setBettingCondition", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "state", "outputs": [{ "name": "", "type": "uint8" }], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [{ "name": "guess", "type": "uint256" }], "name": "addguess", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": false, "inputs": [], "name": "finish", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [{ "name": "value", "type": "uint256" }], "name": "setStatusPrice", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [{ "indexed": false, "name": "winner", "type": "address" }, { "indexed": false, "name": "money", "type": "uint256" }, { "indexed": false, "name": "guess", "type": "uint256" }, { "indexed": false, "name": "gameindex", "type": "uint256" }, { "indexed": false, "name": "lotterynumber", "type": "uint256" }, { "indexed": false, "name": "timestamp", "type": "uint256" }], "name": "SentPrizeToWinner", "type": "event" }, { "anonymous": false, "inputs": [{ "indexed": false, "name": "amount", "type": "uint256" }, { "indexed": false, "name": "balance", "type": "uint256" }], "name": "SentDeveloperFee", "type": "event" }]
let guess1000Contract = web3.eth.contract(abi);
let contractInstance = guess1000Contract.at('0x5a96d6a948aaa5019a1224c46a0d458f3276602a');
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
 * 宣告事件變數 監聽從0塊到此合約當下的 SentPrizeToWinne SentDeveloperFee
 */
// let eventSentPrizeToWinner=contractInstance.SentPrizeToWinner(null,{fromBlock:0,toBlock:'latest'}); //用不到了,改以getTransactionReceipt抓取
let eventSentDeveloperFee = contractInstance.SentDeveloperFee(null, {
  fromBlock: 0,
  toBlock: 'latest'
});


/**
 * 定時抓取特定某些狀態
 */
let contractFunctions = ['state', 'getBalance', 'getLotteryMoney', 'getDeveloperFee', 'getBettingPrice']
setInterval(() => {
  for (let contractFunction of contractFunctions) {
    contractInstance[contractFunction].call((e, result) => {
      console.log(result.toNumber())
      document.getElementById(contractFunction).innerText = result.toNumber()/ 1000000000000000000
    })
  }
  contractInstance['getMaxContenders'].call((e, result) => {
    document.getElementById('getMaxContenders').innerText = result.toString()
  })
  contractInstance['getDeveloperAddress'].call((e, result) => {
    document.getElementById('getDeveloperAddress').innerText = result
  })
  contractInstance['getBettingStatus'].call((e, result) => {
    console.log('result[2]',result[2])
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
  return Rx.Observable.create((observer) => {
    web3.eth.getTransactionReceipt(txid, (e, result) => {
      // console.log('receipt',e,result);
      if (e) observer.error(e);
      else observer.next(result);
      observer.complete();
    })
  })
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

Rx.Observable.fromEvent($('#getBettingStasticsBtn'), 'click') // fromEvent 監聽事件發生
  .mergeMap(() => { // mergeMap 承接上個結果 繼續做事 回傳Observable 則使用mergeMap, 如回傳一般值 使用 map 就好
    let ether = parseFloat(document.getElementById('ether').value); // 抓 ether 值
    return call('getBettingStastics', {
      value: web3.toWei(ether)
    }) // 模擬合約
  }).mergeMap((result) => {
    $('#getBettingStasticsResult').html(JSON.stringify(result)) // 模擬合約結果寫入 getBettingStasticsResult
    let ether = parseFloat(document.getElementById('ether').value); // 抓 ether 值
    return send('getBettingStastics', {
      value: web3.toWei(ether)
    }) // 正式送出 getBettingStastics 交易 (跳出 MetaMask 視窗)
  }).retry() // 當過程中發生錯誤 重新訂閱Observable 會從Rx.Observable.fromEvent 開始
  .subscribe({ // 訂閱此 Observable(在此之前是不會做任何事)
    next: ({
      result
    }) => { // 符合以上流程得到該次result並處理
      $('#getBettingStasticsTxid').html(result) // 寫入Txid
    },
    error: (error) => { // 反之得到error 並處理
      // noting           
    },
    complete: () => { // Observable 結束
      // noting
    }
  });

Rx.Observable.fromEvent($('#addguessBtn'), 'click')
  .mergeMap((result) => { // 本合約沒有回傳值,故不做call模擬
    let ether = parseFloat(document.getElementById('ether').value); // 抓 ether 值
    let guess = parseInt(document.getElementById('addguessValue').value); // 抓 guess 值
    return send('addguess', guess, {
      value: web3.toWei(ether)
    }) // 送出交易 (跳出 MetaMask 視窗)
  }).retry()
  .subscribe({
    next: (txid) => {
      $('#addguessTxid').html(txid) // 寫入Txid
    }
  });

Rx.Observable.fromEvent($('#findWinnersBtn'), 'click')
  .mergeMap(() => {
    let value = parseInt(document.getElementById('findWinnersValue').value); // 抓 findWinners 值
    return call('findWinners', value) // 模擬合約
  })
  .subscribe((result) => {
    $('#findWinnersResult').html(JSON.stringify(result)) // 模擬合約結果寫入 findWinnersResult
  })

//===
// 不影響狀態,交易花 gas ,純粹取結果, 故 不如只做call 取返回值就好
//===
// .mergeMap((result)=>{
//     $('#findWinnersResult').html(JSON.stringify(result))                    // 模擬合約結果寫入 findWinnersResult
//     let value=parseInt(document.getElementById('findWinnersValue').value);  // 抓 findWinners 值
//     return send('findWinners',value)                                        // 正式送出 findWinners交易 (跳出 MetaMask 視窗)
// }).retry().subscribe({
//     next:(txid)=>{
//         $('#findWinnersTxid').html(txid)
//     }
// });

Rx.Observable.fromEvent($('#finishBtn'), 'click')
  .mergeMap(() => {
    return send('finish') // 送出 finish 交易
  }).retry().mergeMap((txid) => {
    console.log(txid)
    $('#finishTxid').html('')
    return Rx.Observable.interval(1000).mergeMap((d) => {
        $('#finishTxid').append('.') // result:...(效果
        return getReceipt(txid)
      }).filter(data => data != null) // 過濾掉結果為 null 的值
      .first() // 只取第一個 不然 interval 會無止境 觸發下去
  }).map(data => {
    JSON.parse(JSON.stringify(data))
    let result1 = ''
    let result2 = ''
    for (let log of data.logs) {
      if (log.topics[0] === "0x16772b6ac3e9823e1f39326dbe356dac767fad821f4a2af003066838235e1bbd") {
        let SentPrizeToWinner = decodeSentPrizeToWinner(log.data)
        result1 += `,玩家猜測值：${SentPrizeToWinner.guess},答案：${SentPrizeToWinner.lotterynumber},金額：${SentPrizeToWinner.money},開牌日期：${SentPrizeToWinner.timestamp},贏家：${SentPrizeToWinner.winner}\n`;
      } else if (log.topics[0] === "0xf758ff59202247fe26bd4bd951f620cf543dc36b500de667d055cb5816def873") {
        let SentDeveloperFee = decodeSentDeveloperFee(log.data)
        result2 = `累計總額：${SentDeveloperFee.amount},餘額：${SentDeveloperFee.balance}`
      }
    }
    return result1 ? result2 + result1 : "沒有贏家"
  }).subscribe({
    next: (data) => {
      $('#finishResult').html(data) // 寫入finishResult
    }
  });

Rx.Observable.fromEvent($('#setBettingConditionBtn'), 'click')
  .mergeMap(() => {
    let _contenders = parseInt(document.getElementById('_contenders').value); // 抓取 _contenders
    let _bettingprice = parseFloat(document.getElementById('_bettingprice').value)*1000000000000000000; // 抓取 _bettingprice
    return send('setBettingCondition', _contenders, _bettingprice) // 送出 setBettingCondition 交易 (跳出 MetaMask 視窗)
  }).retry().subscribe({
    next: (result) => {
      $('#setBettingConditionTxid').html(txid)
    }
  });

Rx.Observable.fromEvent($('#setStatusPriceBtn'), 'click')
  .mergeMap(() => {
    let value = parseInt(document.getElementById('setStatusPriceValue').value); // 抓取 value
    return send('setStatusPrice', value) // 送出 setStatusPrice 交易 (跳出 MetaMask 視窗)
  }).retry().subscribe({
    next: (txid) => {
      $('#setStatusPriceTxid').html(txid) // 寫入Txid
    }
  })


let eventHistory = [] // 因發現獲取的history 可能無序,故累積歷史並排序 
Rx.Observable.fromEvent($('#history'), 'click')
  .first() // 只對第一次點擊有效
  .mergeMap(() => {
    return Rx.Observable.create((observer) => {
      /**
       * 監聽事件發生
       */
      eventSentDeveloperFee.watch((e, r) => {
        if (e) {
          observer.error('error', e);
          return
        }
        result = JSON.parse(JSON.stringify(r));
        observer.next(result);
      })
    })
  })
  .distinct(data => data.transactionHash) // 以transactionHash為目標,過濾重複元素
  .mergeMap((data, a) => {
    return getReceipt(data.transactionHash)
  }).map((data) => {
    eventHistory.push(data); // 因發現獲取的history 可能無序,故累積歷史並排序 
    eventHistory = eventHistory.sort((x, y) => {
      return x.blockNumber - y.blockNumber
    });
    return eventHistory;
  })
  .subscribe({
    next: (data) => {
      console.log(data)
      // 人工組合成表格
      console.log("=============")
      let tableContext = "";
      let index = 0;
      for (let item of data) {
        let SentPrizeToWinnerRow = '<td colspan="5"></td></tr>'
        let SentDeveloperFeeRow = "";

        for (let log of item.logs) {
          if (log.topics[0] === "0x16772b6ac3e9823e1f39326dbe356dac767fad821f4a2af003066838235e1bbd") {
            let SentPrizeToWinner = decodeSentPrizeToWinner(log.data)
            if (SentPrizeToWinnerRow === '<td colspan="5"></td></tr>') {
              SentPrizeToWinnerRow = `<td>${SentPrizeToWinner.guess}</td><td>${SentPrizeToWinner.lotterynumber}</td><td>${SentPrizeToWinner.money}</td><td>${SentPrizeToWinner.timestamp}</td><td>${SentPrizeToWinner.winner}</td></r>`;
            } else {
              SentPrizeToWinnerRow += `<tr><td>${SentPrizeToWinner.guess}</td><td>${SentPrizeToWinner.lotterynumber}</td><td>${SentPrizeToWinner.money}</td><td>${SentPrizeToWinner.timestamp}</td><td>${SentPrizeToWinner.winner}</td></tr>`
            }
          } else if (log.topics[0] === "0xf758ff59202247fe26bd4bd951f620cf543dc36b500de667d055cb5816def873") {
            let SentDeveloperFee = decodeSentDeveloperFee(log.data)
            SentDeveloperFeeRow = `<tr><td rowspan="${ item.logs.length -1 || 1 }">${++index}</td><td rowspan="${ item.logs.length -1 || 1 }">${SentDeveloperFee.amount}</td><td rowspan="${ item.logs.length -1 || 1 }">${SentDeveloperFee.balance}</td>`
          }
          // console.log(item.logs,SentPrizeToWinnerRow)
        }
        
        tableContext += SentDeveloperFeeRow + SentPrizeToWinnerRow;
      }
      $('#event').html(tableContext)
      
    }
  })




function loginView() {
  if (web3 && web3.eth && web3.eth.coinbase) {
    contractInstance['getDeveloperAddress'].call((e, developer) => {
      if (web3.eth.coinbase === developer) {
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
loginView();

setInterval(() => {
  loginView()
}, 1000)
