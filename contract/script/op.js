const {network} = require("hardhat")

async function main() {
    const [deployer] = await ethers.getSigners()
    console.log(`Deploying contracts to ${network.name} with the account:${deployer.address}`)

    const balance = (await deployer.getBalance()).toString()
    console.log("Account balance:", balance, balance > 0)
    if (balance === 0) {
        throw (`Not enough eth`)
    }    
    

    const provider = new ethers.providers.FallbackProvider([ethers.provider], 1);

    const feeData = await hre.ethers.provider.getFeeData()

    const FEE_DATA = {
        maxFeePerGas: feeData.maxFeePerGas,
        maxPriorityFeePerGas:  ethers.utils.parseUnits("300","gwei"),
        baseFeePerGas: feeData.lastBaseFeePerGas
    };

    provider.getFeeData = async () => FEE_DATA;

    // await daoDomain.deployed({
    //     maxPriorityFeePerGas: ethers.utils.parseUnits("300","gwei"),
    //     maxFeePerGas: ethers.utils.parseUnits("500","gwei"),
    //     type: 2,
    //     baseFeePerGas: feeData.lastBaseFeePerGas,
    // })
    const DaoDomain = await ethers.getContractFactory("DaoDomain")
    const daoDomain = await DaoDomain.deploy();
    console.log("daoDomain address:", daoDomain.address)

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

    
