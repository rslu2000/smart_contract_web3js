abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "candidate",
				"type": "string"
			}
		],
		"name": "voteForCandidate",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "candidateNames",
				"type": "string[]"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "candidateList",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "candidate",
				"type": "string"
			}
		],
		"name": "totalVotesFor",
		"outputs": [
			{
				"name": "",
				"type": "uint8"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "candidate",
				"type": "string"
			}
		],
		"name": "validCandidate",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "candidate",
				"type": "string"
			}
		],
		"name": "votesReceived",
		"outputs": [
			{
				"name": "",
				"type": "uint8"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]
address ='0x100d9cc25476d92a05f009cfe6536fac794544eb';
ethereum.request({ method: 'eth_accounts' }).then(result => myMetaMaskWallet = result);

const INFURA_API_KEY = '45a27bf77c7d4f70a744a35738ec07b7';
web3_rinkeby = new Web3(`https://rinkeby.infura.io/v3/${INFURA_API_KEY}`);
mygasprice = web3_rinkeby.utils.toWei('16', 'Gwei'); //把12 Gwei轉換成 wei
// a887a3136f3ebae673c53a72824488c5d8f6da7f2a8b5b7c1019353f4a7f91ec;
web3js= new Web3(ethereum);
myContract = new web3_rinkeby.eth.Contract(abi,address);
mymetamaskContract = new web3js.eth.Contract(abi,address);

candidates = {'咖啡': 'candidate-1', '紅茶': 'candidate-2', '奶茶': 'candidate-3'}

function voteForCandidate() {
  candidateName = $('#candidate').val();
  console.log(candidateName);
  mymetamaskContract.methods.voteForCandidate(candidateName).send({from: myMetaMaskWallet[0]}).then(console.log);
  }

function sendETH() {
    receiverAddress = address;
    sendAmount = web3_rinkeby.utils.toWei('0', 'ether');
    senderPrivateKey = document.getElementById('senderPrivateKey').value;
    obj1=web3_rinkeby.eth.accounts.privateKeyToAccount(senderPrivateKey);
    senderAddress = Object.values(obj1);
	candidateName = $('#candidate').val();
	console.log('candidate: ' + candidateName);
	hexdata = web3_rinkeby.eth.abi.encodeFunctionCall(abi[0],[candidateName]);
    // hexdata = document.getElementById('send_data').value;
	console.log('hexdata: ' + hexdata);
    console.log('收款地址:' + receiverAddress);
    console.log('發送方地址:' + senderAddress[0]);
    console.log('轉帳數量:' + sendAmount + 'wei');
    web3_rinkeby.eth.accounts.signTransaction({
        to: receiverAddress,
        value: sendAmount,
        chainId: 4,
        nonce: web3_rinkeby.eth.getTransactionCount(senderAddress[0]),
        gasPrice: mygasprice,
        data:hexdata,
        gas: 80000},
        senderPrivateKey,
        (err, resolved) => {
         temp = Object.values(resolved);
         signedRawData=temp[4];
         console.log('signedRawData:' + signedRawData);
         web3_rinkeby.eth.sendSignedTransaction(signedRawData,
            (e,success)=>{
                console.log(success);
                // document.getElementById('tx_hash').value = success;
                console.log('交易成功,交易哈希值為:' + success);
            });
        }
    );

			web3_rinkeby.eth.getTransactionCount(senderAddress[0],
            (err, resolved) => {
            req_times=resolved;
            console.log("這是發送者地址所發起的第：" + (req_times+1) + "筆的交易");
            }
        );
}



loop=()=>{
    let candidateNames = Object.keys(candidates);
    for (let name of candidateNames) {
        myContract.methods.totalVotesFor(name).call().
        then(result => {totalvotes = result;
        $(`#${candidates[name]}`).html(totalvotes);
        });
      }
    setTimeout(loop,1000);
  }
loop()