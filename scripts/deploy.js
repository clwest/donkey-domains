const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory("Domains");
    const domainContract = await domainContractFactory.deploy("betz");
    await domainContract.deployed()
    console.log("Contract deployed to: ", domainContract.address);

    let txn = await domainContract.register("Poofdickle", {value: hre.ethers.utils.parseEther('0.1')});
    await txn.wait();
    console.log("Minted domain poofdickle.betz")

    txn = await domainContract.setRecord("Poofdickle", "Is if poof or a dickle")
    await txn.wait();
    console.log("Set the record for Poofdickle")

   const address = await domainContract.getAddress("Poofdickle");
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