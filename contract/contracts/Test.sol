// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;


interface IENS {

    function resolver(bytes32 node) external view returns (address);

}

contract Test {
    address ens = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e; 
    address public res;
    bytes32 private constant ETH_NODE =
        0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae;

    function get(string memory _nodename) external {
        bytes32 nodehash = keccak256(abi.encodePacked(_nodename));

        bytes32 node = keccak256(abi.encodePacked(ETH_NODE, nodehash));

        res = IENS(ens).resolver(node);
    }
}