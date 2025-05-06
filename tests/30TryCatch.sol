// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
在Solidity中，try-catch只能被用于external函数或public函数或创建合约时constructor（被视为external函数）的调用。基本语法如下：

try externalContract.f() {
    // call成功的情况下 运行一些代码
} catch {
    // call失败的情况下 运行一些代码
}
复制代码
其中externalContract.f()是某个外部合约的函数调用，try模块在调用成功的情况下运行，而catch模块则在调用失败时运行。

同样可以使用this.f()来替代externalContract.f()，this.f()也被视作为外部调用，但不可在构造函数中使用，因为此时合约还未创建。

如果调用的函数有返回值，那么必须在try之后声明returns(returnType val)，并且在try模块中可以使用返回的变量；如果是创建合约，那么返回值是新创建的合约变量。

try externalContract.f() returns(returnType val){
    // call成功的情况下 运行一些代码
} catch {
    // call失败的情况下 运行一些代码
}
另外，catch模块支持捕获特殊的异常原因：
try externalContract.f() returns(returnType){
    // call成功的情况下 运行一些代码
} catch Error(string memory ) {
    // 捕获revert("reasonString") 和 require(false, "reasonString")
} catch Panic(uint ) {
    // 捕获Panic导致的错误 例如assert失败 溢出 除零 数组访问越界
} catch (bytes memory ) {
    // 如果发生了revert且上面2个异常类型匹配都失败了 会进入该分支
    // 例如revert() require(false) revert自定义类型的error
}
*/

/**
OnlyEven合约包含一个构造函数和一个onlyEven函数。

构造函数有一个参数a，当a=0时，require会抛出异常；当a=1时，assert会抛出异常；其他情况均正常。
onlyEven函数有一个参数b，当b为奇数时，require会抛出异常。
*/
contract OnlyEven {
    constructor(uint256 a) {
        require(a != 0, "invalid number");
        assert(a != 1);
    }

    function onlyEven(uint256 b) external pure returns (bool success) {
        // 输入奇数时revert
        require(b % 2 == 0, "Ups! Reverting");
        success = true;
    }
}

/**
SuccessEvent是调用成功会释放的事件，而CatchEvent和CatchByte是抛出异常时会释放的事件，
分别对应require/revert和assert异常的情况。even是个OnlyEven合约类型的状态变量。
*/
contract TryCatch {
    // 成功event
    event SuccessEvent();

    // 失败event
    event CatchEvent(string message);
    event CatchByte(bytes data);

    // 声明OnlyEven合约变量
    OnlyEven even;

    constructor() {
        even = new OnlyEven(2);
    }

    // 在external call中使用try-catch
    function execute(uint256 amount) external returns (bool success) {
        try even.onlyEven(amount) returns (bool _success) {
            // call成功的情况下
            emit SuccessEvent();
            return _success;
        } catch Error(string memory reason) {
            // call不成功的情况下
            emit CatchEvent(reason);
        }
    }

    // 在创建新合约中使用try-catch （合约创建被视为external call）
    // executeNew(0)会失败并释放`CatchEvent`
    // executeNew(1)会失败并释放`CatchByte`
    // executeNew(2)会成功并释放`SuccessEvent`
    function executeNew(uint256 a) external returns (bool success) {
        try new OnlyEven(a) returns (OnlyEven _even) {
            // call成功的情况下
            emit SuccessEvent();
            success = _even.onlyEven(a);
        } catch Error(string memory reason) {
            // catch失败的 revert() 和 require()
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            // catch失败的 assert()
            emit CatchByte(reason);
        }
    }
}
