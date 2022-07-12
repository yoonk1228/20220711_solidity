pragma solidity ^0.8.15;

contract HelloWorld {
    string text; // 상태변수, 멤버변수

    constructor() {
        text = "Hello World";
    } // 세미콜론이 기본이다.

    function getText() public view returns(string memory){
        return text;
    }

    // ex
    function setText(string memory value) public {
        text = value;
    }
}
