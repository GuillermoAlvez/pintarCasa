pragma solidity ^0.4.6;
import "./pintarCasa.sol";

contract fabricPainter {
    address[] public painters;
    function createPainter (address _painterAddress, uint _diaPintado, uint _tiempoDisputa) public payable returns(address) {
         address newPainter = (new pintarCasa).value(msg.value)(_painterAddress, _diaPintado, _tiempoDisputa);
         painters.push(newPainter);
         return newPainter;
    }
}