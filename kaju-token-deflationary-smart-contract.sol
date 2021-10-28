pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/f1e92dd184a599f39ce9cc4ec8a5e4a94416f3a2/contracts/utils/math/SafeMath.sol";

contract KAJU is ERC20 {
    using SafeMath for uint256;
    address public owner;
    uint TAX_FEE = 5;
    uint BURN_FEE = 5;
    
    mapping(address => bool) public excludedFromTax;
    
    constructor() public ERC20("KAJU", "KJU") {
        _mint(msg.sender, 1000 * 10**18);
        owner = msg.sender;
        excludedFromTax[owner] = true;
    }
    
    function transfer (address recipient, uint256 amount) public override returns (bool) {
        if (excludedFromTax[msg.sender] ==  true) {
            _transfer(_msgSender(), recipient, amount);
        } else {
            uint burnAmount = amount.mul(BURN_FEE) / 100;
            uint adminAmount = amount.mul(TAX_FEE) / 100;
            _burn(_msgSender(), burnAmount);
            _transfer(_msgSender(), owner, adminAmount);
            _transfer(_msgSender(), recipient, amount.sub(burnAmount).sub(adminAmount));
        }
        return true;
    }
        
}
