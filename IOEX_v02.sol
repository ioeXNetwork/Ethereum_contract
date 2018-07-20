pragma solidity ^0.4.21;

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

    constructor() public {
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

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

contract TokenERC20 {
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 8;
    // 8 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    // This generates a public event on the blockchain that will notify clients
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);

    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    constructor(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
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
    function transfer(address _to, uint256 _value) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` in behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens in your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * Set allowance for other address and notify
     *
     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     * @param _extraData some extra information to send to the approved contract
     */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowance[_from][msg.sender]);    // Check allowance
        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        totalSupply -= _value;                              // Update totalSupply
        emit Burn(_from, _value);
        return true;
    }
}

/******************************************/
/*       ADVANCED TOKEN STARTS HERE       */
/******************************************/

contract MyAdvancedToken is owned, TokenERC20 {

    mapping (address => bool) public frozenAccount;

    /* This generates a public event on the blockchain that will notify clients */
    event FrozenFunds(address target, bool frozen);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}

    /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal {
        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
        require (balanceOf[_from] >= _value);               // Check if the sender has enough
        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        require(!frozenAccount[_from]);                     // Check if sender is frozen
        require(!frozenAccount[_to]);                       // Check if recipient is frozen
        balanceOf[_from] -= _value;                         // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        emit Transfer(_from, _to, _value);
    }

    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
    /// @param target Address to be frozen
    /// @param freeze either to freeze it or not
    function freezeAccount(address target, bool freeze) onlyOwner public {
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }
}

/******************************************/
/*              IOEX TOKEN                */
/******************************************/

contract IOEX is MyAdvancedToken {
    uint constant lockIndexMin = 1;
    uint constant lockIndexMax = 4;
    uint constant lockTypeMin = 1;
    uint constant lockTypeMax = 6;

    struct lockToken{
        uint lockdate;
        uint lockTokenBalance;
    }

    struct lockInfo{
        uint lockType;
        uint amount;
    }

    mapping(address => lockInfo) public lockInfos;
    mapping(address => mapping(uint => lockToken)) public lockTokens;
    
    event LockToken(address account, uint locktype, uint amount);

    constructor(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) MyAdvancedToken(initialSupply, tokenName, tokenSymbol) public {}

    function getLockBalance(address account) internal view returns(uint value) {
        uint lockBalance = 0;
        uint lockIndex = 1;
        uint currentTime = block.timestamp;

        while(lockTokens[account][lockIndex].lockdate != 0 && lockIndex <= lockIndexMax) {
            if(lockTokens[account][lockIndex].lockdate > currentTime) {
                lockBalance = lockBalance + lockTokens[account][lockIndex].lockTokenBalance;
            }
            lockIndex = lockIndex + 1;
        }
        
        return lockBalance;
    }

    /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal {
        uint usableBalance = balanceOf[_from] - getLockBalance(_from);
        
        require(balanceOf[_from] >= usableBalance);
        require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
        require(usableBalance >= _value);                   // Check if the sender has enough
        require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
        require(!frozenAccount[_from]);                     // Check if sender is frozen
        require(!frozenAccount[_to]);                       // Check if recipient is frozen

        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];

        balanceOf[_from] -= _value;                         // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        emit Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function lockTokenToDate(address account, uint index, uint amount, uint unixtime) onlyOwner public {
        require(index >= lockIndexMin);
        require(index <= lockIndexMax);
        require(unixtime >= lockTokens[account][index].lockdate);
        require(unixtime >= block.timestamp);

        lockTokens[account][index].lockdate = unixtime;
        lockTokens[account][index].lockTokenBalance = amount;
    }

    function lockTokenType(address account, uint locktype, uint amount) onlyOwner public returns (bool success){
        uint firstTime = 0;
        uint secondTime = 0;
        uint thirdTime = 0;
        uint fourthTime = 0;

        uint firstLockToken = 0;
        uint secondLockToken = 0;
        uint thirdLockToken = 0;
        uint fourthLockToken = 0;

        require(locktype >= lockTypeMin);
        require(locktype <= lockTypeMax);
        require(lockInfos[account].amount == 0);

        lockInfos[account].lockType = locktype;
        lockInfos[account].amount = amount;

        if(locktype == 1) {
            firstTime = 1542297600;     //2018-11-16
            secondTime = 1550246400;    //2019-02-16
            thirdTime = 1557936000;     //2019-05-16

            firstLockToken = amount * 35 / 100;
            secondLockToken = amount * 35 / 100;
            thirdLockToken = amount - firstLockToken - secondLockToken;

            lockTokenToDate(account, 1, firstLockToken, firstTime);
            lockTokenToDate(account, 2, secondLockToken, secondTime);
            lockTokenToDate(account, 3, thirdLockToken, thirdTime);
        }
        else if(locktype == 2) {
            firstTime = 1539619200;     //2018-10-16
            secondTime = 1544889600;    //2018-12-16
            thirdTime = 1550246400;     //2019-02-16
            fourthTime = 1555344000;    //2019-04-16

            firstLockToken = amount * 25 / 100;
            secondLockToken = amount * 25 / 100;
            thirdLockToken = amount * 25 / 100;
            fourthLockToken = amount - firstLockToken - secondLockToken - thirdLockToken;

            lockTokenToDate(account, 1, firstLockToken, firstTime);
            lockTokenToDate(account, 2, secondLockToken, secondTime);
            lockTokenToDate(account, 3, thirdLockToken, thirdTime);
            lockTokenToDate(account, 4, fourthLockToken, fourthTime);
        }
        else if(locktype == 3) {
            firstTime = 1537027200;     //2018-09-16
            secondTime = 1539619200;    //2018-10-16
            thirdTime = 1544889600;     //2018-12-16
            fourthTime = 1550246400;    //2019-02-16

            firstLockToken = amount * 25 / 100;
            secondLockToken = amount * 25 / 100;
            thirdLockToken = amount * 25 / 100;
            fourthLockToken = amount - firstLockToken - secondLockToken - thirdLockToken;

            lockTokenToDate(account, 1, firstLockToken, firstTime);
            lockTokenToDate(account, 2, secondLockToken, secondTime);
            lockTokenToDate(account, 3, thirdLockToken, thirdTime);
            lockTokenToDate(account, 4, fourthLockToken, fourthTime);
        }
        else if(locktype == 4) {
            firstTime = 1537027200;     //2018-09-16
            secondTime = 1539619200;    //2018-10-16
            thirdTime = 1544889600;     //2018-12-16
            fourthTime = 1550246400;    //2019-02-16

            firstLockToken = amount * 40 / 100;
            secondLockToken = amount * 20 / 100;
            thirdLockToken = amount * 20 / 100;
            fourthLockToken = amount - firstLockToken - secondLockToken - thirdLockToken;

            lockTokenToDate(account, 1, firstLockToken, firstTime);
            lockTokenToDate(account, 2, secondLockToken, secondTime);
            lockTokenToDate(account, 3, thirdLockToken, thirdTime);
            lockTokenToDate(account, 4, fourthLockToken, fourthTime);
        }
        else if(locktype == 5) {
            firstTime = 1537027200;     //2018-09-16

            firstLockToken = amount;

            lockTokenToDate(account, 1, firstLockToken, firstTime);
        }
        else {
            firstTime = 1550246400;     //2019-02-16
            secondTime = 1565884800;    //2019-08-16
            thirdTime = 1581782400;     //2020-02-16
            fourthTime = 1597507200;    //2020-08-16

            firstLockToken = amount * 25 / 100;
            secondLockToken = amount * 25 / 100;
            thirdLockToken = amount * 25 / 100;
            fourthLockToken = amount - firstLockToken - secondLockToken - thirdLockToken;

            lockTokenToDate(account, 1, firstLockToken, firstTime);
            lockTokenToDate(account, 2, secondLockToken, secondTime);
            lockTokenToDate(account, 3, thirdLockToken, thirdTime);
            lockTokenToDate(account, 4, fourthLockToken, fourthTime);
        }

        emit LockToken(account, locktype, amount);

        // Save this for an assertion in the future
        uint previousBalances = balanceOf[msg.sender] + balanceOf[account];

        balanceOf[msg.sender] -= amount;                         // Subtract from the sender
        balanceOf[account] += amount;                           // Add the same to the recipient
        emit Transfer(msg.sender, account, amount);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[msg.sender] + balanceOf[account] == previousBalances);

        return true;
    }

     /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) onlyOwner public returns (bool success) {
        uint usableBalance = balanceOf[msg.sender] - getLockBalance(msg.sender);
        require(balanceOf[msg.sender] >= usableBalance);
        require(usableBalance >= _value);           // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }
}
