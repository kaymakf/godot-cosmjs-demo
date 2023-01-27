import {CosmWasmClient, SigningCosmWasmClient} from '@cosmjs/cosmwasm-stargate'
import {toUtf8} from '@cosmjs/encoding'
import {coins} from '@cosmjs/stargate'
import {getConfig, keplrConfig} from './config'
import {MsgExecuteContract} from 'cosmjs-types/cosmwasm/wasm/v1/tx'
import {TxRaw} from 'cosmjs-types/cosmos/tx/v1beta1/tx'

let client;
let signingClient;
let accounts;
const config = getConfig("testnet");

export async function init_keplr() {
    console.log(config)

    if (!window.getOfflineSigner || !window.keplr) {
        alert("Please install keplr extension");
    } else {
        if (window.keplr.experimentalSuggestChain) {
            try {
                await window.keplr.experimentalSuggestChain(keplrConfig(config));
            } catch {
                alert("Failed to suggest the chain");
            }
        } else {
            alert("Please use the recent version of keplr extension");
        }
    }
    await window.keplr.enable(config.chainId)

    const signer = await window.getOfflineSignerAuto(config.chainId)
    accounts = await signer.getAccounts();

    signingClient = await SigningCosmWasmClient.connectWithSigner(config.rpcUrl, signer)
    console.log("signing client:")
    console.log(signingClient)

    console.log(signingClient)
    console.log(accounts[0].address);

    client = await CosmWasmClient.connect(config.rpcUrl)

    return accounts[0].address;
}

export async function querySmartContract(contractAddr, query) {
    console.log(query)
    const res = await client.queryContractSmart(contractAddr, JSON.parse(query));
    console.log(res)
    return res;
}

const fee = {
    amount: coins(500000, config.feeToken),
    gas: '1000000',
}

export async function executeSmartContract(contractAddr, msg) {
    console.log(msg)

    const txSigner = accounts[0].address
    const signed = await signingClient.sign(
        txSigner,
        [
            {
                typeUrl: '/cosmwasm.wasm.v1.MsgExecuteContract',
                value: MsgExecuteContract.fromPartial({
                    sender: txSigner,
                    contract: contractAddr,
                    msg: toUtf8(msg)
                }),
            },
        ],
        fee,
        '',
    )
    const res = await client.broadcastTx(TxRaw.encode(signed).finish())

    console.log(res)
    return res;
}
