abi = [{'constant': true,'inputs': [{'name': '','type': 'bytes32'}],'name': 'votesReceived','outputs': [{'name': '','type': 'uint8'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': true,'inputs': [{'name': 'candidate','type': 'bytes32'}],'name': 'validCandidate','outputs': [{'name': '','type': 'bool'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': true,'inputs': [{'name': 'candidate','type': 'bytes32'}],'name': 'totalVotesFor','outputs': [{'name': '','type': 'uint8'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': true,'inputs': [{'name': '','type': 'uint256'}],'name': 'candidateList','outputs': [{'name': '','type': 'bytes32'}],'payable': false,'stateMutability': 'view','type': 'function'},{'constant': false,'inputs': [{'name': 'candidate','type': 'bytes32'}],'name': 'voteForCandidate','outputs': [],'payable': false,'stateMutability': 'nonpayable','type': 'function'},{'inputs': [{'name': 'candidateNames',        'type': 'bytes32[]'}],'payable': false,'stateMutability': 'nonpayable','type': 'constructor'}]
VotingContract = web3.eth.contract(abi);
// In your nodejs console, execute contractInstance.address to get the address at which the contract is deployed and change the line below to use your deployed address
contractInstance = VotingContract.at('0x9a740465Ac6A2Ef11e3b10BeE5249825f5B8Dedd');
candidates = {'Alice': 'candidate-1', 'Bob': 'candidate-2', 'Candy': 'candidate-3'}

function voteForCandidate() {
  candidateName = $('#candidate').val();
  contractInstance.voteForCandidate(candidateName, {from: web3.eth.accounts[0]}, 
    function() {

    });
}
loop=()=>{
  let candidateNames = Object.keys(candidates);
  for (let name of candidateNames) {
    let val = contractInstance.totalVotesFor.call(name,(e,result)=>{
      $(`#${candidates[name]}` ).html(result.c[0].toString());
    })
  }
  setTimeout(loop,1000);

}
loop()