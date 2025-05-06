// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
Hash的应用
生成数据唯一标识
加密签名
安全加密
Keccak256
Keccak256函数是Solidity中最常用的哈希函数，用法非常简单：

哈希 = keccak256(数据);
我们可以利用keccak256来生成一些数据的唯一标识。比如我们有几个不同类型的数据：uint，string，address，我们可以先用abi.encodePacked方法将他们打包编码，然后再用keccak256来生成唯一标识：
*/

contract HASH {
    bytes32 _msg = keccak256(abi.encodePacked("0xAA"));

    function hash(
        uint256 _num,
        string memory _string,
        address _addr
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_num, _string, _addr));
    }

    // 弱抗碰撞性
    function weak(string memory string1) public view returns (bool) {
        return keccak256(abi.encodePacked(string1)) == _msg;
    }
}
