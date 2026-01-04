// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns(uint);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns(uint);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
contract Vault {
    IERC20 token;
    uint256 totalSupply;
    mapping(address => uint) balanceOf;

    constructor (address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    function deposit(uint256 amount) external {
        uint256 shares;

        if (totalSupply == 0) {
            totalSupply = shares;
        }
        else {
            shares = (totalSupply * amount) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 _shares) external returns(uint256) {
        uint amount = (_shares * token.balanceOf(address(this))) / totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
        return amount;
    }
}

