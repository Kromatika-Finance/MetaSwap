// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IAdapter.sol";

import "./lib/LibERC20Adapter.sol";

/// @title  Gasless swap aggregation adapter
/// @notice Sends a portion of the swapped amounts to the validator. Used for gasless swaps.
/// @author MetaDexa.io
contract TransferAdapter is IAdapter {

    using Address for address;
    using SafeMath for uint256;

    function adapt(AdapterContext calldata context)
    external
    payable
    override
    returns (bytes4)
    {
        TransferData memory data = abi.decode(context.data, (TransferData));

        require(data.sender != address(0), 'Sender not valid');
        require(address(data.token) != address(0), 'Token not valid');
        require(data.validator != address(0), 'Validator not set');


        uint256 amountToTransfer;
        if(LibERC20Adapter.isTokenETH(data.token)){
            amountToTransfer = address(this).balance.sub(data.feesAmount);
            
            payable(address(data.receiver)).transfer(amountToTransfer);
            payable(data.validator).transfer(data.feesAmount);
        }
        else {
            amountToTransfer = data.amountFrom.sub(data.feesAmount);
            _transfer(data.token, payable(data.receiver), amountToTransfer);
            
            _transfer(data.token, payable(data.validator), data.feesAmount); 
        }

        require(amountToTransfer > 0, 'AmountToTransfer is zero');
        // _transfer(data.token, payable(data.validator));          consider this line which transfer remaining amount of token to validator;

        return LibERC20Adapter.TRANSFORMER_SUCCESS;
    }

    function _transfer(IERC20 tokenToTransfer, address payable recipient, uint256 amountToSend)
        internal returns (uint256)  {

        if (amountToSend > 0 && recipient != address(this)) {
            LibERC20Adapter.adapterTransfer(tokenToTransfer, recipient, amountToSend);
        }
        return amountToSend;
    }

    /// @dev swap adapter data
    struct TransferData {
        address sender;     // is this needed ? 
        address receiver;
        uint8 feesAmount;
        uint256 amountFrom;
        IERC20 token; 
        address validator;
    }
}
