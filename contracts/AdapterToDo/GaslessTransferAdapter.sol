// // SPDX-License-Identifier: GPL-3.0-or-later

// pragma solidity 0.7.6;
// pragma abicoder v2;

// import "@openzeppelin/contracts/utils/Address.sol";
// import "@openzeppelin/contracts/math/SafeMath.sol";
// import "./interfaces/IAdapter.sol";

// import "./lib/LibERC20Adapter.sol";

// /// @title  Gasless swap aggregation adapter
// /// @notice Sends a portion of the swapped amounts to the validator. Used for gasless swaps.
// /// @author MetaDexa.io
// contract GaslessTransferAdapter is IAdapter {

//     using Address for address;
//     using SafeMath for uint256;

//     address public validator; 

//     function adapt(AdapterContext calldata context)
//     external
//     payable
//     override
//     returns (bytes4 success)
//     {
//         GaslessTransferData memory data = abi.decode(context.data, (GaslessTransferData));

//         require(sender != address(0), 'Sender not valid');
//         uint256 amountToTransfer;
//         if(LibERC20Adapter.isTokenETH(data.token)){
//             amountToTransfer = address(this).balance.sub(data.feesAmount);
            
//             to.transfer(amountToTransfer);
//         }
//         else {
//             amountToTrasnfer = data.amountFrom.sub(data.feesAmount);
//             _transfer(data.token, data.receiver, amountToTransfer);
//         }

//         require(amountToTransfer > 0, 'AmountToTransfer is zero');
        
//         _transfer(data.token, payable(validator), data.paymentFees); 

//         return LibERC20Adapter.TRANSFORMER_SUCCESS;
//     }

//     function _transfer(IERC20 tokenToTransfer, address payable recipient, uint256 amountToSend)
//         internal returns (uint256)  {

//         if (amountToSend > 0 && recipient != address(this)) {
//             LibERC20Adapter.adapterTransfer(tokenToTransfer, recipient, amountToSend);
//         }
//         return amountToSend;
//     }

//     /// @dev swap adapter data
//     struct GaslessTransferData {
//         address sender;     // is this needed
//         address receiver;
//         uint8 feesAmount;
//         uint256 amountFrom;
//         IERC20 token; 
//     }
// }
