const hre = require("hardhat");
const ethers = hre.ethers;

require("dotenv").config();
const PRIVATE_KEY = process.env.PRIVATE_KEY;


const MONAD_RPC = "https://testnet.rpc.monad.xyz";

const TOKEN_A = "0x1558b0bBCB4eDEE458E8AA98556d436E3c7B0893"; // ERC20
const AMM = "0x9dbCC2ec8EFc6e6099a4e2Ba85327a0A153f4552"; // AMM

async function main() {
  const provider = new ethers.JsonRpcProvider(MONAD_RPC);
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  const tokenA = await ethers.getContractAt("TokenA", TOKEN_A, wallet);
  const amm = await ethers.getContractAt("MonadAMM", AMM, wallet);

  const amountTokenA = ethers.parseUnits("100", 18); // 100 TokenA
  const amountNative = ethers.parseUnits("0.1", 18); // 0.1 MONAD

  // Step 1: Approve TokenA to AMM
  console.log("🪙 Approving TokenA...");
  await (await tokenA.approve(AMM, amountTokenA)).wait();

  // Step 2: Add liquidity with native token
  console.log("💧 Adding liquidity...");
  const tx = await amm.addLiquidity(
    amountTokenA, // amountTokenAIn
    0,            // amountTokenBIn (native)
    amountTokenA.mul(9).div(10), // minTokenA
    amountNative.mul(9).div(10), // minNative
    { value: amountNative }      // native token sent as msg.value
  );
  await tx.wait();

  console.log("🎉 Liquidity added with TokenA + MONAD native!");
}

main().catch((err) => {
  console.error("❌ Error adding liquidity:", err);
  process.exit(1);
});