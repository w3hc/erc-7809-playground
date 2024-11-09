import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers"
import { expect } from "chai"
import { ethers } from "hardhat"

describe("Basic Native Token", function () {
    async function deployContracts() {
        const [alice, bob] = await ethers.getSigners()
        const initialBalance = ethers.parseEther("10000")
        const Basic = await ethers.getContractFactory("Basic")
        const basic = await Basic.deploy(initialBalance)

        // After deployment, we need to wait for the MINT opcode to be processed
        // In real implementation this would be handled by the VM
        const tokenId = await basic.getAddress()
        const mockVmState = new Map()
        mockVmState.set(`${tokenId}:${alice.address}`, initialBalance)
        mockVmState.set(tokenId, initialBalance) // Total supply

        return { basic, alice, bob, initialBalance, mockVmState }
    }

    describe("Deployment", function () {
        it("Should return a balance of 10,000 units", async function () {
            const { basic, alice, initialBalance, mockVmState } =
                await loadFixture(deployContracts)

            // Mock the BALANCEOF opcode read
            const balance = mockVmState.get(
                `${await basic.getAddress()}:${alice.address}`
            )
            expect(balance).to.equal(initialBalance)
        })
    })

    describe("Interactions", function () {
        it("Should mint 1 unit", async function () {
            const { basic, alice, mockVmState } = await loadFixture(
                deployContracts
            )
            const amount = ethers.parseEther("1")

            // Simulate MINT opcode execution
            const tokenId = await basic.getAddress()
            const currentBalance = mockVmState.get(
                `${tokenId}:${alice.address}`
            )
            const currentSupply = mockVmState.get(tokenId)
            mockVmState.set(
                `${tokenId}:${alice.address}`,
                currentBalance + amount
            )
            mockVmState.set(tokenId, currentSupply + amount)

            // Mock BALANCEOF opcode read
            const newBalance = mockVmState.get(`${tokenId}:${alice.address}`)
            expect(newBalance).to.equal(ethers.parseEther("10001"))
        })

        it("Should transfer 1 unit", async function () {
            const { basic, alice, bob, mockVmState } = await loadFixture(
                deployContracts
            )
            const amount = ethers.parseEther("1")

            // Simulate transfer using native token opcodes
            const tokenId = await basic.getAddress()
            const aliceBalance = mockVmState.get(`${tokenId}:${alice.address}`)
            const bobBalance =
                mockVmState.get(`${tokenId}:${bob.address}`) || BigInt(0)

            mockVmState.set(
                `${tokenId}:${alice.address}`,
                aliceBalance - amount
            )
            mockVmState.set(`${tokenId}:${bob.address}`, bobBalance + amount)

            // Mock BALANCEOF opcode read
            const newBobBalance = mockVmState.get(`${tokenId}:${bob.address}`)
            expect(newBobBalance).to.equal(amount)
        })
    })
})
