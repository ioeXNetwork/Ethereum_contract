pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
//
// Symbol      : IOEX
// Name        : internet of everything X
// Max Supply  : 200,000,000.00000000
// Decimals    : 8
//
//
// ----------------------------------------------------------------------------

contract owned {
    address public owner;

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

contract ioeX_TokenERC20 is owned{
    // Public variables of the token
    string public name="Internet of Everything X";
    string public symbol="IOEX";
    uint8 public decimals = 8;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;
          
    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    
    //Save 4 set of time and percent of unlocked tokens
    struct struct_lock_type{
      uint256[4] time;
      uint256[4] free_percent;
    }
    
    struct struct_lock_type_10{
      uint256[10] time;
      uint256[10] free_percent;
    }
    
    //Save lock type and amount of init tokens
    struct struct_lock_account_info{
      uint256 lock_type;
      uint256 init_balance;
    }
   
    struct_lock_type[6] lock_type;
    struct_lock_type_10 lock_type_7;
    
    mapping (address => struct_lock_account_info) public lock_account_info;
    
   
    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);
    
    // This generates a public event that record info about locked account, 
    //including amount of init tokens and lock type
    event Event_SetlockData(address indexed account, uint Initbalance, uint256 lock_type); 
   
   

    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function ioeX_TokenERC20() public {
        totalSupply = 200000000 * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
    
    //init all lock data    
    //Lock type 1
    lock_type[0].time[0]=1542297600;    //2018/11/16
    lock_type[0].free_percent[0]=35;    //35%
    lock_type[0].time[1]=1550246400;    //2019/02/16
    lock_type[0].free_percent[1]=35;    //35%
    lock_type[0].time[2]=1557936000;    //2019/05/16
    lock_type[0].free_percent[2]=30;    //30%
    lock_type[0].time[3]=0;             //nodata
    lock_type[0].free_percent[3]=0;     //nodata
    
    
    //Lock type 2
    lock_type[1].time[0]=1542297600;    //2018/11/16
    lock_type[1].free_percent[0]=25;    //25%
    lock_type[1].time[1]=1550246400;    //2019/02/16
    lock_type[1].free_percent[1]=25;    //25%
    lock_type[1].time[2]=1557936000;    //2019/05/16
    lock_type[1].free_percent[2]=25;    //25%
    lock_type[1].time[3]=1565884800;    //2019/08/16
    lock_type[1].free_percent[3]=25;    //25%
        
    //Lock type 3    
    lock_type[2].time[0]=1537027200;    //2018/09/16
    lock_type[2].free_percent[0]=25;    //25%
    lock_type[2].time[1]=1539619200;    //2018/10/16
    lock_type[2].free_percent[1]=25;    //25%
    lock_type[2].time[2]=1544889600;    //2018/12/16
    lock_type[2].free_percent[2]=25;    //25%
    lock_type[2].time[3]=1550246400;    //2019/02/16
    lock_type[2].free_percent[3]=25;    //25% 
    
    //Lock type 4
    lock_type[3].time[0]=1537027200;    //2018/09/16
    lock_type[3].free_percent[0]=40;    //40%
    lock_type[3].time[1]=1539619200;    //2018/10/16
    lock_type[3].free_percent[1]=20;    //20%
    lock_type[3].time[2]=1544889600;    //2018/12/16
    lock_type[3].free_percent[2]=20;    //20%
    lock_type[3].time[3]=1550246400;    //2019/02/16
    lock_type[3].free_percent[3]=20;    //20%
    
    //Lock type 5
    lock_type[4].time[0]=1537027200;    //2018/09/16
    lock_type[4].free_percent[0]=100;   //100%
    lock_type[4].time[1]=0;             //nodata
    lock_type[4].free_percent[1]=0;     //nodata
    lock_type[4].time[2]=0;             //nodata
    lock_type[4].free_percent[2]=0;     //nodata
    lock_type[4].time[3]=0;             //nodata
    lock_type[4].free_percent[3]=0;     //nodata
    
    //Lock type 6
    lock_type[5].time[0]=1550246400;    //2019/02/16
    lock_type[5].free_percent[0]=25;    //25%
    lock_type[5].time[1]=1565884800;    //2019/08/16
    lock_type[5].free_percent[1]=25;    //25%
    lock_type[5].time[2]=1581782400;    //2020/02/16
    lock_type[5].free_percent[2]=25;    //25%
    lock_type[5].time[3]=1597507200;    //2020/08/16
    lock_type[5].free_percent[3]=25;    //25% 
    
    //Lock type 7
    lock_type_7.time[0]=1542297600;    //2018/11/16 
    lock_type_7.free_percent[0]=10;    //10%
    lock_type_7.time[1]=1544889600;    //2018/12/16 
    lock_type_7.free_percent[1]=10;    //10%
    lock_type_7.time[2]=1547568000;    //2019/01/16 
    lock_type_7.free_percent[2]=10;    //10%
    lock_type_7.time[3]=1550246400;    //2019/02/16 
    lock_type_7.free_percent[3]=10;    //10%
    lock_type_7.time[4]=1552665600;    //2019/03/16 
    lock_type_7.free_percent[4]=10;    //10%
    lock_type_7.time[5]=1555344000;    //2019/04/16 
    lock_type_7.free_percent[5]=10;    //10%
    lock_type_7.time[6]=1557936000;    //2019/05/16 
    lock_type_7.free_percent[6]=10;    //10%
    lock_type_7.time[7]=1560614400;    //2019/06/16 
    lock_type_7.free_percent[7]=10;    //10%
    lock_type_7.time[8]=1563206400;    //2019/07/16 
    lock_type_7.free_percent[8]=10;    //10%
    lock_type_7.time[9]=1565884800;    //2019/08/16 
    lock_type_7.free_percent[9]=10;    //10%
     
    //init all lock data   
        
    }    
  
    /**
     * Calculate how much tokens must be locked
     * return the amount of locked tokens
     */
    function getlockBalance(address account) view internal returns(uint256) {    
        uint256 in_lock_type;
        uint256 result;
        uint256 result_free_percent;
        result=0;
        uint256 i;
        in_lock_type=lock_account_info[account].lock_type;
    
        if (in_lock_type>0){
            if (in_lock_type<=6){
              in_lock_type=in_lock_type-1;
              for (i=0;i<4;i++){
                if (lock_type[in_lock_type].time[i]> now){
                    result_free_percent=result_free_percent+lock_type[in_lock_type].free_percent[i];
                }
              }  
            }else
            if (in_lock_type==7){
              for (i=0;i<10;i++){
                if (lock_type_7.time[i]> now){
                  result_free_percent=result_free_percent+lock_type_7.free_percent[i];
                }
              
              }
            
            }         
        }        
        result=lock_account_info[account].init_balance*result_free_percent/100;
      
        return result;   
    }
    
 

    /**
     * Internal transfer, only can be called by this contract
     * Transfer toekns, and lock time and balance by select_type
     */
    function _transfer_forlock(address _from, address _to, uint _value,uint select_type)  internal{
        //check     
         require(select_type >=0);
         require(select_type <7);
         require( lock_account_info[_to].lock_type==0);
         require( lock_account_info[_to].init_balance==0);
       
         uint256 lock_balance;
         uint256 free_balance;
         lock_balance=getlockBalance(_from);
         free_balance=balanceOf[_from] - lock_balance;
         require(free_balance >= _value);            
        //check
        
        
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value > balanceOf[_to]);
        
        
        //write data     
        lock_account_info[_to].lock_type=select_type+1;
        lock_account_info[_to].init_balance=_value;
        emit Event_SetlockData(_to,_value, select_type+1);
        //write data
        
        
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);    
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
    
    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value)  internal{
        //check
        uint256 lock_balance;
        uint256 free_balance;
        lock_balance=getlockBalance(_from);
        free_balance=balanceOf[_from] - lock_balance;
        require(free_balance >= _value);      
        //check
       
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value > balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public {
         _transfer(msg.sender, _to, _value);
    }
   
   
    /**
     * Transfer tokens 
     * Lock time and token by lock_type 1                
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer_lock_balance_1(address _to, uint256 _value) onlyOwner public {       
        _transfer_forlock(msg.sender, _to, _value ,0);
    }
    
    /**
     * Transfer tokens 
     * Lock time and token by lock_type 2                
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer_lock_balance_2(address _to, uint256 _value) onlyOwner public {       
        _transfer_forlock(msg.sender, _to, _value ,1);
    }
    
    /**
     * Transfer tokens 
     * Lock time and token by lock_type 3                
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer_lock_balance_3(address _to, uint256 _value) onlyOwner public {       
        _transfer_forlock(msg.sender, _to, _value ,2);
    }
    
    /**
     * Transfer tokens 
     * Lock time and token by lock_type 4                
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer_lock_balance_4(address _to, uint256 _value) onlyOwner public {       
        _transfer_forlock(msg.sender, _to, _value ,3);
    }
    
    /**
     * Transfer tokens 
     * Lock time and token by lock_type 5                
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer_lock_balance_5(address _to, uint256 _value) onlyOwner public {       
        _transfer_forlock(msg.sender, _to, _value ,4);
    }
    
    /**
     * Transfer tokens 
     * Lock time and token by lock_type 6                
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer_lock_balance_6(address _to, uint256 _value) onlyOwner public {       
        _transfer_forlock(msg.sender, _to, _value ,5);
    }
    
    /**
     * Transfer tokens 
     * Lock time and token by lock_type 7                
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer_lock_balance_7(address _to, uint256 _value) onlyOwner public {       
        _transfer_forlock(msg.sender, _to, _value ,6);
    }
    
    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) onlyOwner public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

}
  
