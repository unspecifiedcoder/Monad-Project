const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("MonadAMMModule", (m) => {
  const tokenA = m.contract("TokenA", [m.getAccount(0)]);
  const tokenB = m.contract("TokenB", [m.getAccount(0)]);
  const lpToken = m.contract("LPToken");
  const lpBadge = m.contract("LPBadge", [
    m.getAccount(0),
    "ipfs://bafkreigbqlikf7bg5hfqvkxac6ia53jeunkhdm4eaf2eo2imbxkn4u4amq/",
  ]);

  const amm = m.contract("MonadAMM", [tokenA, tokenB]);

  m.call(amm, "setLPToken", [lpToken]);
  m.call(amm, "setLPBadge", [lpBadge]);

  // Log contract addresses once deployed

  return { tokenA, tokenB, lpToken, lpBadge, amm };
});