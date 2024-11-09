# ERC-7809 Playground 

Playing around with [ERC-7809](https://github.com/ethereum/EIPs/pull/9026). You can view [the original PR for this EIP](https://github.com/ethereum/EIPs/blob/dcdc6ee8f7ed391771b412103c44fb38d41d6448/EIPS/eip-7809.md) or this [markdown file](https://github.com/w3hc/erc-7809-playground/blob/main/funding.json). 

This Hardhat project includes:

-   [Typescript](https://www.typescriptlang.org/)
-   [Ethers v6](https://docs.ethers.org/v6/)
-   [OpenZeppelin Contracts v5.0.1](https://github.com/OpenZeppelin/openzeppelin-contracts/releases/tag/v5.0.1)
-   [Hardhat Verify plugin](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-verify)
-   [Hardhat Deploy plugin](https://github.com/wighawag/hardhat-deploy)

## Supported networks

-   [OP Mainnet](https://chainlist.org/chain/10) ([docs](https://docs.optimism.io/chain/networks#op-mainnet))
-   [Sepolia Testnet](https://chainlist.org/chain/11155111) ([docs](https://ethereum.org/nb/developers/docs/networks/#sepolia))
-   [OP Sepolia Testnet](https://chainlist.org/chain/11155420) ([docs](https://docs.optimism.io/chain/networks#op-sepolia))

## Install

```
pnpm install
```

Create a `.env` file:

```
cp .env.template .env
```

Add your own keys in the `.env` file.

## Test

```
pnpm test
```

## Deploy

```
pnpm deploy:<NETWORK_NAME>
```

## Check balance

You can check the current signer wallet balance:

```
pnpm bal <NETWORK_NAME>
```

## Mint

```
pnpm mint:<NETWORK_NAME> 42
```

## Send

```
pnpm send:<NETWORK_NAME> 8
```

## Versions

-   Node [v20.9.0](https://nodejs.org/uk/blog/release/v20.9.0/)
-   PNPM [v9.10.0](https://pnpm.io/pnpm-vs-npm)
-   Hardhat [v2.19.4](https://github.com/NomicFoundation/hardhat/releases/)
-   OpenZeppelin Contracts [v5.0.1](https://github.com/OpenZeppelin/openzeppelin-contracts/releases/tag/v5.0.1)
-   Ethers [v6.10.0](https://docs.ethers.org/v6/)

## Support

You can contact me via [Farcaster](https://warpcast.com/julien-), [Element](https://matrix.to/#/@julienbrg:matrix.org), [Status](https://status.app/u/iwSACggKBkp1bGllbgM=#zQ3shmh1sbvE6qrGotuyNQB22XU5jTrZ2HFC8bA56d5kTS2fy), [Telegram](https://t.me/julienbrg), [Twitter](https://twitter.com/julienbrg), [Discord](https://discordapp.com/users/julienbrg), or [LinkedIn](https://www.linkedin.com/in/julienberanger/).