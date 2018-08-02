pragma solidity ^0.4.14;
import "./TikkunToken.sol";

// Daily withdrawal limit
contract WithDrawal is TikkunToken {
    
    uint private dailyWithdraw = 5000;
    uint private spentToday;
    uint private presentDay = today();
    // This function determines today's index/ midnight.
    function today() private constant returns (uint) { return now - (now % 1 days); } 
    // This function is used to withdraw 
    function withDrawals ( address _to, uint _tokens) public {
        require(isUnderLimit(_tokens), "You have reached your daily withdrawal limit");
        balances[msg.sender] -= _tokens;
        balances[_to] += _tokens;
        spentToday += _tokens;
        //emit Transfer(msg.sender, _to, _tokens);
    }
    // This function check if there is still enough tokens to withdraw within in that day
    // it also reset the amount tokens already withdrawn/spent if its a different day
    function isUnderLimit( uint _tokens) internal returns (bool) {
        if (today() > presentDay) {
            presentDay = today();
            spentToday = 0;
        }
        if (spentToday + _tokens <= dailyWithdraw && 
            spentToday + _tokens > spentToday)
            return true;
        return false;
    }
}
