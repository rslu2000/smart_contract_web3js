pragma solidity ^0.4.19;
contract Dubo {
    struct Player{
        uint id;
        address addr;
        uint bettingMoney;
        uint contribution;
        uint balance;
        uint totalBettingMoney;
        uint totalContribution;
        int winOrLose;
    }
    mapping (address=>Player) public players;
    address[] public playersAddressList;
    uint public playersCount;
    address public developer;
    address public maker;
    uint public totalMakerReceived;
    uint public contractBalance;
    event playerWin(address player,uint winMoney); // 事件 當玩家玩贏莊家並申請提款時, (玩家,贏走莊家多少)
    event moneyReceivedEvent(address player,uint money); // 入金事件
    event moneySendedEvent(address player,uint winMoney); // 出金
    event makerReceivedEvent(uint money); // 莊家收到
    event insufficientBalance(uint money); // 餘額不足事件
    function Dubo() public {
        developer = msg.sender;
    }

    function setMaker(address _maker) public {
        require(msg.sender == developer);
        maker = _maker;
    }

    function moneyReceived() public payable {
        if (players[msg.sender].addr == 0x0) {
            playersCount = playersAddressList.push(msg.sender);
            players[msg.sender].id = playersCount - 1;
            players[msg.sender].addr = msg.sender;
        }
        contractBalance = contractBalance + msg.value;
        players[msg.sender].bettingMoney = players[msg.sender].bettingMoney + msg.value;
        players[msg.sender].balance = players[msg.sender].balance + msg.value;
        players[msg.sender].totalBettingMoney = players[msg.sender].totalBettingMoney + msg.value;
        moneyReceivedEvent(msg.sender,msg.value);
    }

    function settlement(address player_wallet_addr, uint final_balance) public {
        require(maker==msg.sender); // 檢查是不是莊家
        players[player_wallet_addr].balance = final_balance;
    }

    function finish(address applicant) public returns(bool) {
        require(maker==msg.sender); // 檢查是不是莊家
        if (contractBalance < players[applicant].bettingMoney || contractBalance < players[applicant].balance) { // 合約餘額不足
            insufficientBalance(players[applicant].bettingMoney > players[applicant].balance ? players[applicant].bettingMoney : players[applicant].balance);
            return false;
        }

        if (players[applicant].bettingMoney > players[applicant].balance) {
            uint forMakerMoney = players[applicant].bettingMoney-players[applicant].balance;
            players[applicant].contribution = players[applicant].contribution + forMakerMoney;
            players[applicant].totalContribution = players[applicant].totalContribution + forMakerMoney;
            maker.transfer(forMakerMoney);
            totalMakerReceived = totalMakerReceived + forMakerMoney;
            makerReceivedEvent(forMakerMoney);
            contractBalance = contractBalance - forMakerMoney;
            players[applicant].winOrLose = players[applicant].winOrLose - int256(forMakerMoney);
        }

        if (players[applicant].bettingMoney < players[applicant].balance) {
            //玩家餘額比投注金大 （贏比較多）
            uint money = players[applicant].balance - players[applicant].bettingMoney;
            playerWin(applicant,money);
            players[applicant].winOrLose = players[applicant].winOrLose + int256(money);
        }

        players[applicant].addr.transfer(players[applicant].balance);
        contractBalance = contractBalance - players[applicant].balance;
        players[applicant].bettingMoney = 0;
        players[applicant].balance = 0;
        moneySendedEvent(applicant,players[applicant].balance);
        return true;
    }

    function addBalance()public payable {
        require(maker==msg.sender); // 檢查是不是莊家
        contractBalance = contractBalance + msg.value;
    }
}
