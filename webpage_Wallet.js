//以下教學範例，若有疑問請參閱web3.js的官方文檔，https://web3js.readthedocs.io/

const INFURA_API_KEY = '45a27bf77c7d4f70a744a35738ec07b7';
web3 = new Web3(`https://mainnet.infura.io/v3/${INFURA_API_KEY}`);
web3_ropsten = new Web3(`https://ropsten.infura.io/v3/${INFURA_API_KEY}`);
web3_rinkeby = new Web3(`https://rinkeby.infura.io/v3/${INFURA_API_KEY}`);
const etherprovider = new ethers.providers.JsonRpcProvider(`https://ropsten.infura.io/v3/${INFURA_API_KEY}`);
mygasprice = web3.utils.toWei('13', 'Gwei'); //把12 Gwei轉換成 wei
console.log('gasprice:',mygasprice);

function queryBlocks(){
    web3.eth.getBlockNumber((err, results) => {
        let blocks_number = results;
        document.getElementById('latestBlocks_mainnet').value = blocks_number;
        console.log(blocks_number);
    } );
    web3_ropsten.eth.getBlockNumber((err, results) => {
        let blocks_number2 = results;
        document.getElementById('latestBlocks_testnet').value = blocks_number2;
        console.log(blocks_number2);
    } );
    web3_rinkeby.eth.getBlockNumber((err, results) => {
        let blocks_number3 = results;
        document.getElementById('latestBlocks_rinkeby').value = blocks_number3;
        console.log(blocks_number3);
    } );
}

function queryBalance(event) {
    address = document.getElementById('walletaddress').value
  web3.eth.getBalance(address, (err, balance) => {
    let number1 = Math.round(web3.utils.fromWei(balance, 'ether') * 100) / 100;
    console.log(number1);
    document.getElementById('walletbalance').value = number1;
  });
  web3_ropsten.eth.getBalance(address, (err, balance) => {
    let number2 = Math.round(web3_ropsten.utils.fromWei(balance, 'ether') * 100) / 100;
    console.log(number2);
    document.getElementById('walletbalance2').value = number2;
  });
  web3_rinkeby.eth.getBalance(address, (err, balance) => {
    let number3 = Math.round(web3_rinkeby.utils.fromWei(balance, 'ether') * 100) / 100;
    console.log(number3);
    document.getElementById('walletbalance3').value = number3;
  });
  web3_ropsten.eth.getTransactionCount(address,
    (err, resolved) => {
    req_times=resolved;
    console.log("Nonce值-這是發送者地址所發起的總交易筆數共：" + (req_times) + "筆");
    document.getElementById('nonce1').value = req_times;
    })
}

function sendETH(){
    receiverAddress = document.getElementById('receiverAddress').value;
    sendAmount = web3.utils.toWei(document.getElementById('sendAmount').value, 'ether');
    senderPrivateKey = document.getElementById('senderPrivateKey').value;
    obj1=web3.eth.accounts.privateKeyToAccount(senderPrivateKey);
    senderAddress = Object.values(obj1);
    hexdata = document.getElementById('send_data').value;
    console.log('收款地址:' + receiverAddress);
    console.log('發送方地址:' + senderAddress[0]);
    console.log('轉帳數量:' + sendAmount + 'wei');
    web3_ropsten.eth.accounts.signTransaction({
        to: receiverAddress,
        value: sendAmount,
        chainId: 3,
        nonce: web3_ropsten.eth.getTransactionCount(senderAddress[0]),
        gasPrice: mygasprice,
        data:hexdata,
        gas: 60000},
        senderPrivateKey,
        (err, resolved) => {
         temp = Object.values(resolved);
         signedRawData=temp[4];
         console.log('signedRawData:' + signedRawData);
         web3_ropsten.eth.sendSignedTransaction(signedRawData,
            (e,success)=>{
                console.log(success);
                document.getElementById('tx_hash').value = success;
                console.log('交易成功,交易哈希值為:' + success);
            });
        }
    );

            web3_ropsten.eth.getTransactionCount(senderAddress[0],
            (err, resolved) => {
            req_times=resolved;
            console.log("這是發送者地址所發起的第：" + (req_times+1) + "筆的交易");
            }
        );
}

//自行創建錢包地址的作法，其他做法請參閱https://web3js.readthedocs.io/en/v1.4.0/web3-eth-accounts.html#wallet-create
//若是要用助記詞來當作亂數產生錢包地址，請使用ether.js的庫中的方法來創建。
function creatAccount(){
    result = web3_ropsten.eth.accounts.create();
    console.log(result);
}

// -------以下是另一個庫 ether.js的用法
// console.log(etherprovider.getBlockNumber());
// console.log(etherbalance = etherprovider.getBalance(address));
// const signer = etherprovider.getSigner(address);
// console.log(signer);

// signer2 =new ethers.Wallet('', etherprovider)
// console.log(signer2);

// console.log(signer2.getTransactionCount());
// console.log(signer2.getBalance());

