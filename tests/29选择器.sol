// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
当参数为0x2c44b726ADF1963cA47Af88B284C06f30380fC78时，输出的calldata为

0x6a6278420000000000000000000000002c44b726adf1963ca47af88b284c06f30380fc78
这段很乱的字节码可以分成两部分：

前4个字节为函数选择器selector：
0x6a627842

后面32个字节为输入的参数：
0x0000000000000000000000002c44b726adf1963ca47af88b284c06f30380fc78
其实calldata就是告诉智能合约，我要调用哪个函数，以及参数是什么。
*/
contract Selector11 {
    // event 返回msg.data
    event Log(bytes data);
    event SelectorEvent(bytes4 data);

    function mint(address to) external {
        emit Log(msg.data);
    }

    function mintSelector() external pure returns (bytes4 mSelector) {
        return bytes4(keccak256("mint(address)"));
    }

    /**
基础类型参数
solidity中，基础类型的参数有：uint256(uint8, ... , uint256)、bool, address等。在计算method id时，只需要计算bytes4(keccak256("函数名(参数类型1,参数类型2,...)"))。例如，如下函数，函数名为elementaryParamSelector，参数类型分别为uint256和bool。所以，只需要计算bytes4(keccak256("elementaryParamSelector(uint256,bool)"))便可得到此函数的method id。
    */
    // elementary（基础）类型参数selector
    // 输入：param1: 1，param2: 0
    // elementaryParamSelector(uint256,bool) : 0x3ec37834
    function elementaryParamSelector(uint256 param1, bool param2)
        external
        returns (bytes4 selectorWithElementaryParam)
    {
        emit SelectorEvent(this.elementaryParamSelector.selector);
        return bytes4(keccak256("elementaryParamSelector(uint256,bool)"));
    }

    /**
固定长度类型参数
固定长度的参数类型通常为固定长度的数组，例如：uint256[5]等。例如，如下函数fixedSizeParamSelector的参数为uint256[3]。因此，在计算该函数的method id时，只需要通过bytes4(keccak256("fixedSizeParamSelector(uint256[3])"))即可。
    */
    // fixed size（固定长度）类型参数selector
    // 输入： param1: [1,2,3]
    // fixedSizeParamSelector(uint256[3]) : 0xead6b8bd
    function fixedSizeParamSelector(uint256[3] memory param1)
        external
        returns (bytes4 selectorWithFixedSizeParam)
    {
        emit SelectorEvent(this.fixedSizeParamSelector.selector);
        return bytes4(keccak256("fixedSizeParamSelector(uint256[3])"));
    }

    /**
可变长度类型参数
可变长度参数类型通常为可变长的数组，例如：address[]、uint8[]、string等。例如，如下函数nonFixedSizeParamSelector的参数为uint256[]和string。因此，在计算该函数的method id时，只需要通过bytes4(keccak256("nonFixedSizeParamSelector(uint256[],string)"))即可。
    */
    // non-fixed size（可变长度）类型参数selector
    // 输入： param1: [1,2,3]， param2: "abc"
    // nonFixedSizeParamSelector(uint256[],string) : 0xf0ca01de
    function nonFixedSizeParamSelector(
        uint256[] memory param1,
        string memory param2
    ) external returns (bytes4 selectorWithNonFixedSizeParam) {
        emit SelectorEvent(this.nonFixedSizeParamSelector.selector);
        return bytes4(keccak256("nonFixedSizeParamSelector(uint256[],string)"));
    }
}

contract DemoContract {
    // empty contract
}

/**
映射类型参数
映射类型参数通常有：contract、enum、struct等。在计算method id时，需要将该类型转化成为ABI类型。

例如，如下函数mappingParamSelector中DemoContract需要转化为address，结构体User需要转化为tuple类型(uint256,bytes)，枚举类型School需要转化为uint8。因此，计算该函数的method id的代码为bytes4(keccak256("mappingParamSelector(address,(uint256,bytes),uint256[],uint8)"))。
    */
contract Selector {
    // Struct User
    struct User {
        uint256 uid;
        bytes name;
    }
    event SelectorEvent(bytes4 data);
    // Enum School
    enum School {
        SCHOOL1,
        SCHOOL2,
        SCHOOL3
    }

    // mapping（映射）类型参数selector
    // 输入：demo: 0x9D7f74d0C41E726EC95884E0e97Fa6129e3b5E99， user: [1, "0xa0b1"], count: [1,2,3], mySchool: 1
    // mappingParamSelector(address,(uint256,bytes),uint256[],uint8) : 0xe355b0ce
    function mappingParamSelector(
        DemoContract demo,
        User memory user,
        uint256[] memory count,
        School mySchool
    ) external returns (bytes4 selectorWithMappingParam) {
        emit SelectorEvent(this.mappingParamSelector.selector);
        return
            bytes4(
                keccak256(
                    "mappingParamSelector(address,(uint256,bytes),uint256[],uint8)"
                )
            );
    }

    /**
使用selector
我们可以利用selector来调用目标函数。例如我想调用elementaryParamSelector函数，我只需要利用abi.encodeWithSelector将elementaryParamSelector函数的method id作为selector和参数打包编码，传给call函数：
    */

    // 使用selector来调用函数
    function callWithSignature() external {
        // 调用elementaryParamSelector函数
        (bool success1, bytes memory data1) = address(this).call(
            abi.encodeWithSelector(0x3ec37834, 1, 0)
        );
    }
}
