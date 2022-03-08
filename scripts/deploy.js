const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory("Domains");
    const domainContract = await domainContractFactory.deploy("betz");
    await domainContract.deployed()
    console.log("Contract deployed to: ", domainContract.address);

    let txn = await domainContract.register("Donkey", {value: hre.ethers.utils.parseEther('0.1')});
    await txn.wait();
    console.log("Minted domain Donkey.betz")

    txn = await domainContract.setRecord("Donkey", "Why ape when you can Donk!")
    await txn.wait();
    console.log("Set the record for Donkey")

   const address = await domainContract.getAddress("Donkey");
   console.log("Owner of domain donkey:", address)

   const balance = await hre.ethers.provider.getBalance(domainContract.address);
   console.log("Contract balance:", hre.ethers.utils.formatEther(balance))

};

const runMain = async () => {
    try {
        await main();
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
}

runMain();