const { ethers } = require("hardhat");

async function main() {

  const [deployer] = await ethers.getSigners()
  console.log(`Deploying contracts to ${network.name} with the account:${deployer.address}`)

  const balance = (await deployer.getBalance()).toString()
  console.log("Account balance:", balance, balance > 0)
  if (balance === 0) {
    throw (`Not enough eth`)
  }

  const Loop = await ethers.getContractFactory("Loop");
  let loop = await Loop.deploy()  
  await loop.deployTransaction.wait()
  console.log("loop address:", loop.address) 

   loop = Loop.attach(loop.address)
  const tx = await loop.startlooping()
  console.log(tx);
  const res = await loop.loop()
  console.log(res);
  console.log("sucess");
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
