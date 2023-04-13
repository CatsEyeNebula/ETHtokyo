const { ethers } = require("hardhat");

async function main() {

  const [deployer] = await ethers.getSigners()
  const balance = (await deployer.getBalance()).toString()
  console.log("Account balance:", balance, balance > 0)
  if (balance === 0) {
    throw (`Not enough eth`)
  }
  const feeData = await hre.ethers.provider.getFeeData()

  const FEE_DATA = {
    maxFeePerGas: ethers.utils.parseUnits("400","gwei"),
    maxPriorityFeePerGas: ethers.utils.parseUnits("100","gwei"),
    baseFeePerGas: ethers.utils.parseUnits("300","gwei"),
};

const provider = new ethers.providers.FallbackProvider([ethers.provider], 1);
provider.getFeeData = async () => FEE_DATA;

const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  const NFTDomain = await ethers.getContractFactory("NFTDomain",signer);
  const nftdomain =  NFTDomain.attach("0x16ffcff27EFB3885fbac65548499F7b311C6d2dd");
    let tokenId = hre.ethers.utils.solidityPack(['uint256'],['32458854917991047305073454784868571352917477444096433010696627211978253870766'])


//   const res = await nftdomain.issueDomain("gie","0x15c614137842A13a04e8C23679BC0eD9C8A88315",tokenId)
  const res = await nftdomain.claim(0,"0x15c614137842A13a04e8C23679BC0eD9C8A88315","gie");
//   const res = await nftdomain.getNftList("0x15c614137842A13a04e8C23679BC0eD9C8A88315");
  console.log(res);
  console.log("success");
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
