pragma solidity >=0.5.0 <0.9.0;

contract CommunityTour {
    uint public totalAmount;
    
    // minmum value to book a ticket 
    uint256 public minValue = 1000000000000000;

    address private owner;

    //these parties can only participate in transfer of ether
    address[] public becomeInvestor;
    address[] public becomeDepty;
   
    // for getting investor to depty relation usefull for front-end
    mapping (address =>  mapping(address => uint)) public deptTableInvestor;
    mapping (address =>  mapping(address => uint) )public deptTableDepty;
  
  //total amount of ether for both investor and user
   mapping(address => uint256 ) public totalOfDept;
   mapping(address=> uint256) public ListOfInvestment;


   //array of dependencies (1 to many)
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

    // ether return back to investor
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
    // current balance of person
    function getBalance(address person
    ) public view returns(uint256){
   
        return person.balance ;
                              
    }
    
    // get function to get the total amount
    function getTotalAmountInvested(address _investor)  view public returns(uint256){
        
       return  ListOfInvestment[_investor];
       }

       
       
      
   
    
    
    function getDeptAmount(address _depty) view  public returns(uint256){
     

       
       return totalOfDept[_depty];
      
    }
    
     // any Investor can send money to any Depty who is needed n number of time unless Depty hime self removed from Depty

     // even we can set limit amount of he wanted and even the preson can reject a particular transction before execution these things will need more time.
     //so not include in the project 
     function Transfer(address payable _to) public payable onlyInvestor(msg.sender) onlyDepty(_to){
         
         require(getBalance(owner)>minValue);
         require(msg.value>minValue);
         
         
        _to.transfer(msg.value);
        
        deptTableInvestor[msg.sender][_to]=deptTableInvestor[msg.sender][_to]+msg.value;

        deptTableDepty[_to][msg.sender]=deptTableDepty[_to][msg.sender]+msg.value;

        totalOfDept[_to] = totalOfDept[_to] + msg.value;

        ListOfInvestment[msg.sender]=ListOfInvestment[msg.sender]+msg.value;




       
        
        
    }
    
    
   
}
