// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
import "./31ERC20.sol";

/**
状态变量
我们在水龙头合约中定义3个状态变量

amountAllowed设定每次能领取代币数量（默认为100，不是一百枚，因为代币有小数位数）。
tokenContract记录发放的ERC20代币合约地址。
requestedAddress记录领取过代币的地址。

事件
水龙头合约中定义了1个SendToken事件，记录了每次领取代币的地址和数量，在requestTokens()函数被调用时释放。
*/
contract Faucet {
    uint256 public amountAllowed = 100; // 每次领 100 单位代币
    address public tokenContract; // token合约地址
    mapping(address => bool) public requestedAddress; // 记录领取过代币的地址

    // SendToken事件
    event SendToken(address indexed Receiver, uint256 indexed Amount);

    // 部署时设定ERC20代币合约
    constructor(address _tokenContract) {
        tokenContract = _tokenContract; // set token contract
    }

    // 用户领取代币函数
    function requestTokens() external {
        require(!requestedAddress[msg.sender], "Can't Request Multiple Times!"); // 每个地址只能领一次
        IERC20 token = IERC20(tokenContract); // 创建IERC20合约对象
        require(
            token.balanceOf(address(this)) >= amountAllowed,
            "Faucet Empty!"
        ); // 水龙头空了

        token.transfer(msg.sender, amountAllowed); // 发送token
        requestedAddress[msg.sender] = true; // 记录领取地址

        emit SendToken(msg.sender, amountAllowed); // 释放SendToken事件
    }
}
