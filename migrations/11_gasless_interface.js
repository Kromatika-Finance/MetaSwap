// const GaslessInterfaceMulticall = artifacts.require("GaslessInterfaceMulticall");
// //const MetaSwapRouter = artifacts.require("MetaSwapRouter");

// module.exports = async function(deployer,network,accounts) {

//     // const externalForwarderAddress = process.env.EXTERNAL_FORWARDER;

//     // const forwarder = await GaslessForwarder.deployed();
//     // const metaswap = await MetaSwapRouter.deployed();

//     //const targetGasPrice = await web3.eth.getGasPrice();

//     await deployer.deploy(GaslessInterfaceMulticall);

//     const gaslessInterfaceMulticall = await GaslessInterfaceMulticall.deployed();
//     console.log('gasless interface multicall is deployed at: ', gaslessInterfaceMulticall.address)
// }