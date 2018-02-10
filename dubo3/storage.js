let Web3 = require('./web3.js');
let web3 = new Web3();
web3.setProvider(new Web3.providers.HttpProvider('https://ropsten.infura.io/Uw7vEslp5bpgqPgNkm05'));
let abi = [ { "constant": true, "inputs": [ { "name": "", "type": "uint256" } ], "name": "playersAddressList", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "applicant", "type": "address" } ], "name": "finish", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "maker", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "totalMakerReceived", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "player_wallet_addr", "type": "address" }, { "name": "final_balance", "type": "uint256" } ], "name": "settlement", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "contractBalance", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "playersCount", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "addr", "type": "address" } ], "name": "deWater", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [], "name": "addBalance", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_maker", "type": "address" } ], "name": "setMaker", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "developer", "outputs": [ { "name": "", "type": "address" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [ { "name": "", "type": "address" } ], "name": "players", "outputs": [ { "name": "id", "type": "uint256" }, { "name": "addr", "type": "address" }, { "name": "bettingMoney", "type": "uint256" }, { "name": "contribution", "type": "uint256" }, { "name": "balance", "type": "uint256" }, { "name": "totalBettingMoney", "type": "uint256" }, { "name": "totalContribution", "type": "uint256" }, { "name": "winOrLose", "type": "int256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "moneyReceived", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "winMoney", "type": "uint256" } ], "name": "playerWin", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "money", "type": "uint256" } ], "name": "moneyReceivedEvent", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "winMoney", "type": "uint256" } ], "name": "moneySendedEvent", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "player", "type": "address" }, { "indexed": false, "name": "money", "type": "uint256" } ], "name": "makerReceivedEvent", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "money", "type": "uint256" } ], "name": "insufficientBalance", "type": "event" } ];
let duboContract = web3.eth.contract(abi);
let contractAddress = '0x2523127504a12dedef3fd968b89a8d8c53cb5cd9';
let contractInstance = duboContract.at(contractAddress);

let sha256 = require('ethereumjs-util').sha256;

let order_list = {};


module.exports.getOrderStatus = function getOrderStatus(order_id){
    let order=order_list[order_id];
    return new Promise(resolve=>{
        web3.eth.getTransactionReceipt(order.txid,(data)=>{
            if(!data.blockNumber){
                return order.status = 1; // wait
            }else if(data.status==='0x0'){
                return order.status = 3; // fails
            }else if(data.status==='0x1'){
                return order.status = 2; // success
            }
            resolve(order)
        })
    })
}

module.exports.getOrder = function getOrder(order_id){
    return getOrderStatus(order_id)
}

module.exports.newOrder = function newOrder(txid){
    let order_id = sha256(txid+"2018/02/04");
    order_list[order_id]={
        status:0,
        txid:txid,
        order_id: order_id
    }
    return order_id;
}
