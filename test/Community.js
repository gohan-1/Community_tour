const { assert } = require('chai')



const contracts = artifacts.require('./Community.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('Community', ([deployer,Investor,  Depty]) => {
  let Community
  let result;

  before(async () => {
     
    Community = await contracts.deployed()
    await Community.become_Investor(Investor)
    await Community.become_Depty(Depty)
  })

  describe('transfer', async () => {
    
    it('Money transfer', async () => {
      // Track the Investor balance before purchase
      let oldInvestorBalance
      oldInvestorBalance = await web3.eth.getBalance(Investor)
      oldInvestorBalance = new web3.utils.BN(oldInvestorBalance)

      result = await Community.sendViaTransfer(Depty, { from:Investor, value: web3.utils.toWei('1', 'Ether') })
      let newInvestorBalance = await web3.eth.getBalance(Depty)

      assert.notEqual(newInvestorBalance.toString(),oldInvestorBalance.toString())

  })
})

  describe('blance', async () => {
    
    it('balance of depty to payed', async () => {
      let tipAmount = web3.utils.toWei('1', 'Ether')

      // result = await Community.sendViaTransfer(Investor, { from:Depty, value: web3.utils.toWei('1', 'Ether') })
      let balance= await Community.getDeptAmount(Depty)

      assert.equal(balance,tipAmount)

  })
  it('balance of Investment to payed', async () => {
    let tipAmount = web3.utils.toWei('2', 'Ether')

    result = await Community.sendViaTransfer(Depty, { from:Investor, value: web3.utils.toWei('1', 'Ether') })
    let balance= await Community.getTotalAmountInvested(Investor)
     
    assert.equal(balance,tipAmount)

})
})

describe('repayment ', async () => {
    
  it('balance ', async () => {
    let tipAmount = web3.utils.toWei('1', 'Ether')

    result = await Community.repay(Investor, { from:Depty, value: web3.utils.toWei('1', 'Ether') })
    const balance=  await Community.getDeptAmount(Depty)

    assert.equal(balance , tipAmount)

})
})

})