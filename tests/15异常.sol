// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ErrorTest {
    // error transferNotOwner();//自定义error
    error transferNotOwner(address sender); // 自定义的带参数的error

    mapping(uint256 => address) public _owners; //定义一个mapping映射

    //定义一个TransferNotOwner异常，当用户不是代币owner的时候尝试转账，会抛出错误
    //例子
    function transferNotOner(uint256 tokenId, address newOwner) public {
        if (_owners[tokenId] != msg.sender) {
            // revert transferNotOwner();
            revert transferNotOwner(msg.sender);
        }
        _owners[tokenId] = newOwner;
    }

    //使用require
    function transferOwner2(uint256 tokenId, address newOwner) public {
        require(_owners[tokenId] == msg.sender, "Transfer Not Owner");
        _owners[tokenId] = newOwner;
    }


    //使用assert
    function transferOwner3(uint256 tokenId, address newOwner) public {
        assert(_owners[tokenId] == msg.sender);
        _owners[tokenId] = newOwner;
    }
}
