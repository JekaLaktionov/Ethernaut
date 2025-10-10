import { expect } from "chai";
import { network } from "hardhat";
import { Contract } from "ethers";

const { ethers } = await network.connect();

describe("GatekeeperOne", function () {

  it("We should be able to open the second gate.", async function () {
    const gate = await ethers.deployContract("GatekeeperOne");
    const hack = await ethers.deployContract("Hack",[gate.target]);
    const ad = await hack.targetI();
    const en = await gate.entrant();
    const [owner, user] = await ethers.getSigners();
    const baseGas = 120000;
    console.log(gate.target,hack.target, ad, "entrant", en);
     for (let i = 256; i < 8191; i++) {
            try {
                await hack.enteri.staticCall( i, {
                    gasLimit: baseGas,
                });

                
                console.log(` Success! Working gas found: ${i}`);
                const tx =await hack.enteri(i);
                console.log(await gate.entrant(), "owner", owner.address);
                expect(await gate.entrant()).to.be.eqls(owner.address);
                return;
            } catch (error:any) {
console.log(i, (error as Error).message.slice(0, 100));
            }
        }
    expect.fail("All gas values failed to execute the internal call.");
  });
});
