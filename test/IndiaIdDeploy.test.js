const assert = require("assert");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());
const orgJson = artifacts.require("Organization")
const indJson = artifacts.require("IndiaId");
const perLib = artifacts.require("PersonLib");




contract("IndiaId", (accounts) => {
    let orgOwner;
    let orgContract;
    let indOwner;
    let indContract;
    it("Deploys Organization contract", async () => {
        orgOwner = accounts[0];
        orgJson.deployed().then(function(instance) {
            orgContract = instance
        })
    });
    it("Deploys IndiaId contract", async () => {
        indOwner = accounts[1];
        indContract = await indJson.new(orgContract.address, {from: indOwner});

        const val =  await indContract.iniOrgAddr();
        assert.equal(val, orgContract.address);

    })
    it("Add person to the country", async () => {
        let id = indContract.addPerson("0xABCDEF1234000000", "0x496e646961000000", {from: indOwner});
    })
    it("Get into auction", async () => {
        indContract.getIntoAuction(1);
    })
    it("Get Auction contract", async () => {
        let au = orgContract.getAuctionContractAddress(1);
        //au.bid({from:accounts[0], value: 1000000})
    })
    it("End the auction", async () => {
        indContract.endAuction();
    })
})