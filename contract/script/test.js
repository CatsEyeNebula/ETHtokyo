const { ethers } = require("hardhat");

async function main() {

  const [deployer] = await ethers.getSigners()
  const balance = (await deployer.getBalance()).toString()
  console.log("Account balance:", balance, balance > 0)
  if (balance === 0) {
    throw (`Not enough eth`)
  }


  const PassCard = await ethers.getContractFactory("PassCard");
  const passCard =  PassCard.attach("0xe3FD3e45C7658600a0d24dDf6df0FdE5d39fA6B4");


  const NftDomain = await ethers.getContractFactory("NftDomain");
  const nftDomain =  NftDomain.attach("0x376B2871E3334ebD9dDE10C226E1858ae72993Db");


  const DaoDomain = await ethers.getContractFactory("DaoDomain");
  const daoDomain =  DaoDomain.attach("0xc4641f44Cd9E75CAd5BF3598f26D8Bf1CF63fcB8");


  const AnyLinkDomain = await ethers.getContractFactory("AnyLinkDomain");
  const anyLinkDomain =  AnyLinkDomain.attach("0x1c86CAeD655C5aACAFF2Ce5dd3C342b93e9aC7F4");


  const Factory = await ethers.getContractFactory("Factory");
  const factory = Factory.attach("0x651A3dF88583961f662034bfFa4A32012965450E")

//   ------------------------------------------------------------------------------------------------------------------
//   const airDropAddr = ["0x1B888605F9d83641F6d526ed6c92F6e9ca582De0","0x74Ec6b9Af591B622eE5176C2F6Fd5A29F9fF1E95"]
//   const arr = await passCard.setAirDropAddr(airDropAddr)
//   console.log(arr);
  
//   const airDrop = await passCard.multiTransferToken()
//   console.log(airDrop);
    // factory.deployNewERC721Token("Test2","TE2")

    const res = await factory.getDaoContract()
    console.log(res);
//    const owner = await passCard.ownerOf(0)
//    console.log(owner);
//    await daoDomain.setPassCard("0xe3FD3e45C7658600a0d24dDf6df0FdE5d39fA6B4")
//    const label = hre.ethers.utils.solidityPack(['bytes32'],['0x26a54d859003c49ea00384498c11dd9f3ec99d4b56b89b90662e6b16ea12bfbf'])
//    const tx = await daoDomain.claim(label,0,"gakki")
    // const addr = await daoDomain.getaddress(0);
    //   const transfer = await daoDomain.transferPassCardAndSubDomain("0x1B888605F9d83641F6d526ed6c92F6e9ca582De0",0,"gakki")
    //   nftDomain.setNftAddress("0x340055b31f41D64BCe4745FD0cB1b656515b034B")


  console.log("success");
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
