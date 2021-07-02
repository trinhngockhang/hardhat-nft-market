# RUN
## Copy config
`cp .env.example .env`

## Deploy
### Local
`npm run deploy-local`
### Goerli
`npm run deploy-goerli`
### BSC testnet
`npm run deploy-bsc`

## Verify
`npx hardhat verify 'token_address' args`  
`npx hardhat verify --contract contracts/Token.sol:Token 'token_address' args`