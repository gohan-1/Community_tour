const { assert } = require('chai')



const contracts = artifacts.require('./CommunityTour.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('CommunityTour', ([deployer,Investor,  Depty]) => {
    let CommunityTour
    let result;

    before(async () => {
      
      CommunityTour = await contracts.deployed()
      await CommunityTour.become_Investor(Investor)
      await CommunityTour.become_Depty(Depty)
    })

    describe('transfer', async () => {
      
      it('Money transfer', async () => {
        // Track the Investor balance before purchase
        let oldInvestorBalance
        oldInvestorBalance = await web3.eth.getBalance(Investor)
        oldInvestorBalance = new web3.utils.BN(oldInvestorBalance)

        result = await CommunityTour.Transfer(Depty, { from:Investor, value: web3.utils.toWei('1', 'Ether') })
        let newInvestorBalance = await web3.eth.getBalance(Depty)

        assert.notEqual(newInvestorBalance.toString(),oldInvestorBalance.toString())

    })
  })

    describe('blance', async () => {
      
      it('balance of depty to payed', async () => {
        let tipAmount = web3.utils.toWei('1', 'Ether')

        // result = await CommunityTour.Transfer(Investor, { from:Depty, value: web3.utils.toWei('1', 'Ether') })
        let balance= await CommunityTour.getDeptAmount(Depty)

        assert.equal(balance,tipAmount)

    })
      it('balance of Investment ', async () => {
        let tipAmount = web3.utils.toWei('2', 'Ether')

        result = await CommunityTour.Transfer(Depty, { from:Investor, value: web3.utils.toWei('1', 'Ether') })
        let balance= await CommunityTour.getTotalAmountInvested(Investor)
        
        assert.equal(balance,tipAmount)

    })
  })

  describe('repayment ', async () => {
      
    it('balance ', async () => {
      let tipAmount = web3.utils.toWei('1', 'Ether')

      result = await CommunityTour.repay(Investor, { from:Depty, value: web3.utils.toWei('1', 'Ether') })
      const balance=  await CommunityTour.getDeptAmount(Depty)

      assert.equal(balance , tipAmount)

    })
  })

})