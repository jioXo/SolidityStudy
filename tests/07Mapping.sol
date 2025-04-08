// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Mapping  {
    mapping(uint => address) public idToAddress; // id映射到地址
    mapping(address => address) public swapPair; // 币对的映射，地址到地址

        // 我们定义一个结构体 Struct
        //映射的_KeyType只能选择Solidity内置的值类型，比如uint，address等，不能用自定义的结构体。而_ValueType可以使用自定义的类型。下面这个例子会报错，因为_KeyType使用了我们自定义的结构体：
        // struct Student{
        //     uint256 id;
        //     uint256 score; 
        // }
        // mapping(Student => uint) public testVar;

        function writeMap (uint _Key, address _Value) public{
        idToAddress[_Key] = _Value;
}
}