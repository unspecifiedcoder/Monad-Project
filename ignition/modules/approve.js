const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
  const [deployer] = await ethers.getSigners();

  const TOKEN_A = "0xf878A7E257501f6F49f12a31c8a4db16d51Aa4C5";
  const TOKEN_B = "0xaF712732Bd2c8EF589BB9ffF5421Ed428E4207e1";
  const AMM = "0x9350B02942A690Ad14BC4a916D574F0bD49d1662";

  const tokenA = await ethers.getContractAt("TokenA", TOKEN_A);
  const tokenB = await ethers.getContractAt("TokenB", TOKEN_B);
  const amm = await ethers.getContractAt("MonadAMM", AMM);

  const amount = ethers.utils.parseUnits("100", 18); // or .parseEther("100")

  console.log("Approving...");
  await (await tokenA.approve(AMM, amount)).wait();
  await (await tokenB.approve(AMM, amount)).wait();

  console.log("Adding liquidity...");
  const tx = await amm.addLiquidity(
    amount,
    amount,
    amount.mul(9).div(10),
    amount.mul(9).div(10)
  );
  await tx.wait();

  console.log("✅ Liquidity added.");
}

main().catch((error) => {
  console.error("❌ Error:", error);
  process.exit(1);
});
