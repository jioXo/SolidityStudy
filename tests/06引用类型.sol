// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract C {

    // 可变长度 Array
uint[] array4;
bytes1[] array5;
address[] array6;
bytes array7;
    function f() public pure {
        g([uint(1), 2, 3]);
    }
    function g(uint[3] memory _data) public pure {
        // ...
    }

    //动态数组
    function arraypush() public returns (uint[] memory){
        uint[2] memory a=[uint(1),2];
        array4=a;
        array4.push(3);
        return array4;

    }

        // 结构体
    struct Student{
        uint256 id;
        uint256 score; 
    }

    Student student; // 初始一个student结构体

        //  给结构体赋值
    // 方法1:在函数中创建一个storage的struct引用
    function initStudent1() external{
        Student storage _student = student; // assign a copy of student
        _student.id = 11;
        _student.score = 100;
    }

        // 方法2:直接引用状态变量的struct
    function initStudent2() external{
        student.id = 1;
        student.score = 80;
    }

        // 方法3:构造函数式
    function initStudent3() external {
        student = Student(3, 90);
    }

        // 方法4:key value
    function initStudent4() external {
        student = Student({id: 4, score: 60});
    }
}