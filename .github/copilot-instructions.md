<!-- Copilot / AI agent instructions for Foundry FundMe project -->
# Project overview

This is a small Foundry-based Solidity sample project (a FundMe contract) that demonstrates Chainlink price-feed integration, local mocks, and Foundry scripting/tests.

**Big picture**
- `src/` contains contracts: `FundMe.sol` (main contract) and `PriceConverter.sol` (library). See [src/FundMe.sol](src/FundMe.sol#L1) and [src/PriceConverter.sol](src/PriceConverter.sol#L1).
- `script/` contains deployment helpers (`DeployFundMe.s.sol`, `HelperConfig.s.sol`). `HelperConfig` chooses between a live feed (Sepolia) and a local mock.
- `test/` contains Forge tests and local mocks in `test/mocks/` (see `MockV3Aggregator.sol`). Tests use `forge-std/Test.sol` and the `vm` utilities.

**Why it’s structured this way**
- Separation of conversion logic into `PriceConverter` (library) keeps `FundMe` focused on funding/withdrawal logic.
- `HelperConfig` encapsulates network-specific configuration and mock deployment so tests/scripts can be environment-agnostic.

Key integration points
- Chainlink price feed interface: `AggregatorV3Interface` imported via the remapping in `foundry.toml` (`@chainlink/contracts/...`). See [foundry.toml](foundry.toml#L1).
- Local mock: `test/mocks/MockV3Aggregator.sol` used by `HelperConfig` when `block.chainid` indicates local Anvil.

Developer workflows (commands)
- Build: `forge build`
- Test: `forge test` (tests use `forge-std` and may rely on `script/DeployFundMe.s.sol` to produce a `FundMe` instance)
- Format: `forge fmt`
- Run deploy scripts (example):
```bash
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url <RPC_URL> --private-key <KEY>
```

Project-specific conventions and patterns
- Naming: storage prefixes `s_` for storage variables, `i_` for immutable, constants UPPER_SNAKE (example: `MINIMUM_USD`). See [src/FundMe.sol](src/FundMe.sol#L1).
- Libraries: conversion functions are `internal view` in `PriceConverter` and are used via `using PriceConverter for uint256;` in `FundMe`.
- Errors: prefer custom `error` types and `revert` (example: `error NotOwner();` and `if (msg.sender != i_owner) revert NotOwner();`).
- Scripts/tests use `vm.startBroadcast()` / `vm.stopBroadcast()` for real transactions in scripts and `vm` utilities in tests.
- Mocks are deployed conditionally in `HelperConfig.getAnvilEthConfig()` and returned as a `NetworkConfig` struct.

Files to inspect for further automation or edits
- [script/HelperConfig.s.sol](script/HelperConfig.s.sol#L1) — network config & mock deployment
- [script/DeployFundMe.s.sol](script/DeployFundMe.s.sol#L1) — example script using `vm.startBroadcast()`
- [test/FundMeTest.t.sol](test/FundMeTest.t.sol#L1) — shows test expectations, chainid conditional checks

Quick examples (copyable)
- Use price feed in code (pattern):
```
uint256 usd = msg.value.getConversionRate(s_priceFeed);
require(usd >= MINIMUM_USD);
```
- Deploy mock in script/test pattern (from `HelperConfig`):
```
MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
return address(mock);
```

Notes for AI agents
- Prefer minimal, targeted edits. Preserve Foundry remappings in `foundry.toml`.
- When changing network addresses, update `HelperConfig` rather than hardcoding addresses in tests.
- Tests rely on `forge-std` and `vm` APIs; avoid refactoring tests to remove `vm` utilities.
- If adding features, maintain the separation between `PriceConverter` (pure/view logic) and `FundMe` (stateful behavior).

If anything is unclear or you'd like more examples (scripts, CI, or test refactors), tell me which area to expand.
