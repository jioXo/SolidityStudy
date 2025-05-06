// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


/**
总结
这一讲我们介绍了Solidity中的另一个低级函数delegatecall。与call类似，它可以用来调用其他合约；
不同点在于运行的上下文，B call C，上下文为C；而B delegatecall C，上下文为B。目前delegatecall最大的应用是代理合约和EIP-2535 Diamonds（钻石）。
*/
// 被调用的合约C
contract C {
    uint256 public num;
    address public sender;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
    }
}

//发起调用的合约B
contract B {
    uint256 public num;
    address public sender;

    // 通过call来调用C的setVars()函数，将改变合约C里的状态变量
    function callSetVars(address _addr, uint256 _num) external payable {
        // call setVars()
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

    // 通过delegatecall来调用C的setVars()函数，将改变合约B里的状态变量
    function delegatecallSetVars(address _addr, uint256 _num) external payable {
        // delegatecall setVars()
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}
