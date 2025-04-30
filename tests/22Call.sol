// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
call 是address类型的低级成员函数，它用来与其他合约交互。它的返回值为(bool, bytes memory)，分别对应call是否成功以及目标函数的返回值。
call是Solidity官方推荐的通过触发fallback或receive函数发送ETH的方法。
不推荐用call来调用另一个合约，因为当你调用不安全合约的函数时，你就把主动权交给了它。推荐的方法仍是声明合约变量后调用函数
当我们不知道对方合约的源代码或ABI，就没法生成合约变量；这时，我们仍可以通过call调用对方合约的函数。

call的使用规则如下：
目标合约地址.call(字节码);
其中字节码利用结构化编码函数abi.encodeWithSignature获得：
abi.encodeWithSignature("函数签名", 逗号分隔的具体参数)
函数签名为"函数名（逗号分隔的参数类型）"。例如abi.encodeWithSignature("f(uint256,address)", _x, _addr)。
另外call在调用合约时可以指定交易发送的ETH数额和gas数额：
目标合约地址.call{value:发送数额, gas:gas数额}(字节码);
*/
contract Call {
    // 定义Response事件，输出call返回的success和data，方便我们观察返回值。
    event Response(bool success, bytes data);

    //定义callSetX函数来调用目标合约的setX()，转入msg.value数额的ETH，并释放Response事件输出success和data：
    function callSetX(address payable _addr, uint256 x) public payable {
        // call setX()，同时可以发送ETH
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", x)
        );

        emit Response(success, data); //释放事件
    }

    /**
我们调用getX()函数，它将返回目标合约_x的值，类型为uint256。我们可以利用abi.decode来解码call的返回值data，并读出数值
*/
    function callGetX(address _addr) external returns (uint256) {
        // call getX()
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("getX()")
        );

        emit Response(success, data); //释放事件
        return abi.decode(data, (uint256));
    }

    /**
如果我们给call输入的函数不存在于目标合约，那么目标合约的fallback函数会被触发。
*/
    function callNonExist(address _addr) external {
        // call 不存在的函数
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(success, data); //释放事件
    }
}

/**
我们先写一个简单的目标合约OtherContract并部署，代码与第21讲中基本相同，只是多了fallback函数。
这个合约包含一个状态变量x，一个在收到ETH时触发的事件Log，三个函数：

getBalance(): 返回合约ETH余额。
setX(): external payable函数，可以设置x的值，并向合约发送ETH。
getX(): 读取x的值。
*/
contract OtherContract {
    uint256 private _x = 0; // 状态变量x
    // 收到eth的事件，记录amount和gas
    event Log(uint256 amount, uint256 gas);

    fallback() external payable {}

    // 返回合约ETH余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 可以调整状态变量_x的函数，并且可以往合约转ETH (payable)
    function setX(uint256 x) external payable {
        _x = x;
        // 如果转入ETH，则释放Log事件
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    // 读取x
    function getX() external view returns (uint256 x) {
        x = _x;
    }
}
