const { assert } = require('chai')

const contracts = artifacts.require('./Community.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('Community', ([deployer, author, tipper]) => {
  let Community

  before(async () => {
      console.log("hii");
    Community = await contracts.deployed()
  })

  describe('posts', async () => {
    
    it('allows users to tip posts', async () => {
      // Track the author balance before purchase
      let oldAuthorBalance
      oldAuthorBalance = await web3.eth.getBalance(author)
      oldAuthorBalance = new web3.utils.BN(oldAuthorBalance)

      result = await Community.sendViaTransfer(author, { from: tipper, value: web3.utils.toWei('1', 'Ether') })
      newAuthorBalance = await web3.eth.getBalance(author)


      
      assert.equal(newAuthorBalance.toString(),oldAuthorBalance.toString())
  

  })
})
})