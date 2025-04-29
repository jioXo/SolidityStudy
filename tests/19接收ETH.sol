// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
接收ETH，receive和fallback都能够用于接收ETH，他们触发的规则如下
触发fallback() 还是 receive()?
           接收ETH
              |
         msg.data是空？
            /  \
          是    否
          /      \
receive()存在?   fallback()
        / \
       是  否
      /     \
receive()   fallback()

*/
contract ReceiveETH {
    // 定义事件
    event Received(address Sender, uint256 Value);

/**
receive()函数是在合约收到ETH转账时被调用的函数。一个合约最多有一个receive()函数，
声明方式与一般函数不一样，不需要function关键字：receive() external payable { ... }。receive()函数不能有任何的参数，
不能返回任何值，必须包含external和payable。

当合约接收ETH的时候，receive()会被触发。receive()最好不要执行太多的逻辑因为如果别人用send和transfer方法发送ETH的话，gas会限制在2300，
receive()太复杂可能会触发Out of Gas报错；如果用call就可以自定义gas执行更复杂的逻辑（这三种发送ETH的方法我们之后会讲到）。
*/
    // 接收ETH时释放Received事件
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    event fallbackCalled(address Sender, uint256 Value, bytes Data);

/**
fallback()函数会在调用合约不存在的函数时被触发。可用于接收ETH，也可以用于代理合约proxy contract。
fallback()声明时不需要function关键字，必须由external修饰，一般也会用payable修饰，用于接收ETH:fallback() external payable { ... }。
*/
    // fallback
    fallback() external payable {
        emit fallbackCalled(msg.sender, msg.value, msg.data);
    }
}
