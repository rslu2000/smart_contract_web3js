
abi = [{'constant': true,'inputs': [{'name': '','type': 'bytes32'}],'name': 'votesReceived','outputs': [{'name': '','type': 'uint8'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': true,'inputs': [{'name': 'candidate','type': 'bytes32'}],'name': 'validCandidate','outputs': [{'name': '','type': 'bool'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': true,'inputs': [{'name': 'candidate','type': 'bytes32'}],'name': 'totalVotesFor','outputs': [{'name': '','type': 'uint8'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': true,'inputs': [{'name': '','type': 'uint256'}],'name': 'candidateList','outputs': [{'name': '','type': 'bytes32'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': false,'inputs': [{'name': 'candidate','type': 'bytes32'}],'name': 'voteForCandidate','outputs': [],'payable': false,'stateMutability': 'nonpayable','type': 'function'},{'inputs': [{'name': 'candidateNames',        'type': 'bytes32[]'}],'payable': false,'stateMutability': 'nonpayable','type': 'constructor'}]
// const accounts = ethereum.request({ method: 'eth_accounts' });
// const account = accounts.then(console.log);
// async function getAccount() {
  // const accounts = ethereum.request({ method: 'eth_requestAccounts' });
  // const account = accounts[0];
  // showAccount.innerHTML = account;
// }
address ='0x9a740465Ac6A2Ef11e3b10BeE5249825f5B8Dedd';
mywallet = '0xa878C38b27D0C7b3b30Fbf5DBE417f56357D06Fb';
// web3js.eth.defaultAccount = web3js.eth.accounts[0];
// console.log(web3js.eth.defaultAccount)
ethereum.request({ method: 'eth_accounts' }).then(result => myMetaMaskWallet = result);

web3js= new Web3(ethereum);
myContract = new web3js.eth.Contract(abi,address);

candidates = {'Alice': 'candidate-1', 'Bob': 'candidate-2', 'Candy': 'candidate-3'}

function voteForCandidate() {
  candidateName = $('#candidate').val();
  console.log(candidateName);
  switch (candidateName) {
    case "Alice":
      myContract.methods.voteForCandidate("0x416c696365").send({from: myMetaMaskWallet[0]}).then(console.log);
      break;
    case "Bob":
      myContract.methods.voteForCandidate("0x426f62").send({from: myMetaMaskWallet[0]}).then(console.log);
      break;
    case "Candy":
      myContract.methods.voteForCandidate("0x43616e6479").send({from: myMetaMaskWallet[0]}).then(console.log);
      break;
    default:
      break;
  }
  // myContract.methods.voteForCandidate("0x416c696365").send({from: myMetaMaskWallet[0]}).then(console.log);
}
var Alicevotes = 0;
var Bobvotes = 0;
var Candyvotes = 0;
loop=()=>{
  // let candidateNames = Object.keys(candidates);
    myContract.methods.totalVotesFor("0x416c696365").call().then(result => Alicevotes = result);
    myContract.methods.totalVotesFor("0x426f62").call().then(result => Bobvotes = result);
    myContract.methods.totalVotesFor("0x43616e6479").call().then(result => Candyvotes = result);
    $(`#${candidates["Alice"]}`).html(Alicevotes);
    $(`#${candidates["Bob"]}`).html(Bobvotes);
    $(`#${candidates["Candy"]}`).html(Candyvotes);
  setTimeout(loop,1000);
  }
loop()