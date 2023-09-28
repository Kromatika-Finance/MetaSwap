// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @notice A fork of Multicall2 specifically tailored for the gasless Interface. Used in simulations.
contract GaslessInterfaceMulticall {

    address controller;

    constructor(){
        controller = msg.sender;
    }

    struct Call {
        address target;
        uint256 gasLimit;
        bytes callData;
    }

    struct Result {
        bool success;
        uint256 gasUsed;
        bytes returnData;
    }

    function getCurrentBlockTimestamp() public view returns (uint256 timestamp) {
        timestamp = block.timestamp;
    }

    function getEthBalance(address addr) public view returns (uint256 balance) {
        balance = addr.balance;
    }

    function approveToken(address token, uint256 amount, address spender) public {
        IERC20(token).approve(spender, amount);
    }

    function changeController(address _controller) public onlyController{
        require(_controller != address(0), 'Address is address(0)');
        controller = _controller;
    }


    function multicall(Call[] calldata calls) public returns (uint256 blockNumber, Result[] memory returnData) {
        blockNumber = block.number;
        returnData = new Result[](calls.length);
        for (uint256 i = 0; i < calls.length; i++) {
            (address target, uint256 gasLimit, bytes memory callData) =
                (calls[i].target, calls[i].gasLimit, calls[i].callData);
            uint256 gasLeftBefore = gasleft();
            (bool success, bytes memory ret) = target.call{gas: gasLimit}(abi.encodePacked(callData,msg.sender));
            uint256 gasUsed = gasLeftBefore - gasleft();
            returnData[i] = Result(success, gasUsed, ret);
        }
    }

    /// @dev Receives ether
    receive() external payable {}

        // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function withdrawEther(address payable _to) public onlyController {
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    function withdrawTokens(address payable _to, address _tokenAddress) public onlyController {
        IERC20 token = IERC20(_tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        
        require(balance > 0, "No tokens to transfer");

        require(token.transfer(_to, balance), "Token transfer failed");
    }


    modifier onlyController(){
        require(msg.sender == controller, 'Caller not controller');
        _;
    }
}