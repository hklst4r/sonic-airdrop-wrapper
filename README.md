## Sonic Airdrop Wrapper

**Sonic Airdrop Wrapper** is a smart contract project on Sonic chain designed to facilitate the wrapping and unwrapping of the Sonic Airdrop ERC1155 tokens into ERC20 tokens. This project is implemented in Solidity and utilizes OpenZeppelin's contract library for secure and efficient token operations.

**NOTE:** This Github repository is only for educational purpose and I do not gurantee its security & functionality. And it is not endorsed by the Sonic chain, please do your own research. It is not a financial advice.

## Key Features

- **Minting**: Users can mint `wAIRDROP-1` tokens by transferring ERC1155 tokens of a specific season to the contract.
- **Redeeming**: Users can redeem their `wAIRDROP-1` tokens by burning them and receiving an equivalent amount of ERC1155 tokens back.
- **ERC1155 Reception**: The contract automatically mints `wAIRDROP-1` tokens when it receives ERC1155 tokens, ensuring seamless integration and token management.

## Contract Details

- **NFT Address**: The contract interacts with a specific ERC1155 token contract located at `0xE1401171219FD2fD37c8C04a8A753B07706F3567`.
- **Season**: The current season for token operations is set to `1`.

## Usage Instructions

### Test

To test the contract, use the following command:
```
forge test -vv
```

### Deployment

The airdrop NFT wrapper has been deployed on Sonic network: [0x496bb047fe500752ec6b6797d6621e1584e5561c](https://sonicscan.org/address/0x496bb047fe500752ec6b6797d6621e1584e5561c)
