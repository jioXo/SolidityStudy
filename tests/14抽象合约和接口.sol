// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

abstract contract Base{
    string public name="base";
    function getAlias() public pure  virtual returns(string memory);
}

contract BaseImpl is Base{
    function getAlias() public pure override(Base)returns(string memory){return "im base";}
}

