let abi = [{"constant": true,"inputs": [],"name": "getBalance","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "getBettingStatus","outputs": [{"name": "","type": "uint256"},{"name": "","type": "uint256"},{"name": "","type": "uint256"},{"name": "","type": "uint256"},{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "getDeveloperAddress","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "value","type": "uint256"}],"name": "findWinners","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "getMaxContenders","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [],"name": "getBettingStastics","outputs": [{"name": "","type": "uint256[20]"}],"payable": true,"stateMutability": "payable","type": "function"},{"constant": true,"inputs": [],"name": "getBettingPrice","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "getDeveloperFee","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "getLotteryMoney","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_contenders","type": "uint256"},{"name": "_bettingprice","type": "uint256"}],"name": "setBettingCondition","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "state","outputs": [{"name": "","type": "uint8"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "guess","type": "uint256"}],"name": "addguess","outputs": [],"payable": true,"stateMutability": "payable","type": "function"},{"constant": false,"inputs": [],"name": "finish","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [{"name": "value","type": "uint256"}],"name": "setStatusPrice","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"inputs": [],"payable": false,"stateMutability": "nonpayable","type": "constructor"},{"anonymous": false,"inputs": [{"indexed": false,"name": "winner","type": "address"},{"indexed": false,"name": "money","type": "uint256"},{"indexed": false,"name": "guess","type": "uint256"},{"indexed": false,"name": "gameindex","type": "uint256"},{"indexed": false,"name": "lotterynumber","type": "uint256"},{"indexed": false,"name": "timestamp","type": "uint256"}],"name": "SentPrizeToWinner","type": "event"},{"anonymous": false,"inputs": [{"indexed": false,"name": "amount","type": "uint256"},{"indexed": false,"name": "balance","type": "uint256"}],"name": "SentDeveloperFee","type": "event"}]
let guess1000Contract = web3.eth.contract(abi);
let contractInstance = guess1000Contract.at('0x5a96d6a948aaa5019a1224c46a0d458f3276602a');
let eventSentPrizeToWinner=contractInstance.SentPrizeToWinner();
let eventSentDeveloperFee=contractInstance.SentDeveloperFee();


eventSentPrizeToWinner.watch((e,r)=>{
    $('#SentPrizeToWinnerResult').html(JSON.stringify(r))
})
eventSentDeveloperFee.watch((e,r)=>{
    $('#SentDeveloperFeeResult').html(JSON.stringify(r))
})


let contractFunctions=['state','getBalance','getMaxContenders','getLotteryMoney','getDeveloperFee','getBettingPrice']
setInterval(()=>{
   for(let contractFunction of contractFunctions) {
    contractInstance[contractFunction].call((e,result)=>{
        document.getElementById(contractFunction).innerText=result.c[0]+""
    })
    contractInstance['getDeveloperAddress'].call((e,result)=>{
        document.getElementById('getDeveloperAddress').innerText=result
    })
    contractInstance['getBettingStatus'].call((e,result)=>{
        document.getElementById('getBettingStatus').innerText=JSON.stringify(result,null,3)
    })
   }
}, 1000);

console.log(contractInstance)

function call(contractFunction,...args){
    return Rx.Observable.create((observer) => {
	    contractInstance[contractFunction].call(...args,(e,result)=>{
            console.log('call',e,result);
            e && observer.throw();
            observer.next(result)
        })
	})
}

function send(contractFunction,...args){
    return Rx.Observable.create((observer) => {
	    contractInstance[contractFunction](...args,(e,txid)=>{
            console.log('send',e,txid);
            e && observer.throw();
            observer.next(txid);
        })
	})
}

function getReceipt(txid){
    return Rx.Observable.create((observer) => {
	    web3.eth.getTransactionReceipt(txid,(e,result)=>{
            console.log('receipt',e,result);
            e && observer.throw();
            observer.next(result)
        })
	})
}



Rx.Observable.fromEvent($('#getBettingStasticsBtn'),'click').mergeMap(()=>{
    let ether=parseFloat(document.getElementById('ether').value);
    return call('getBettingStastics',{value:web3.toWei(ether)})
}).mergeMap((result)=>{
    $('#getBettingStasticsResult').html(JSON.stringify(result))
    let ether=parseFloat(document.getElementById('ether').value);
    return send('getBettingStastics',{value:web3.toWei(ether)})
}).subscribe({
    next:({result})=>{
        $('#getBettingStasticsTxid').html(result)
    }
});

Rx.Observable.fromEvent($('#addguessBtn'),'click').mergeMap(()=>{
    let ether=parseFloat(document.getElementById('ether').value);
    let guess=parseInt(document.getElementById('addguessValue').value);
    return call('addguess',guess,{value:web3.toWei(ether)})
}).mergeMap((result)=>{
    let ether=parseFloat(document.getElementById('ether').value);
    let guess=parseInt(document.getElementById('addguessValue').value);
    return send('addguess',guess,{value:web3.toWei(ether)})
}).subscribe({
    next:(txid)=>{
        $('#addguessTxid').html(txid)
    }
});

Rx.Observable.fromEvent($('#findWinnersBtn'),'click').mergeMap(()=>{
    let value=parseInt(document.getElementById('findWinnersValue').value);
    return call('findWinners',value)
}).mergeMap((result)=>{
    $('#findWinnersResult').html(JSON.stringify(result))
    let value=parseInt(document.getElementById('findWinnersValue').value);
    return send('findWinners',value)
}).subscribe({
    next:(txid)=>{
        $('#findWinnersTxid').html(txid)
    }
});

Rx.Observable.fromEvent($('#finishBtn'),'click').mergeMap(()=>{
    return call('finish')
}).mergeMap(()=>{
    return send('finish')
}).subscribe({
    next:(txid)=>{
        $('#finishTxid').html(txid)
    }
});

Rx.Observable.fromEvent($('#setBettingConditionBtn'),'click').mergeMap(()=>{
    let _contenders=parseInt(document.getElementById('_contenders').value);
    let _bettingprice=parseInt(document.getElementById('_bettingprice').value);
    return call('setBettingCondition',_contenders,_bettingprice)
}).mergeMap(()=>{
    let _contenders=parseInt(document.getElementById('_contenders').value);
    let _bettingprice=parseInt(document.getElementById('_bettingprice').value);
    return send('setBettingCondition',_contenders,_bettingprice)
}).subscribe({
    next:(txid)=>{
        $('#setBettingConditionTxid').html(txid)
    }
});

Rx.Observable.fromEvent($('#setStatusPriceBtn'),'click').mergeMap(()=>{
    let value=parseInt(document.getElementById('setStatusPriceValue').value);
    return call('setStatusPrice',value)
}).mergeMap(()=>{
    let value=parseInt(document.getElementById('setStatusPriceValue').value);
    return send('setStatusPrice',value)
}).subscribe({
    next:(txid)=>{
        $('#setStatusPriceTxid').html(txid)
    }
});

