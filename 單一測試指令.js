// web3js 0.20.7版 單一投票指令
contractInstance.voteForCandidate("Alice", {from: web3.eth.accounts[0]},
    function() {}
    );
// 單一查詢票數指令
    contractInstance.totalVotesFor.call("Alice",(e,result)=>{console.log(result)});



// 使用web3js 1.3.4版 成功的api呼叫
contract_instance.methods.candidateList(0).call().then(console.log);
回傳值0x416c696365000000000000000000000000000000000000000000000000000000
contract_instance.methods.votesReceived("0x416c696365000000000000000000000000000000000000000000000000000000").call().then(console.log);
contract_instance.methods.totalVotesFor("0x416c696365000000000000000000000000000000000000000000000000000000").call().then(console.log);
contract_instance.methods.totalVotesFor("0x416c696365").call((e,result)=>{console.log(result)});

// 以下失敗 是因為調用send()之後，不會調用metamask而是呼叫web3js本身的方法：：eth_sendTransaction
contract_instance.methods.voteForCandidate("0x416c696365000000000000000000000000000000000000000000000000000000").send({from: myaccount}).then(console.log);
// ------------------------------------------
// 使用windows.ethereum 成功的api呼叫
// 獲取metamask第一個帳號
const accounts = await ethereum.request({ method: 'eth_accounts' });

const myAccount = ethereum.request({ method: 'eth_requestAccounts' });

//
const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
const account = accounts[0];
abi = [{'constant': true,'inputs': [{'name': '','type': 'bytes32'}],'name': 'votesReceived','outputs': [{'name': '','type': 'uint8'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': true,'inputs': [{'name': 'candidate','type': 'bytes32'}],'name': 'validCandidate','outputs': [{'name': '','type': 'bool'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': true,'inputs': [{'name': 'candidate','type': 'bytes32'}],'name': 'totalVotesFor','outputs': [{'name': '','type': 'uint8'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': true,'inputs': [{'name': '','type': 'uint256'}],'name': 'candidateList','outputs': [{'name': '','type': 'bytes32'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': false,'inputs': [{'name': 'candidate','type': 'bytes32'}],'name': 'voteForCandidate','outputs': [],'payable': false,'stateMutability': 'nonpayable','type': 'function'},{'inputs': [{'name': 'candidateNames',        'type': 'bytes32[]'}],'payable': false,'stateMutability': 'nonpayable','type': 'constructor'}]
const address = '0x9a740465Ac6A2Ef11e3b10BeE5249825f5B8Dedd'

web3js= new Web3(ethereum);

myContract = new web3js.eth.Contract(abi,address);
myContract.methods.candidateList(0).call().then(console.log);
myContract.methods.totalVotesFor("0x416c696365000000000000000000000000000000000000000000000000000000").call().then(console.log);
myContract.methods.totalVotesFor("0x416c696365").call().then(console.log);

myContract.methods.votesReceived("0x416c696365000000000000000000000000000000000000000000000000000000").call().then(console.log);
myContract.methods.votesReceived("0x416c696365").call().then(console.log);

// 以下指令呼叫metamask成功 並成功發送交易 投出給Alice一票
myContract.methods.voteForCandidate("0x416c696365000000000000000000000000000000000000000000000000000000").send({from: myaccount}).then(console.log);
myContract.methods.voteForCandidate("0x416c696365").send({from: account}).then(console.log);





// 失敗的api呼叫
contract_instance.methods.voteForCandidate.call("Alice", {from: myaccounts},
function() {}
);

