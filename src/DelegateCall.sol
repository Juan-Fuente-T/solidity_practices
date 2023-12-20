// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

interface ICounter {
    function increment() external;
}

contract ContratoDelegateCall {
    uint256 public number;
    address public immutable contratoCounter;

    error FalloDelegateCall();

    constructor(address _contratoCounter) {
        contratoCounter = _contratoCounter;
    }

    function ejecutaDelegateCallIncrement() public {
        (bool correcto, ) = contratoCounter.delegatecall(
            abi.encodeWithSignature("increment()")
        );
        //contratoCounter.delegateCall(abi.encodeWithSignature("setNumber(uint256)", 5);//primer parametro la funcion y el segundo el/los parametros a pasar a la funcion
        //contratoCounter.delegateCall("increment()");//no serivia de este modo, a bajo nivel no entenderia el string "increment()"
        //address(contratoCounter).delegateCall();//esto en caso de que contratoCounter fuese una interfaz
        if (!correcto) {
            revert FalloDelegateCall();
        }
    }

    function ejecutaDelegateCallSetNumber(uint256 _number) public {
        (bool correcto, ) = contratoCounter.delegatecall(
            abi.encodeWithSignature("setNumber(uint256)", _number)
        );
        if (!correcto) {
            revert FalloDelegateCall();
        }
    }
}
