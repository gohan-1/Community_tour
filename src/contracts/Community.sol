pragma solidity >=0.5.0 <0.9.0;

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract Community {
    uint public totalAmount;
    
    // minmum value to book a ticket 
    uint256 public minValue = 1000000000000000;

    address private owner;

    address[] public becomeInvestor;
    address[] public becomeDepty;
   
    
    mapping (address =>  mapping(address => uint)) public deptTableInvestor;
    mapping (address =>  mapping(address => uint) )public deptTableDepty;
  
   mapping(address => uint256 ) public totalOfDept;
   mapping(address=> uint256) public ListOfInvestment;

   mapping (address=>address[]) public listOfDepty;
   mapping (address=>address[]) public listOfInvestor;

   constructor() public{   
        owner=msg.sender;
    }
     
    // modifier function
     modifier onlyInvestor(address id){
        uint  counter=0;
         for (uint i=0;i<becomeInvestor.length;i++){
             if(becomeInvestor[i]==id){
                 counter=1;
             }

         }
         require(counter>0);
        _;
    }

   // modifier function
    modifier onlyDepty(address id){
        uint  counter=0;
         for (uint i=0;i<becomeDepty.length;i++){
             if(becomeDepty[i]==id){
                 counter=1;
             }

         }
         require(counter>0);
        _;
    }

    function deletFromDepty()public{
      uint remaining= totalOfDept[msg.sender];
        require(remaining==0);
        for(uint i=0;i<becomeDepty.length;i++){
            if(becomeDepty[i]==msg.sender){
                becomeDepty[i]=address(0);
            }
        }
    }
    // even he removed from investor he will get back ether he invested
     function deletFromInvestor()public{
     
        for(uint i=0;i<becomeInvestor.length;i++){
            if(becomeInvestor[i]==msg.sender){
                becomeInvestor[i]=address(0);
            }
        }
    }


    function repay(address _to) public payable onlyDepty(msg.sender){
        uint _amount = deptTableDepty[msg.sender][_to];
        // no money should be extra paid
        require(_amount>=msg.value);

        deptTableInvestor[_to][msg.sender]=deptTableInvestor[_to][msg.sender]-msg.value;

        deptTableDepty[msg.sender][_to]=deptTableDepty[msg.sender][_to]-msg.value;

        totalOfDept[msg.sender] = totalOfDept[msg.sender] - msg.value;

        ListOfInvestment[_to]=ListOfInvestment[_to]- msg.value;



    }
    

   function become_Investor(address _investor)  public{
       becomeInvestor.push(_investor);
   }

   function become_Depty(address _Depty) public{
       becomeDepty.push(_Depty);
   }


    function getOwner(
    ) public view returns (address) {    
        return owner;
    }
  
  
    // Function to return 
    // current balance of owner
    function getBalance(address person
    ) public view returns(uint256){
   
        return person.balance ;
                              
    }
    
    function getTotalAmountInvested(address _investor)  view public returns(uint256){
        
       return  ListOfInvestment[_investor];
       }

       
       
      
   
    
    
    function getDeptAmount(address _depty) view  public returns(uint256){
     

       
       return totalOfDept[_depty];
      
    }
    
     // any Investor can send money to any 
     function sendViaTransfer(address payable _to) public payable onlyInvestor(msg.sender) onlyDepty(_to){
         
         require(getBalance(owner)>minValue);
         require(msg.value>minValue);
         
         
        _to.transfer(msg.value);
        
        deptTableInvestor[msg.sender][_to]=deptTableInvestor[msg.sender][_to]+msg.value;

        deptTableDepty[_to][msg.sender]=deptTableDepty[_to][msg.sender]+msg.value;

        totalOfDept[_to] = totalOfDept[_to] + msg.value;

        ListOfInvestment[msg.sender]=ListOfInvestment[msg.sender]+msg.value;




       
        
        
    }
    
    
   
}
