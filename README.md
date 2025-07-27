# 🌀 Monad AMM Protocol

A simple Automated Market Maker (AMM) protocol deployed on the Monad Testnet, enabling swaps between native Monad ETH and a custom ERC-20 token. Liquidity Providers (LPs) are rewarded with LP tokens and collectible NFT badges.

---

## 🧩 Smart Contracts Deployed

| Contract       | Address |
|----------------|---------|
| **MonadAMM**   | `0x83f447FAb4E1267Ca5fd6Ebe151a93b462EFfC7F` |
| **TokenA**     | `0x01Ff59B9B758f1ee919F711a72a7C7F6caF33A16` |
| **LPToken**    | `0xb461f2Cfe3F8a540253736C921befA86E17E54Ff` |
| **LPBadge**    | `0x100673004E80AAe018e3C6d1Ec60A1A56C7E9c8B` |

---

## ⚙️ Features

- 🔁 **Swap**: Trade between Monad ETH and TokenA.
- 💧 **Add Liquidity**: Contribute ETH and TokenA to earn LP tokens.
- 🪙 **LP Tokens**: Track your share in the liquidity pool.
- 🏆 **LP Badges**: Earn NFT-based rewards for providing liquidity.
- 🛡️ **Slippage Protection**: Ensures minimum amount received.
- 🧮 **Charity Fee**: A small portion of fees is directed to a charity wallet.

---

## 🚀 How It Works

### 💱 1. Swapping

Users can swap Monad ETH for `TokenA` and vice versa using constant product formula (`x * y = k`).

### 💧 2. Providing Liquidity

- LPs supply equal value of `TokenA` and native ETH.
- In return, they receive:
  - `AMMLP` tokens (ERC-20) representing their share.
  - NFT **LP Badge** as a reward for participation.

### 🔓 3. Approvals

Before adding liquidity:
- Approve `TokenA` to the AMM contract.

---

## 🛠️ Tech Stack

- Solidity ^0.8.20
- OpenZeppelin Contracts
- Hardhat + Ethers.js
- Remix (for manual testing)
- IPFS (for LP Badge metadata)

---

## 📦 Setup & Deployment

```bash
git clone https://github.com/your-username/monad-amm.git
cd monad-amm

# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Deploy to Monad Testnet
npx hardhat run scripts/deploy.js --network monadTestnet
