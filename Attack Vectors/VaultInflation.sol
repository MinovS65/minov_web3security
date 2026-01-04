// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/src/Test.sol";
import {Token} from "else/TokenERC20.sol";
import {IERC20} from "interfaces/IERC20.sol";

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

contract AttackPOC is Test {
    Vault vault;
    Token token; 

    address[] private users = [address(11), address(12)];

    function setUp () public {
        token = new Token();
        vault = new Vault();
    }

    function test() public {

    }

    function print() private {

    }
}