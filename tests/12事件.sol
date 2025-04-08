// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract  Event {

    //定义一个mapping映射变量，记录每个地址的持币数量
    mapping (address => uint256) private _balances;
    //事件的声明由event关键字开头，接着是事件名称，括号里面写好事件需要记录的变量类型和变量名。
    event Transfer(address indexed from, address indexed to, uint256 value);

    // 定义_transfer函数，执行转账逻辑
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) external {

        _balances[from] = 10000000; // 给转账地址一些初始代币

        _balances[from] -=  amount; // from地址减去转账数量
        _balances[to] += amount; // to地址加上转账数量

        // 释放事件
        emit Transfer(from, to, amount);
    }


}