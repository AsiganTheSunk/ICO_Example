
pragma solidity ^0.5.0;


import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract ICOCrowdSale {
    using SafeMath for uint256; 

    // Addresses for Owner & Wallet
    address public owner;
    address public ETHWallet;

    // ICOCroweSale Currency State
    ERC20 public ScamToken;
    bool private isFunding;
    bool public ICOCompleted;
    uint256 public tokenExchangeRate;
    uint256 public fundingGoal; 
    uint256 public heldTotal;
    uint256 public tokenAddress;
    uint256 public maxMintable;

    // Block INFO!
    uint256 public endBlock;
    uint256 public startBlock;

    modifier whenICOCompleted {
        require(ICOCompleted, 'error? SCM Token ICO Sale has been Completed!!');
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner,'error?');
        _;
    }

    mapping (address => uint256) public heldTokens;
    mapping (address => uint256) public heldTimeLine;

    event Contribution(address from, uint256 amount);
    event ReleaseToken(address from, uint256 amount);


    //constructor(uint256 _tokenExchangeRate, uint256 _fundingGoal, uint256 _tokenAddress) public {
    //    tokenExchangeRate = _tokenExchangeRate;
    //    fundingGoal = _fundingGoal;
    //    tokenAddress = _tokenAddress;
    //}


    function SaleToken(address _wallet) public {
        startBlock = block.number;
        maxMintable = 400000000000000000;
        ETHWallet = _wallet;
        isFunding = true;
        owner = msg.sender;
        createHeldCoins();
        tokenExchangeRate(600);
    }

    function closeICOSale() external {
        require(msg.sender == owner, 'Unable to close ICO Sale');
        isFunding = false;
    }

    // internal function that allocates a specific amount of TOKENS at a specific block number.
    // only ran 1 time on initialization
    function createHeldCoins() internal {
        // TOTAL SUPPLY = 5,000,000
        createHoldToken(msg.sender, 1000);
        createHoldToken(0x4f70Dc5Da5aCf5e71905c3a8473a6D8a7E7Ba4c5, 100000000000000000000000);
        createHoldToken(0x393c82c7Ae55B48775f4eCcd2523450d291f2418, 100000000000000000000000);
    }

    // public function to get the amount of tokens held for an address
    function getHeldCoin(address _address) public view returns (uint256) {
        return heldTokens[_address];
    }

    // function to create held tokens for developer
    function createHoldToken(address _to, uint256 amount) internal {
        heldTokens[_to] = amount;
        heldTimeLine[_to] = block.number + 0;
        heldTotal += amount;
        totalMinted += heldTotal;
    }

        // function to release held tokens for developers
    function releaseHeldCoins() external {
        uint256 held = heldTokens[msg.sender];
        uint heldBlock = heldTimeLine[msg.sender];
        require(!isFunding, '');
        require(held >= 0, '');
        require(block.number >= heldBlock, '');
        heldTokens[msg.sender] = 0;
        heldTimeLine[msg.sender] = 0;
        Token.mintToken(msg.sender, held);
        ReleaseTokens(msg.sender, held);
    }

    function contribute() external payable {
        require(msg.value > 0, '');
        require(isFunding, '');
        require(block.number <= endBlock, '');

    }


    function extractEther() public whenICOCompleted onlyOwner{
        //owner.Transfer(address(this).balance);
        return;
    }

}
