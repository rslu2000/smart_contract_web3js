pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

contract Voting {
  mapping (bytes32 => uint8) private _votesReceived;

  
  string[] public candidateList;


  // 构造函数 初始化候选人名单
  constructor(string[] candidateNames) public {
    candidateList = candidateNames;
  }
  function votesReceived(string candidate) view returns(uint8){
      return _votesReceived[keccak256(candidate)];
  }

  // 查询某个候选人的总票数
  function totalVotesFor(string candidate)  constant public returns (uint8) {
    require(validCandidate(candidate) == true);
    // 或者
    // assert(validCandidate(candidate) == true);
    return _votesReceived[keccak256(candidate)];
  }

  // 为某个候选人投票
  function voteForCandidate(string candidate) public {
    assert(validCandidate(candidate) == true);
    _votesReceived[keccak256(candidate)] += 1;
  }

  // 检索投票的姓名是不是候选人的名字
  function validCandidate(string candidate) constant public returns (bool) {
    for(uint i = 0; i < candidateList.length; i++) {
      if (keccak256(candidateList[i]) == keccak256(candidate)) {
        return true;
      }
    }
    return false;
  }
}