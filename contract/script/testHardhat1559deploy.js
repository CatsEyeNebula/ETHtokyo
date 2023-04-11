const { network, run, ethers } = require("hardhat")
const hre = require("hardhat");
async function main() {
    const [deployer] = await ethers.getSigners()
    const balance = (await deployer.getBalance()).toString()
    console.log("Account balance:", balance, balance > 0)
    if (balance === 0) {
        throw (`Not enough eth`)
    }
    const feeData = await hre.ethers.provider.getFeeData()
    console.log(`Deploying contracts to ${network.name} with the account:${deployer.address}`)

    const FEE_DATA = {
        maxFeePerGas: feeData.maxFeePerGas,
        maxPriorityFeePerGas:ethers.utils.parseUnits("600","gwei"),
        baseFeePerGas: feeData.lastBaseFeePerGas,
    };
    console.log('feddata',feeData)
    // Wrap the provider so we can override fee data.
    const provider = new ethers.providers.FallbackProvider([ethers.provider], 1);
   
    provider.getFeeData = async () => FEE_DATA;
   let gasPrice = await hre.ethers.provider.getGasPrice()
    const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
    const DaoDomain = await ethers.getContractFactory("DaoDomain",signer);
    const daoDomain = await DaoDomain.deploy()
    await daoDomain.deployed({gasPrice: gasPrice, type: 2 })  
    await daoDomain.deployTransaction.wait()
    console.log("daoDomain address:", daoDomain.address)    
}


function sleep(millisecond) {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve()
        }, millisecond)
    })
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

