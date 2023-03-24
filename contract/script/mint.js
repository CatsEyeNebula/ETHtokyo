const hre = require("hardhat");
async function main() {

    const contractAddress = "0x340055b31f41D64BCe4745FD0cB1b656515b034B";
    const recieverAddress = "0x1B888605F9d83641F6d526ed6c92F6e9ca582De0"
    const batchNFTs = await hre.ethers.getContractAt("BatchNFTs", contractAddress);

    const mintTokens = await batchNFTs.mint(recieverAddress, 10, { value: ethers.utils.parseEther("0.5") });
    console.log(`Transaction Hash: https://mumbai.polygonscan.com/tx/${mintTokens.hash}`);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});