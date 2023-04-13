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
  // const DaoDomain = await ethers.getContractFactory("DaoDomain");
  // const daoDomain =  DaoDomain.attach("0xaE3142783b6B5Cb1269e3334b078FA1A2333BD08");

  const StorageDomain = await ethers.getContractFactory("StorageDomain",signer);
  const storageDomain =  StorageDomain.attach("0x1B6Ae908017C2Ff4d8032d5A5Ba28E51FAfe11a9");

  const res = await storageDomain.setAuthorityContract("0xb3E8Ee61DaD593c28B1c8fB6Cb990a128d02990d","0x16ffcff27EFB3885fbac65548499F7b311C6d2dd","0xb3E8Ee61DaD593c28B1c8fB6Cb990a128d02990d")
  // const res = await storageDomain.NFTDomain()
  console.log(res);
  // let tokenId = hre.ethers.utils.solidityPack(['uint256'],['79233663829379634837589865448569342784712482819484549289560981379859480642508'])
  // const addrArray = ["0x1B888605F9d83641F6d526ed6c92F6e9ca582De0","0x4f2C69C125E8c979c80F393E8E70180f5f91a633"]
  // const passCardFactoryAddr = await daoDomain.getPassCardFactoryAddr()
  // const passcardAdr = await storageDomain.ProJectTeam("0x1B888605F9d83641F6d526ed6c92F6e9ca582De0","gie")
  // console.log("passcardAdr",passcardAdr);
  // let label = hre.ethers.utils.solidityPack(['bytes32'],['0x03c85f1da84d9c6313e0c34bcb5ace945a9b12105988895252b88ce5b769f82b'])
  // const passcardadr = await storageDomain.ENS_RECORD_ARR(0)
  // console.log('passcardAdr',passcardadr);
  // const tx = await daoDomain.issueDomain("gie","G",tokenId,true,true,addrArray)
  // console.log(tx);
  // const res = await daoDomain.tokenId()
  // console.log(res);
  
  // const res = await daoDomain.claim(label,0,passcardAdr)
  // const res = await daoDomain.PasscardToBind('0x45602525EBAF8df2eAd8d16e368bB7306D76d534',8)
  // console.log(res);
  console.log("success");
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
