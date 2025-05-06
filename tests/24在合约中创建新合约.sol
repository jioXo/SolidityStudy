// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
Pair币对合约负责管理币对地址
Pair合约很简单，包含3个状态变量：factory，token0和token1。

构造函数constructor在部署时将factory赋值为工厂合约地址。initialize函数会由工厂合约在部署完成后手动调用以初始化代币地址，将token0和token1更新为币对中两种代币的地址。
*/
contract Pair{
    address public factory; // 工厂合约地址
    address public token0; // 代币1
    address public token1; // 代币2

    constructor() payable {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }
}

/**
工厂合约（PairFactory）有两个状态变量getPair是两个代币地址到币对地址的map，方便根据代币找到币对地址；allPairs是币对地址的数组，存储了所有币对地址。

PairFactory合约只有一个createPair函数，根据输入的两个代币地址tokenA和tokenB来创建新的Pair合约。其中

Pair pair = new Pair();
就是创建合约的代码，非常简单。大家可以部署好PairFactory合约，然后用下面两个地址作为参数调用createPair，看看创建的币对地址是什么：

WBNB地址: 0x2c44b726ADF1963cA47Af88B284C06f30380fC78
BSC链上的PEOPLE地址: 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c
*/
contract PairFactory{
    mapping(address => mapping(address => address)) public getPair; // 通过两个代币地址查Pair地址
    address[] public allPairs; // 保存所有Pair地址

    function createPair(address tokenA, address tokenB) external returns (address pairAddr) {
        // 创建新合约
        Pair pair = new Pair(); 
        // 调用新合约的initialize方法
        pair.initialize(tokenA, tokenB);
        // 更新地址map
        pairAddr = address(pair);
        allPairs.push(pairAddr);
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }
}
