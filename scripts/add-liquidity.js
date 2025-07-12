const hre = require("hardhat");
const { ethers } = require("ethers"); // Import native ethers here

async function main() {
  const [user] = await hre.ethers.getSigners();

  const TOKEN_A = "0xf878A7E257501f6F49f12a31c8a4db16d51Aa4C5";
  const AMM = "0x9350B02942A690Ad14BC4a916D574F0bD49d1662";

  const tokenA = await hre.ethers.getContractAt("TokenA", TOKEN_A);
  const amm = await hre.ethers.getContractAt("MonadAMM", AMM);

  const amountIn = ethers.utils.parseEther("10");

  console.log("Approving TokenA for swap...");
  await (await tokenA.approve(AMM, amountIn)).wait();

  console.log("Swapping TokenA to TokenB...");
  const tx = await amm.swap(tokenA.address, amountIn, 1); // minAmountOut = 1
  await tx.wait();

  console.log("✅ Swap successful!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
