// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
名字相同但输入参数类型不同的函数可以同时存在，他们被视为不同的函数。
*/
contract OverLoading {
    function saySomething() public pure returns (string memory) {
        return ("Nothing");
    }

    function saySomething(string memory something)
        public
        pure
        returns (string memory)
    {
        return (something);
    }
}
