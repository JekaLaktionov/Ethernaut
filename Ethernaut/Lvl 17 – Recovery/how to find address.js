import { keccak256, getAddress, toBeHex } from 'ethers';
import { encode as rlpEncode } from '@ethersproject/rlp';

function computeCreateAddress(creator, nonce) {
    const rlpNonce = nonce === 0 ? '0x' : toBeHex(nonce);
    
    const encoded = rlpEncode([creator, rlpNonce]);
    
    const hashed = keccak256(encoded);
    const newAddress = getAddress('0x' + hashed.slice(-40));
    
    return newAddress;
}

const creatorAddress = "0x05f821F36997830E604c9dBDbc97c6f2722755fc";
const nonce = 1;
const predictedAddress = computeCreateAddress(creatorAddress, nonce);

console.log(predictedAddress);
