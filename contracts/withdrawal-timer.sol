pragma solidity ^0.5.8;


contract withdrawalTimer{

    address public owner; // owner of the contract
    address public allowedAddress ; // allowed address to request found in case of.
    uint32 public timer;

    event NewTransactionRequest(uint32 time, uint32 amount, address sender, uint32 id);

    struct Transaction{
        uint32 time;
        uint32 amount;
        address sender;
        bool allowed;
    }

    Transaction[] public transactions;


    constructor(address _address) public payable {
        owner = msg.sender;
        allowedAddress = _address;
        timer = 3 minutes; // default value is short to test the contract, could be 30 days in real case scenario.
    }

    function requestWithdraw(uint32 _amountInWei) external payable {
        require(msg.sender == allowedAddress || msg.sender == owner, "You are not allowed to request a withdraw");
        require(msg.value >= 0.1 ether, "You should send 0.1ETH to request a withdraw");
        uint32 _time = now + timer;
        uint32 transactionId = transactions.push(Transaction(_time,_amountInWei, msg.sender,true)) - 1;
        emit NewTransactionRequest(_time,_amountInWei,msg.sender,transactionId);
    }

    function withdraw(uint32 _id) external {
        require(msg.sender == allowedAddress || msg.sender == owner, "You are not allowed to withdraw");
        require(_id < transactions.length, "The transaction id should exist");
        Transaction memory _t = transactions[_id];
        require(_t.allowed == true, "This withdraw was cancelled, sorry!");
        require(msg.sender == _t.sender, "You are not the sender");
        require(now >= _t.time, "You can't withdraw now, be patient...");
        msg.sender.transfer(_t.amount);
    }

    function changeTimer(uint32 _newTimer) external {
      require(msg.sender == owner, "Only owner can change the timer");
      timer = _newTimer * days;
    }

    function changeAllowedAdress(address _newAllowedAdress) external {
      require(msg.sender == owner, "Only owner can change the allowedAddress");
      allowedAddress = _newAllowedAdress;
    }

    function cancelWithdraw(uint32 _id) external {
        require(msg.sender == owner, "Only owner can cancel a request");
        Transaction storage _t = transactions[_id];
        _t.allowed = false;
    }
}