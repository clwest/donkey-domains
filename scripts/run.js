const main = async () => {
    const [owner, superCoder] = await hre.ethers.getSigners();
    const domainContractFactory = await hre.ethers.getContractFactory("Domains");
    const domainContract = await domainContractFactory.deploy("betz");
    await domainContract.deployed()
    console.log("Contract owner: ", owner.address);

    let txn = await domainContract.register("Donkey", {value: hre.ethers.utils.parseEther('1234')});
    await txn.wait();
    console.log("Minted domain Donkey.betz")

   
    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance", hre.ethers.utils.formatEther(balance))

    try {
        txn = await domainContract.connect(superCoder).withdraw();
        await txn.wait()
    } catch(error){
        console.log("Could not rob contract")
    }

    let ownerBalance = await hre.ethers.provider.getBalance(owner.address)
    console.log("Balance of owner before withdraw: ", hre.ethers.utils.formatEther(ownerBalance))

    txn = await domainContract.connect(owner).withdraw();
    await txn.wait();

    const contractBalance = await hre.ethers.provider.getBalance(domainContract.address);
    ownerBalance = await hre.ethers.provider.getBalance(owner.address);

    console.log("Contract balance after withdraw:   ", hre.ethers.utils.formatEther(contractBalance));
    console.log("Balance of owner after withdraw:   ", hre.ethers.utils.formatEther(ownerBalance));
    
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
