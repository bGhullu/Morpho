const { ethers, getNamedAccounts, network } = require("hardhat")
const { getWeth, AMOUNT } = require("../scripts/getWeth.js")
const { networkConfig } = require("../helper-hardhat-config")

async function main() {
    await getWeth()
    const { deployer } = await getNamedAccounts()
    const Vault = await ethers.getContractFactory("Stoa")
    const vault = await Vault.deploy()
    await vault.deployed()
    const wethTokenAddress = networkConfig[network.config.chainId].wethToken
    approveErc20(wethTokenAddress, vault.address, AMOUNT, deployer)
    console.log("Depositing WETH...")

    await vault.supply(AMOUNT)

    console.log("Desposited!")
}

async function approveErc20(erc20Address, spenderAddress, amount, signer) {
    const erc20Token = await ethers.getContractAt("IERC20", erc20Address, signer)
    txResponse = await erc20Token.approve(spenderAddress, amount)
    await txResponse.wait(1)
    console.log("Approved!")
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
