let Web3 = require('./web3.js/index')
let web3 = new Web3();

function getTopics(abi) {
  if (abi || abi.type === 'event') {
    let topicsString = abi.name + '(';
    for (let input of abi.inputs) {
      topicsString += input.type + ',';
    }
    topicsString = topicsString.substr(0, topicsString.length - 1) + ')';
    let result = web3.sha3(topicsString);
    return result;
  } else {
    console.error('Not abi event item!');
    return null;
  }
}