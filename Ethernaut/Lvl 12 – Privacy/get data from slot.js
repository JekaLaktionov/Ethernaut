const { ethers } = require("ethers");

async function main() {

const provider = new ethers.providers.Web3Provider(window.ethereum);
await provider.send("eth_requestAccounts", []);

const contractAddress = "0x047B6859c2d01c54273AccCd747e830258921258";
const storageSlot = 5;

  const data = await provider.getStorageAt(contractAddress, storageSlot);
    
    console.log(`Data from slot ${storageSlot}:`,data);

}

main().catch(console.error);
