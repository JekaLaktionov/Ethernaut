async function main() {
  const contractAddress = "0x3c8333Ad664Df3c453f6d10f44fC7B45129A529B";
  const storageSlot =
    "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc";

const data =  await web3.eth.getStorageAt(contractAddress, storageSlot)
  console.log(`Data from slot ${storageSlot}:`, data);
}

main().catch(console.error);