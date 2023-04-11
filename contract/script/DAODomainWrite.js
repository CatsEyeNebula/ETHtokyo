const { ethers } = require("hardhat");

async function main() {

  const [deployer] = await ethers.getSigners()
  const balance = (await deployer.getBalance()).toString()
  console.log("Account balance:", balance, balance > 0)
  if (balance === 0) {
    throw (`Not enough eth`)
  }

  const DaoDomain = await ethers.getContractFactory("DaoDomain");
  const daoDomain =  DaoDomain.attach("0x35Cf96B925Ac45C9499255d9A1E8B326ec0DFe67");


  let tokenId = hre.ethers.utils.solidityPack(['uint256'],['79233663829379634837589865448569342784712482819484549289560981379859480642508'])
  const addrArray = ["0x1B888605F9d83641F6d526ed6c92F6e9ca582De0","0x4f2C69C125E8c979c80F393E8E70180f5f91a633"]
  const passCardFactoryAddr = await daoDomain.getPassCardFactoryAddr()

  let label = hre.ethers.utils.solidityPack(['bytes32'],['0x03c85f1da84d9c6313e0c34bcb5ace945a9b12105988895252b88ce5b769f82b'])

  // const tx = await daoDomain.issueDomain("dsad","G",tokenId,true,true,addrArray)
  // console.log(tx);
  const res = await daoDomain.tokenId()
  console.log(res);
  
  // const res = await daoDomain.claim(label,0,"0x45602525EBAF8df2eAd8d16e368bB7306D76d534")
  // const res = await daoDomain.PasscardToBind('0x45602525EBAF8df2eAd8d16e368bB7306D76d534',8)
  // console.log(res);
  console.log("success");
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
