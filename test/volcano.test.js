const Volcano = artifacts.require("VolcanoCoin");
contract("Volcano", accounts => {
    it("should mint 10000 VolcanoCoin", async () => {
    const instance = await Volcano.deployed();
    console.log(accounts);
    const totalSupply = await instance.totalSupply.call();
    assert.equal(
        totalSupply.toNumber(),
       10000,
        "Minting Failed",
        );            
    });

    it("account 0xcB7C09fEF1a308143D9bf328F2C33f33FaA46bC2 has zero balance", async () => {
        const instance = await Volcano.deployed();
        //console.log(instance);
        const balance = await instance.balanceOf.call('0xcB7C09fEF1a308143D9bf328F2C33f33FaA46bC2');
        assert.equal(
            balance.toNumber(),
           0,
            "Non- zero account",
            );            
        });


        it("Owner has the balance 10000 tokens ", async () => {
            const instance = await Volcano.deployed();
            //console.log(instance);
            const balance = await instance.balanceOf.call('0xcB5458275e25E8711C16De51f5C5F7E738640dc6');
            assert.equal(
                balance.toNumber(),
               10000,
                "Failed to assign the supply to owner",
                );            
            });
});