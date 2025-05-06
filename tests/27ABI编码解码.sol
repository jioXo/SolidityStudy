// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
ABI (Application Binary Interface，应用二进制接口)是与以太坊智能合约交互的标准。数据基于他们的类型编码；并且由于编码后不包含类型信息，解码时需要注明它们的类型。

Solidity中，ABI编码有4个函数：abi.encode, abi.encodePacked, abi.encodeWithSignature, abi.encodeWithSelector。而ABI解码有1个函数：abi.decode，用于解码abi.encode的数据。
*/

contract ABI {
    uint256 x = 10;
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    string name = "0xAA";
    uint256[2] array = [5, 6];

    /**
    abi.encode
将给定参数利用ABI规则编码。ABI被设计出来跟智能合约交互，他将每个参数填充为32字节的数据，并拼接在一起。如果你要和合约交互，你要用的就是abi.encode。
编码的结果为0x000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000007a58c0be72be218b41c608b7fe7c5bb630736c7100000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000043078414100000000000000000000000000000000000000000000000000000000，详细解释下编码的细节：
000000000000000000000000000000000000000000000000000000000000000a    // x
0000000000000000000000007a58c0be72be218b41c608b7fe7c5bb630736c71    // addr
00000000000000000000000000000000000000000000000000000000000000a0    // name 参数的偏移量
0000000000000000000000000000000000000000000000000000000000000005    // array[0]
0000000000000000000000000000000000000000000000000000000000000006    // array[1]
0000000000000000000000000000000000000000000000000000000000000004    // name 参数的长度为4字节
3078414100000000000000000000000000000000000000000000000000000000    // name
其中 name 参数被转换为UTF-8的字节值 0x30784141，在 abi 编码规范中，string 属于动态类型 ，动态类型的参数需要借助偏移量进行编码，可以参考动态类型的使用。由于 abi.encode 会将每个参与编码的参数元素（包括偏移量，长度）都填充为32字节（evm字长为32字节），所以可以看到编码后的数据中有很多填充的 0 。
*/
    function encode() public view returns (bytes memory result) {
        result = abi.encode(x, addr, name, array);
    }

    /**
abi.encodePacked
将给定参数根据其所需最低空间编码。它类似 abi.encode，但是会把其中填充的很多0省略。比如，只用1字节来编码uint8类型。当你想省空间，并且不与合约交互的时候，可以使用abi.encodePacked，例如算一些数据的hash时。需要注意，abi.encodePacked因为不会做填充，所以不同的输入在拼接后可能会产生相同的编码结果，导致冲突，这也带来了潜在的安全风险。
编码的结果为0x000000000000000000000000000000000000000000000000000000000000000a7a58c0be72be218b41c608b7fe7c5bb630736c713078414100000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000006，由于abi.encodePacked对编码进行了压缩，长度比abi.encode短很多。
    */
    function encodePacked() public view returns (bytes memory result) {
        result = abi.encodePacked(x, addr, name, array);
    }

    /**
abi.encodeWithSignature
与abi.encode功能类似，只不过第一个参数为函数签名，比如"foo(uint256,address,string,uint256[2])"。当调用其他合约的时候可以使用。
    */
    function encodeWithSignature() public view returns (bytes memory result) {
        result = abi.encodeWithSignature(
            "foo(uint256,address,string,uint256[2])",
            x,
            addr,
            name,
            array
        );
    }

    /**
abi.encodeWithSelector
与abi.encodeWithSignature功能类似，只不过第一个参数为函数选择器，为函数签名Keccak哈希的前4个字节。
编码的结果为0xe87082f1000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000007a58c0be72be218b41c608b7fe7c5bb630736c7100000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000043078414100000000000000000000000000000000000000000000000000000000，与abi.encodeWithSignature结果一样。
    */
    function encodeWithSelector() public view returns (bytes memory result) {
        result = abi.encodeWithSelector(
            bytes4(keccak256("foo(uint256,address,string,uint256[2])")),
            x,
            addr,
            name,
            array
        );
    }

    /**
ABI解码
abi.decode
abi.decode用于解码abi.encode生成的二进制编码，将它还原成原本的参数。
    */
    function decode(bytes memory data)
        public
        pure
        returns (
            uint256 dx,
            address daddr,
            string memory dname,
            uint256[2] memory darray
        )
    {
        (dx, daddr, dname, darray) = abi.decode(
            data,
            (uint256, address, string, uint256[2])
        );
    }
}
