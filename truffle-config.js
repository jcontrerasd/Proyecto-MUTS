const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');

require("dotenv").config();

const private_key = process.env.SIGNER_PRIVATE_KEY;

if (!private_key || private_key === '') {
    throw new Error('SIGNER_PRIVATE_KEY is not set in .env files');
}

const checkRPC = (networkName, rpcEnvVar) => {
    if (!process.env[rpcEnvVar]) {
        throw new Error(`${rpcEnvVar} is not set in .env file for ${networkName}`);
    }
    return process.env[rpcEnvVar];
};

module.exports = {
    
    plugins: ['truffle-plugin-verify'],
    api_keys: {
        etherscan: process.env.ETH_SCAN_API_KEY,
        polygonscan: process.env.POLYGON_SCAN_API_KEY,
        sepoliascan: process.env.ETH_SEPOLIA_SCAN_API_KEY,
        bscscan: process.env.BSC_SCAN_API_KEY
    },

    contracts_build_directory: "./client/src/contracts",

    networks: {
        ethereum_goerli_testnet: {
            provider: () => new HDWalletProvider(private_key, checkRPC('ethereum_goerli_testnet', 'ETH_GOERLI_TESTNET_RPC')),
            network_id: 5,
            confirmations: 2,
            networkCheckTimeout: 10000,
            timeoutBlocks: 500,
            skipDryRun: true,
            gasPrice: 10000000000
        },
        eth_sepolia_testnet: {
            provider: () => new HDWalletProvider(private_key, checkRPC('eth_sepolia_testnet', 'ETH_SEPOLIA_TESTNET_RPC')),
            network_id: 11155111,
            confirmations: 2,
            timeoutBlocks: 200,
            skipDryRun: true
        },
        development: {
            host: "127.0.0.1",
            port: 9545,
            network_id: "*",
        },
        ganache: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*",
        },
        dashboard: {
            host: "127.0.0.1",
            port: 24012,
            network_id: "*",
        },
        polygon_mumbai_testnet: {
            provider: () => new HDWalletProvider(private_key, checkRPC('polygon_mumbai_testnet', 'POLYGON_MUMBAI_TESTNET_RPC')),
            network_id: 80001,
            confirmations: 2,
            timeoutBlocks: 200,
            skipDryRun: true
        },
        binance_bsc_testnet: {
            provider: () => new HDWalletProvider(private_key, checkRPC('binance_bsc_testnet', 'BSC_TESTNET_RPC')),
            network_id: 97,
            confirmations: 2,
            timeoutBlocks: 200,
            skipDryRun: true
        }
    },
    compilers: {
        solc: {
            version: "0.8.20",
            settings: {
                optimizer: {
                    enabled: false,
                    runs: 200
                }
            }
        }
    }
};
