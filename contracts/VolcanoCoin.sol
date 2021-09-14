//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VolcanoCoin is ERC20("Volcano","VCN"), Ownable{
    
    event TotalSupply(uint _totalSupply);
    
    event Transfer(uint _amount, address _recipientAddress);
    
    enum PaymentType {UNKNOWN,BASICPAYMENT,REFUND,DIVIDEND,GROUPPAYMENT}
    
    mapping(address => uint) balances;
    
    address administrator;
    
    struct Payment{
        uint paymentId;
        PaymentType paymentType;
        string comment;
        uint amount;
        address recipentAddress;
        uint256 timestamp;
    }
    
    mapping(address => Payment[]) payments;

    
    constructor(){
        administrator = msg.sender;
       _mint(owner(),10000);
       balances[owner()] = totalSupply();
    }
    
    //6 answer ,the ivestor would think about the inflation issues that there is no limit in number of tokens 
    
    function increaseSupply(uint256 tokens) public onlyOwner {
        _mint(owner(),tokens);
        emit TotalSupply(totalSupply());
    }
    
    function transfer(address _recipientAddress, uint _amount) override public returns (bool) {
        require(balanceOf(msg.sender) > _amount, "Transfer amount exceeds balance");
        _transfer(msg.sender,_recipientAddress,_amount);
        Payment memory newPayment;
        newPayment.paymentId = payments[msg.sender].length;
        newPayment.amount = _amount;
        newPayment.recipentAddress = _recipientAddress; 
        newPayment.paymentType = PaymentType.UNKNOWN;
        newPayment.comment = '';
        newPayment.timestamp = block.timestamp;
        payments[msg.sender].push(newPayment);
        emit Transfer(_amount,msg.sender);
        return true;
    }
    
    function updatePayment(uint _paymentId, PaymentType _paymentType, string memory _comment) public returns (bool) {
        require(_paymentId > 0,"PaymentId must be > 0");
        
        Payment storage payment = payments[msg.sender][_paymentId];
        payment.paymentType = _paymentType;
         payment.comment = _comment;
        
      return true;
    }
    
    
    function updateByAdmin(uint _paymentId, PaymentType _paymentType, address updateAddress) public returns (bool){
        require(msg.sender == administrator, "Only administrator is allowed");
        
        Payment storage payment = payments[updateAddress][_paymentId];
        payment.paymentType = _paymentType;
        payment.comment = string(
            abi.encodePacked(
                payment.comment,
                " updated by ",
                abi.encodePacked(msg.sender)
            )
        );
        
        return true;
        
    }
    
    
   function getPayment() public view returns (Payment[] memory) {
        return payments[msg.sender];
    }
}