let sha256 = require('ethereumjs-util').sha256;
let sha3 = require('ethereumjs-util').sha3;
let storage = require('./storage');
let env = require('./env');
let Rx = require('rxjs');
let ajax = require('@fdaciuk/ajax')();
let Web3 = require('./web3.js');
let web3 = new Web3();
web3.setProvider(new Web3.providers.HttpProvider('https://ropsten.infura.io/Uw7vEslp5bpgqPgNkm05'));
let abi = [ { "constant": true, "inputs": [ { "name": "", "type": "uint256" } ], "name": "playersAddressList", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "applicant", "type": "address" } ], "name": "finish", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "maker", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "totalMakerReceived", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "player_wallet_addr", "type": "address" }, { "name": "final_balance", "type": "uint256" } ], "name": "settlement", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "contractBalance", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "playersCount", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "addr", "type": "address" } ], "name": "deWater", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [], "name": "addBalance", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_maker", "type": "address" } ], "name": "setMaker", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "developer", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "", "type": "address" } ], "name": "players", "outputs": [ { "name": "id", "type": "uint256" }, { "name": "addr", "type": "address" }, { "name": "bettingMoney", "type": "uint256" }, { "name": "contribution", "type": "uint256" }, { "name": "balance", "type": "uint256" }, { "name": "totalBettingMoney", "type": "uint256" }, { "name": "totalContribution", "type": "uint256" }, { "name": "winOrLose", "type": "int256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "moneyReceived", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "winMoney", "type": "uint256" } ], "name": "playerWin", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "money", "type": "uint256" } ], "name": "moneyReceivedEvent", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "winMoney", "type": "uint256" } ], "name": "moneySendedEvent", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "money", "type": "uint256" } ], "name": "makerReceivedEvent", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "money", "type": "uint256" } ], "name": "insufficientBalance", "type": "event" } ];
let duboContract = web3.eth.contract(abi);
let contractAddress = '0x2523127504a12dedef3fd968b89a8d8c53cb5cd9';
let contractInstance = duboContract.at(contractAddress);

let _maker = '';
let _contractBalance = '';
let _developer = '';
let _playerCount = '0';

setInterval(() => {
  contractInstance['contractBalance'].call((e, result) => {
    _contractBalance = result.toString() / 1000000000000000000;
  })
  contractInstance['maker'].call((e, result) => {
    _maker = result.toString();
  })
}, 30000)
contractInstance['developer'].call((e, result) => {
  _developer = result.toString();
})

module.exports.received_ranking = function received_ranking() {
  let players = [...playersGlobal];
  players = players.sort((a, b) => {
    return b[5] - a[5];
  })
  players = players.map(v => {
    return {
      "player": v[1],
      "money": v[5]
    }
  })
  return players;
}
module.exports.contribution_ranking = function contribution_ranking() {
  let players = [...playersGlobal];
  players = players.sort((a, b) => {
    return b[6] - a[6];
  })
  players = players.map(v => {
    return {
      "player": v[1],
      "money": v[6]
    }
  })
  return players;
}
module.exports.winOrLose_ranking = function winOrLose_ranking() {
  let players = [...playersGlobal];
  players = players.sort((a, b) => {
    return b[7] - a[7];
  })
  players = players.map(v => {
    return {
      "player": v[1],
      "money": v[7]
    }
  })
  return players;
}


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

module.exports.getInto = function getInto() {
  return {
    "maker": _maker,
    "developer": _developer,
    "contractBalance": _contractBalance
  }
}

module.exports.setMaker = function setMaker(makerAddress) {
  return send('setMaker', makerAddress).map(txid => {
    return storage.newOrder(txid);
  }) // 送出 setMaker 交易
}


module.exports.settlement = function settlement(address, balance) {
  return send('settlement', address, balance).map(txid => {
    return storage.newOrder(txid);
  }) // 送出 settlement 交易
}
module.exports.finish = function finish(address) {
  return send('finish', address).map(txid => {
    return storage.newOrder(txid);
  }); // 送出 finish 交易
}

module.exports.player_status_from_address = function player_status_from_address(address) {
  return call('players', address).map(data => {
    return {
      "playerID": data[0],
      "playerAddress": data[1],
      "playerBetting": data[2] / 1000000000000000000,
      "playerContribution": data[3] / 1000000000000000000,
      "playerBalance": data[4] / 1000000000000000000,
      "playerTotalBettingMoney": data[5] / 1000000000000000000,
      "playerTotalContribution": data[6] / 1000000000000000000,
      "playerWinOrLose": data[7] / 1000000000000000000,
    }
  });
}
module.exports.player_status_from_id = function player_status_from_id(id) {
  return call('playersAddressList', id).mergeMap(address => {
    return call('players', address).map(data => {
      return {
        "playerID": data[0],
        "playerAddress": data[1],
        "playerBetting": data[2] / 1000000000000000000,
        "playerContribution": data[3] / 1000000000000000000,
        "playerBalance": data[4] / 1000000000000000000,
        "playerTotalBettingMoney": data[5] / 1000000000000000000,
        "playerTotalContribution": data[6] / 1000000000000000000,
        "playerWinOrLose": data[7] / 1000000000000000000,
      }
    });
  })

}



let playersCountOb = Rx.Observable.interval(30000).mergeMap(() => {
  return call('playersCount')
}).map(r => JSON.parse(JSON.stringify(r)))


let playersGlobal = [];
playersCountOb.subscribe((index) => {
  for (let i = 0; i < index; i++) {
    contractInstance['playersAddressList'].call(i, (e, r) => {
      let address = r;
      contractInstance['players'].call(address, (e, player) => {
        if (!e) {
          player = JSON.parse(JSON.stringify(player));
          playersGlobal[i] = player;
        }
      })
    })
  }
});

playersCountOb.subscribe(data=>{
  _playerCount = data;
})

module.exports.getPlayerCount = () => _playerCount;

module.exports.received_history = function received_history(start = undefined, end = undefined) {
  let topics = sha3('moneyReceivedEvent(address,uint256)').toString('hex');
  let parames = encodeURI(JSON.stringify([{
    topics: ['0x' + topics],
    address: contractAddress,
    fromBlock: start,
    toBlock: end
  }]));
  let url = `${env.filterUrl}?params=${parames}`;
  let response = ajax.get(url);
  return response;
}


module.exports.deWater =  function deWater(address) {
  return send('deWater', address).map(txid => {
    return storage.newOrder(txid);
  }); // 送出 finish 交易
}
