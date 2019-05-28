pragma solidity ^0.5.8;


contract withdrawalTimer{

    address public owner; // owner of the contract
    address public allowedAddress ; // trusted address to request found in case of.
    uint public timer;

    event NewTransactionRequest(uint time, uint amount, address sender, uint id);

    struct Transaction{
        uint time;
        uint amount;
        address sender;
        bool allowed;
    }

    Transaction[] public transactions;


    constructor() public payable {
        owner = msg.sender;
        allowedAddress = 0x375319E687Ca18615Cc2eFBc58eDC7F4C79FBF98;
        timer = 3 minutes; // default value is short to test the contract, could be 30 days in real case scenario.
    }

    function requestWithdraw(uint _amountInETH) public payable {
        require(msg.sender == allowedAddress || msg.sender == owner, "You are not allowed to request a withdraw");
        require(msg.value >= 0.1 ether, "You should send 0.1ETH to request a withdraw");
        uint _time = now + timer;
        uint _amountInWei = _amountInETH * 1000000000000000000; // _amount is given in ETH and converted in Wei
        uint transactionId = transactions.push(Transaction(_time,_amountInWei, msg.sender,true)) - 1;
        emit NewTransactionRequest(_time,_amountInWei,msg.sender,transactionId);
    }

    function withdraw(uint _id) public {
        require(msg.sender == allowedAddress || msg.sender == owner, "You are not allowed to withdraw");
        require(_id < transactions.length, "The transaction id should exist");
        Transaction memory _t = transactions[_id];
        require(_t.allowed == true, "This withdraw was cancelled, sorry!");
        require(msg.sender == _t.sender, "You are not the sender");
        require(now >= _t.time, "You can't withdraw now, be patient...");
        msg.sender.transfer(_t.amount);
    }

    function changeTimer(uint _newTimer) public {
      require(msg.sender == owner, "Only owner can change the timer");
      timer = _newTimer * days;
    }

    function changeAllowedAdress(address _newAllowedAdress) public {
      require(msg.sender == owner, "Only owner can change the allowedAddress");
      allowedAddress = _newAllowedAdress;
    }

    function cancelWithdraw(uint _id) public {
        require(msg.sender == owner, "Only owner can cancel a request");
        Transaction storage _t = transactions[_id];
        _t.allowed = false;
    }
}