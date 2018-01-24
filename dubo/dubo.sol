pragma solidity ^0.4.19;
contract Dubo {
    struct Player{
        address addr;
        uint bettingMoney;
        uint contribution;
        uint balance;
    }
    mapping (address=>Player) public players;
    address public developer;
    address public maker;
    uint public contractBalance;
    event playerWin(address player,uint winMoney); // 事件 當玩家玩贏莊家並申請提款時, (玩家,贏走莊家多少)
    
    function Dubo() public {
        developer = msg.sender;
    }

    function setMaker(address _maker) public {
        require(msg.sender == developer);
        maker = _maker;
    }

    function money_received() public payable {
        players[msg.sender].addr = msg.sender;
        contractBalance = contractBalance + msg.value;
        players[msg.sender].bettingMoney = players[msg.sender].bettingMoney + msg.value;
        players[msg.sender].balance = players[msg.sender].balance + msg.value;
    }

    function settlement(address player_wallet_addr, uint final_balance) public {
        require(maker==msg.sender); // 檢查是不是莊家
        players[player_wallet_addr].balance = final_balance;
    }

    function finish(address applicant) public {
        require(maker==msg.sender); // 檢查是不是莊家
        if(players[applicant].bettingMoney > players[applicant].balance) {
            uint forMakerMoney = players[applicant].bettingMoney-players[applicant].balance;
            players[applicant].contribution = players[applicant].contribution + forMakerMoney;
            maker.transfer(forMakerMoney);
            contractBalance = contractBalance - forMakerMoney;
        }else{ //玩家餘額比投注金大 （贏比較多）
            uint money = players[applicant].balance -players[applicant].bettingMoney;
            playerWin(applicant,money);
        }
        players[applicant].addr.transfer(players[applicant].balance);
        contractBalance = contractBalance - players[applicant].balance;
        players[applicant].bettingMoney=0;
        players[applicant].balance=0;
    }

    function addBalance()public payable {
        require(maker==msg.sender); // 檢查是不是莊家
        contractBalance = contractBalance + msg.value;
    }
}
