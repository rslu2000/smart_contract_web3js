pragma solidity ^0.4.11;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 * 擁有者和類別 包含轉移函數和 只限制擁有者調用合約的modifier, 被 Pausable 繼承,與貓的擁有者沒直接相關
 */
contract Ownable {
  address public owner;


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}



// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
/**
 * 採用 ERC721 token 的標準
 * ERC721 和 ERC20 不同 代表不可分割的代幣
 */
contract ERC721 {
    // Required methods
    function totalSupply() public view returns (uint256 total);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    function approve(address _to, uint256 _tokenId) external;
    function transfer(address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;

    // Events
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);

    // Optional
    // function name() public view returns (string name);
    // function symbol() public view returns (string symbol);
    // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
    // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);

    // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
    function supportsInterface(bytes4 _interfaceID) external view returns (bool);
}


// // Auction wrapper functions


// Auction wrapper functions







// @title SEKRETOOOO
contract GeneScienceInterface {
    // @dev simply a boolean to indicate this is the contract we expect to be
    function isGeneScience() public pure returns (bool);

    // @dev 交配函數
    // @param 當媽媽
    // @param 當爸爸
    // @return 返回應該屬於小孩的基因
    function mixGenes(uint256 genes1, uint256 genes2, uint256 targetBlock) public returns (uint256);
}







// @title A facet of KittyCore that manages special access privileges.
// @author Axiom Zen (https://www.axiomzen.co)
// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
contract KittyAccessControl {
    // This facet controls access control for CryptoKitties. There are four roles managed here:
    //
    //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
    //         contracts. It is also the only role that can unpause the smart contract. It is initially
    //         set to the address that created the smart contract in the KittyCore constructor.
    //
    //     - The CFO: The CFO can withdraw funds from KittyCore and its auction contracts.
    //
    //     - The COO: The COO can release gen0 kitties to auction, and mint promo cats.
    //
    // It should be noted that these roles are distinct without overlap in their access abilities, the
    // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
    // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
    // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
    // convenience. The less we use an address, the less likely it is that we somehow compromise the
    // account.

    // @dev Emited when contract is upgraded - See README.md for updgrade plan
    event ContractUpgrade(address newContract);

    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public ceoAddress;
    address public cfoAddress;
    address public cooAddress;

    // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
    bool public paused = false;

    // @dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }

    // @dev Access modifier for CFO-only functionality
    modifier onlyCFO() {
        require(msg.sender == cfoAddress);
        _;
    }

    // @dev Access modifier for COO-only functionality
    modifier onlyCOO() {
        require(msg.sender == cooAddress);
        _;
    }

    modifier onlyCLevel() {
        require(
            msg.sender == cooAddress ||
            msg.sender == ceoAddress ||
            msg.sender == cfoAddress
        );
        _;
    }

    // @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    // @param _newCEO The address of the new CEO
    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));

        ceoAddress = _newCEO;
    }

    // @dev Assigns a new address to act as the CFO. Only available to the current CEO.
    // @param _newCFO The address of the new CFO
    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0));

        cfoAddress = _newCFO;
    }

    // @dev Assigns a new address to act as the COO. Only available to the current CEO.
    // @param _newCOO The address of the new COO
    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0));

        cooAddress = _newCOO;
    }

    /*** Pausable functionality adapted from OpenZeppelin ***/

    // @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    // @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused);
        _;
    }

    /**
     * 暫停 只限制 CEO CFO CCO 使用
     */
    function pause() external onlyCLevel whenNotPaused {
        paused = true;
    }

    /**
     * 解除暫停 只限制 CEO 使用
     */
    function unpause() public onlyCEO whenPaused {
        // can't unpause if contract was upgraded
        paused = false;
    }
}




// @title Base contract for CryptoKitties. Holds all common structs, events and base variables.
// @author Axiom Zen (https://www.axiomzen.co)
// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
contract KittyBase is KittyAccessControl {
    /*** EVENTS ***/

    // 出生事件 包含 擁有者是誰 貓id 母貓id 公貓id 基因
    event Birth(address owner, uint256 kittyId, uint256 matronId, uint256 sireId, uint256 genes);

    // 轉移事件 轉移前擁有者帳號  轉移後擁有者帳號 token
    event Transfer(address from, address to, uint256 tokenId);

    /*** DATA TYPES ***/

    // @dev The main Kitty struct. Every cat in CryptoKitties is represented by a copy
    //  of this structure, so great care was taken to ensure that it fits neatly into
    //  exactly two 256-bit words. Note that the order of the members in this structure
    //  is important because of the byte-packing rules used by Ethereum.
    //  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
    struct Kitty {
        // 貓基因 格式是機密（黑盒子產生） 永不改變
        uint256 genes;

        // 貓生日- 出塊時間
        uint64 birthTime;

        // 貓何時可以再進行交配
        // 算法另外看 _triggerCooldown
        uint64 cooldownEndBlock;

        // 父母id gen0 為 0 ,貓總數最後收斂共產40億隻, 但以太坊限制 每年交易數 約5億 ,所以可以生好幾年沒問題
        uint32 matronId;
        uint32 sireId;

        // 懷孕時為交配公貓id,用於檢驗 本貓是不是正在懷孕 和檢驗出生小貓基因
        uint32 siringWithId;

        // 每次冷卻時間的參考值 每交配一次+1,初始值為 (floot) generation/2
        // 算法另外看 _triggerCooldown
        uint16 cooldownIndex;

        // 代表第幾代 取父母代數最大者+1 見 giveBirth函數
        uint16 generation;
    }

    /*** CONSTANTS ***/

    // @dev A lookup table indicating the cooldown duration after any successful
    //  breeding action, called "pregnancy time" for matrons and "siring cooldown"
    //  for sires. Designed such that the cooldown roughly doubles each time a cat
    //  is bred, encouraging owners not to just keep breeding the same cat over
    //  and over again. Caps out at one week (a cat can breed an unbounded number
    //  of times, and the maximum cooldown is always seven days).
    //查找表，顯示任何成功的育種行動之後的冷卻時間，被稱為“懷孕時間”為女性和“冷卻”為公胎。 
    //這種設計使得每次繁殖貓的冷卻時間大約增加一倍，鼓勵所有者不要一次又一次地繁殖相同的貓。 
    //在一個星期內封頂（一只貓可以繁殖無數次，最大的冷卻時間總是七天）
    // 算法另外看_triggerCooldown
    uint32[14] public cooldowns = [
        uint32(1 minutes),
        uint32(2 minutes),
        uint32(5 minutes),
        uint32(10 minutes),
        uint32(30 minutes),
        uint32(1 hours),
        uint32(2 hours),
        uint32(4 hours),
        uint32(8 hours),
        uint32(16 hours),
        uint32(1 days),
        uint32(2 days),
        uint32(4 days),
        uint32(7 days)
    ];

    // An approximation of currently how many seconds are in between blocks.
    // 當前近似塊之間有多少秒鐘
    uint256 public secondsPerBlock = 15;

    /*** STORAGE ***/

    // @dev 所有貓的結構,mapping key 就是貓id,但 id 0 是無效的,但gen0 的父母貓 id === 0 所以gen0 的父母id 為無效id(沒父母QQ)
    
    Kitty[] kitties;

    // @dev 貓的擁有者, 就算是 gen0 的貓 也有擁有者
    mapping (uint256 => address) public kittyIndexToOwner;

    // @dev A mapping from owner address to count of tokens that address owns.
    //  Used internally inside balanceOf() to resolve ownership count.
    // 從擁有者地址到地址所擁有的令牌數的對應。 在內部使用balanceOf（）來解決所有權計數。
    mapping (address => uint256) ownershipTokenCount;

    // @dev A mapping from KittyIDs to an address that has been approved to call
    //  transferFrom(). Each Kitty can only have one approved address for transfer
    //  at any time. A zero value means no approval is outstanding.
    // KittyID已被合法的調用transferFrom（）的地址的對應。 每個貓只能有一個喝法的地址轉移在任何時間。 零值表示不合法。
    mapping (uint256 => address) public kittyIndexToApproved;

    // @dev A mapping from KittyIDs to an address that has been approved to use
    //  this Kitty for siring via breedWith(). Each Kitty can only have one approved
    //  address for siring at any time. A zero value means no approval is outstanding.
    // KittyID到通過breedWith（）被合法的使用這個Kitty的地址的對應。 每個Kitty只能有一個合法的地址在任何時候發射。 零值表示不合法。
    mapping (uint256 => address) public sireAllowedToAddress;

    // @dev The address of the ClockAuction contract that handles sales of Kitties. This
    //  same contract handles both peer-to-peer sales as well as the gen0 sales which are
    //  initiated every 15 minutes.
    // 處理銷售Kitty的ClockAuction合約的地址。 同樣的合約處理對等銷售以及每15分鐘啟動的gen0銷售。
    SaleClockAuction public saleAuction;

    // @dev The address of a custom ClockAuction subclassed contract that handles siring
    //  auctions. Needs to be separate from saleAuction because the actions taken on success
    //  after a sales and siring auction are quite different.
    // 處理拍賣拍賣的自定義ClockAuction分類合約的地址。 需要從銷售中分離出來，因為在銷售和拍賣之後成功采取的行動是完全不同的。
    SiringClockAuction public siringAuction;

    // @dev 貓轉移的函數
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        // 擁有者貓(token)數+1
        ownershipTokenCount[_to]++;
        // 紀錄貓ID對應的擁有者
        kittyIndexToOwner[_tokenId] = _to;
        // When creating new kittens _from is 0x0, but we can't account that address.
        // 貓出生時 _from 為 0
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            // once the kitten is transferred also clear sire allowances
            delete sireAllowedToAddress[_tokenId];
            // clear any previously approved ownership exchange
            delete kittyIndexToApproved[_tokenId];
        }
        // 發出轉移事件
        Transfer(_from, _to, _tokenId);
    }

    // @dev An internal method that creates a new kitty and stores it. This
    //  method doesn't do any checking and should only be called when the
    //  input data is known to be valid. Will generate both a Birth event
    //  and a Transfer event.
    // 創建一個新的小貓並存儲它的內部方法。 此方法不執行任何檢查，只有在輸入數據已知有效時才應調用該方法。 將同時生成一個出生事件和轉移事件。
    // @param 母親ID ,0表示 小貓為第一代
    // @param 父親ID ,0表示 小貓為第一代
    // @param 貓第幾代,調用者計算
    // @param 貓基因
    // @param 貓最初主人(剛出生嘛), must be non-zero (except for the unKitty, ID 0)
    function _createKitty(
        uint256 _matronId,
        uint256 _sireId,
        uint256 _generation,
        uint256 _genes,
        address _owner
    )
        internal
        returns (uint)
    {
        // These requires are not strictly necessary, our calling code should make
        // sure that these conditions are never broken. However! _createKitty() is already
        // an expensive call (for storage), and it doesn't hurt to be especially careful
        // to ensure our data structures are always valid.
        // 這些要求不是絕對必要的，我們的調用代碼應該保證這些條件永遠不會被破壞。 
        // 然而！ _createKitty（）已經是一個昂貴的調用（用於存儲），並且特別小心確保我們的數據結構總是有效的。
        require(_matronId == uint256(uint32(_matronId)));
        require(_sireId == uint256(uint32(_sireId)));
        require(_generation == uint256(uint16(_generation)));

        // 新的小貓開始與父母gen / 2相同的冷卻時間
        uint16 cooldownIndex = uint16(_generation / 2);
        if (cooldownIndex > 13) {
            cooldownIndex = 13;
        }

        Kitty memory _kitty = Kitty({
            genes: _genes,
            birthTime: uint64(now), //現在這塊的時間戳
            cooldownEndBlock: 0, //貓何時可再交配
            matronId: uint32(_matronId), // 母親id
            sireId: uint32(_sireId), // 父親id
            siringWithId: 0, // 見前面說明
            cooldownIndex: cooldownIndex, //能再懷孕時間
            generation: uint16(_generation) //第幾代 見giveBrith
        });
        uint256 newKittenId = kitties.push(_kitty) - 1; //(出生後新貓數-1)

        // 不可能出錯,除非超過了4294967296 (在此限定了貓數為4294967296)
        require(newKittenId == uint256(uint32(newKittenId)));

        // 發出出生事件
        Birth(
            _owner,
            newKittenId,
            uint256(_kitty.matronId),
            uint256(_kitty.sireId),
            _kitty.genes
        );

        // 分配所有權 沒有前擁有者0 擁有者 貓id
        _transfer(0, _owner, newKittenId);
        
        //返回貓id
        return newKittenId;
    }

    // Any C-level can fix how many seconds per blocks are currently observed.
    // 設置每塊的秒數 只限制 CEO CFO CCO 使用
    // 算法另外看 _triggerCooldown
    function setSecondsPerBlock(uint256 secs) external onlyCLevel {
        // 限定一分鐘內
        require(secs < cooldowns[0]);
        secondsPerBlock = secs;
    }
}





// @title The external contract that is responsible for generating metadata for the kitties,
//  it has one function that will return the data as bytes.
// 負責為小貓產生元數據的外部合約，
//它有一個函數將以字節的形式返回數據。
contract ERC721Metadata {
    // @dev Given a token Id, returns a byte array that is supposed to be converted into string.
    // 給定一個令牌Id，返回一個應該被轉換成字符串的字節數組。
    function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
        if (_tokenId == 1) {
            buffer[0] = "Hello World! :D";
            count = 15;
        } else if (_tokenId == 2) {
            buffer[0] = "I would definitely choose a medi";
            buffer[1] = "um length string.";
            count = 49;
        } else if (_tokenId == 3) {
            buffer[0] = "Lorem ipsum dolor sit amet, mi e";
            buffer[1] = "st accumsan dapibus augue lorem,";
            buffer[2] = " tristique vestibulum id, libero";
            buffer[3] = " suscipit varius sapien aliquam.";
            count = 128;
        }
    }
}


// @title The facet of the CryptoKitties core contract that manages ownership, ERC-721 (draft) compliant.
// 管理所有權的CryptoKitties核心合約的方面，符合ERC-721（草案）。
// @author Axiom Zen (https://www.axiomzen.co)
// @dev Ref: https://github.com/ethereum/EIPs/issues/721
//  See the KittyCore contract documentation to understand how the various contract facets are arranged.
contract KittyOwnership is KittyBase, ERC721 {

    // @notice Name and symbol of the non fungible token, as defined in ERC721.
    // ERC721中定義的不可替代標記的名稱和符號。
    string public constant name = "CryptoKitties";
    string public constant symbol = "CK";

    // The contract that will return kitty metadata
    ERC721Metadata public erc721Metadata;

    bytes4 constant InterfaceSignature_ERC165 =
        bytes4(keccak256('supportsInterface(bytes4)'));

    bytes4 constant InterfaceSignature_ERC721 =
        bytes4(keccak256('name()')) ^
        bytes4(keccak256('symbol()')) ^
        bytes4(keccak256('totalSupply()')) ^
        bytes4(keccak256('balanceOf(address)')) ^
        bytes4(keccak256('ownerOf(uint256)')) ^
        bytes4(keccak256('approve(address,uint256)')) ^
        bytes4(keccak256('transfer(address,uint256)')) ^
        bytes4(keccak256('transferFrom(address,address,uint256)')) ^
        bytes4(keccak256('tokensOfOwner(address)')) ^
        bytes4(keccak256('tokenMetadata(uint256,string)'));

    // @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
    //  Returns true for any standardized interfaces implemented by this contract. We implement
    //  ERC-165 (obviously!) and ERC-721.
    function supportsInterface(bytes4 _interfaceID) external view returns (bool)
    {
        // DEBUG ONLY
        //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));

        return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
    }

    // @dev Set the address of the sibling contract that tracks metadata.
    //  設定 Metadata 合約地址 ,CEO only.
    function setMetadataAddress(address _contractAddress) public onlyCEO {
        erc721Metadata = ERC721Metadata(_contractAddress);
    }

    // Internal utility functions: These functions all assume that their input arguments
    // are valid. We leave it to public methods to sanitize their inputs and follow
    // the required logic.
    // 內部效用函數：這些函數都假定它們的輸入參數是有效的。 我們把它留給公眾的方法來消毒他們的投入，並遵循所需的邏輯。

    // / @dev Checks if a given address is the current owner of a particular Kitty.
    // / @param _claimant the address we are validating against.
    // / @param _tokenId kitten id, only valid when > 0
    // 檢查給定的地址是否是特定小貓的當前所有者。
    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return kittyIndexToOwner[_tokenId] == _claimant;
    }

    // @dev Checks if a given address currently has transferApproval for a particular Kitty.
    // @param _claimant the address we are confirming kitten is approved for.
    // @param _tokenId kitten id, only valid when > 0
    // 檢查一個給定的地址目前是否有transferApproval特定的Kitty
    function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return kittyIndexToApproved[_tokenId] == _claimant;
    }

    // @dev Marks an address as being approved for transferFrom(), overwriting any previous
    //  approval. Setting _approved to address(0) clears all transfer approval.
    //  NOTE: _approve() does NOT send the Approval event. This is intentional because
    //  _approve() and transferFrom() are used together for putting Kitties on auction, and
    //  there is no value in spamming the log with Approval events in that case.
    // 將地址標記為正在批準transferFrom（），覆蓋任何以前的批準。 設置_批準地址（0）會清除所有傳輸批準。 
    // 註意：_approve（）不會發送審批事件。 這是有意為之的，因為_approve（）和transferFrom（）一起用於將Kitty進行拍賣，
    // 在這種情況下，使用Approval事件發送日志時沒有任何價值。
    function _approve(uint256 _tokenId, address _approved) internal {
        kittyIndexToApproved[_tokenId] = _approved;
    }

    // @notice Returns the number of Kitties owned by a specific address.
    // @param _owner The owner address to check.
    // @dev Required for ERC-721 compliance
    // 通知返回特定地址擁有的Kitty的數量。
    function balanceOf(address _owner) public view returns (uint256 count) {
        return ownershipTokenCount[_owner];
    }

    // @notice Transfers a Kitty to another address. If transferring to a smart
    //  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
    //  CryptoKitties specifically) or your Kitty may be lost forever. Seriously.
    // @param _to The address of the recipient, can be a user or contract.
    // @param _tokenId The ID of the Kitty to transfer.
    // @dev Required for ERC-721 compliance.
    // @notice將凱蒂轉移到另一個地址。 如果轉移到一個智能合約非常小心，以確保它知道ERC-721（或CryptoKitties專門），否則你的小貓可能會永遠失去。認真。
    function transfer(
        address _to,
        uint256 _tokenId
    )
        external
        whenNotPaused
    {
        // 避免默認值0
        require(_to != address(0));
        // 防止誤用,確認轉移後擁有者不為當前合約地址
        require(_to != address(this));
        // 不允許轉讓給拍賣合約，以防止意外濫用。 拍賣合約只能通過允許+轉讓流程來獲得小貓的所有權。
        require(_to != address(saleAuction));
        require(_to != address(siringAuction));

        // 你只能送你自己的貓
        require(_owns(msg.sender, _tokenId));

        // 重新分配所有權，清除待批準，發出轉移事件。
        _transfer(msg.sender, _to, _tokenId);
    }

    // @notice Grant another address the right to transfer a specific Kitty via
    //  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
    // @param _to The address to be granted transfer approval. Pass address(0) to
    //  clear all approvals.
    // @param _tokenId The ID of the Kitty that can be transferred if this call succeeds.
    // @dev Required for ERC-721 compliance.
    // @notice授予另一個地址通過transferFrom（）轉移特定小貓的權利。 這是將NFT轉換為合約的首選流程。
    function approve(
        address _to,
        uint256 _tokenId
    )
        external
        whenNotPaused
    {
        // 確認是擁有者調用合約
        require(_owns(msg.sender, _tokenId));

        // 註冊批準（替換任何以前的批準）。
        _approve(_tokenId, _to);

        // Emit approval event.
        Approval(msg.sender, _to, _tokenId);
    }

    // @通知轉讓由另一個地址擁有的一個小貓，其主叫地址以前已經被所有者授予轉移批準。
    // @param _from The address that owns the Kitty to be transfered.
    // @param _to The address that should take ownership of the Kitty. Can be any address,
    //  including the caller.
    // @param _tokenId The ID of the Kitty to be transferred.
    // @dev Required for ERC-721 compliance.
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
        external
        whenNotPaused
    {
        // 避免默認值0
        require(_to != address(0));
        // 防止誤用,確認轉移後擁有者不為當前合約地址
        require(_to != address(this));
        // 檢查批準和有效的所有權
        require(_approvedFor(msg.sender, _tokenId));
        require(_owns(_from, _tokenId));

        // Reassign ownership (also clears pending approvals and emits Transfer event).
        _transfer(_from, _to, _tokenId);
    }

    // @notice Returns the total number of Kitties currently in existence.
    // @dev Required for ERC-721 compliance.
    // 返回當前存在的Kitty的總數。
    function totalSupply() public view returns (uint) {
        return kitties.length - 1;
    }

    // @notice Returns the address currently assigned ownership of a given Kitty.
    // @dev Required for ERC-721 compliance.
    // 返回貓id的擁有者
    function ownerOf(uint256 _tokenId)
        external
        view
        returns (address owner)
    {
        owner = kittyIndexToOwner[_tokenId];

        require(owner != address(0));
    }

    // @notice Returns a list of all Kitty IDs assigned to an address.
    // @param _owner The owner whose Kitties we are interested in.
    // @dev This method MUST NEVER be called by smart contract code. First, it's fairly
    //  expensive (it walks the entire Kitty array looking for cats belonging to owner),
    //  but it also returns a dynamic array, which is only supported for web3 calls, and
    //  not contract-to-contract calls.
    // 這個方法絕不能被智能合約代碼調用。 首先，它相當昂貴（它遍歷整個Kitty陣列尋找屬於所有者的貓），
    // 但它也返回一個動態數組，它只支持web3調用，而不支持合約到合約調用。
    // 返回擁有者地址的所有Kitty ID的列表。
    function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 totalCats = totalSupply();
            uint256 resultIndex = 0;

            // We count on the fact that all cats have IDs starting at 1 and increasing
            // sequentially up to the totalCat count.
            uint256 catId;

            for (catId = 1; catId <= totalCats; catId++) {
                if (kittyIndexToOwner[catId] == _owner) {
                    result[resultIndex] = catId;
                    resultIndex++;
                }
            }

            return result;
        }
    }

    // @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
    //  This method is licenced under the Apache License.
    //  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
    // memcpy（）改寫@arachnid（Nick Johnson <arachnid@notdot.net>）此方法根據Apache許可證進行許可。
    function _memcpy(uint _dest, uint _src, uint _len) private view {
        // Copy word-length chunks while possible
        for(; _len >= 32; _len -= 32) {
            assembly {
                mstore(_dest, mload(_src))
            }
            _dest += 32;
            _src += 32;
        }

        // Copy remaining bytes
        uint256 mask = 256 ** (32 - _len) - 1;
        assembly {
            let srcpart := and(mload(_src), not(mask))
            let destpart := and(mload(_dest), mask)
            mstore(_dest, or(destpart, srcpart))
        }
    }

    // @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
    //  This method is licenced under the Apache License.
    //  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
    //  toString(slice) @arachnid（Nick Johnson <arachnid@notdot.net>）此方法根據Apache許可證進行許可。
    function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
        var outputString = new string(_stringLength);
        uint256 outputPtr;
        uint256 bytesPtr;

        assembly {
            outputPtr := add(outputString, 32)
            bytesPtr := _rawBytes
        }

        _memcpy(outputPtr, bytesPtr, _stringLength);

        return outputString;
    }

    // @notice Returns a URI pointing to a metadata package for this token conforming to
    //  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
    // @param _tokenId The ID number of the Kitty whose metadata should be returned.
    // _tokenId應該返回元數據的Kitty的ID號。
    function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
        require(erc721Metadata != address(0));
        bytes32[4] memory buffer;
        uint256 count;
        (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);

        return _toString(buffer, count);
    }
}



// @title A facet of KittyCore that manages Kitty siring, gestation, and birth.
// @author Axiom Zen (https://www.axiomzen.co)
// @dev See the KittyCore contract documentation to understand how the various contract facets are arranged.
contract KittyBreeding is KittyOwnership {

    // @dev 當兩只貓成功繁殖並且懷孕定時器開始給女主人時，懷孕事件被解雇。
    // 擁有者, 母貓id ,公貓id , 冷卻塊號
    event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);

    // @notice The minimum payment required to use breedWithAuto(). This fee goes towards
    //  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
    //  the COO role as the gas price changes.
    // 使用breedWithAuto（）所需的最低支付。 這個費用是通過任何呼叫giveBirth（）支付的天然氣成本，並且可以隨著氣價的變化由COO角色動態更新。
    uint256 public autoBirthFee = 2 finney;

    // 跟蹤懷孕的小貓的數量。 詳見withdrawBalance
    uint256 public pregnantKitties;

    // @dev The address of the sibling contract that is used to implement the sooper-sekret
    //  genetic combination algorithm.
    // 兄弟合約的地址，用於實現超級機密基因組合算法。
    GeneScienceInterface public geneScience;

    // @dev Update the address of the genetic contract, can only be called by the CEO.
    // @param _address An address of a GeneScience contract instance to be used from this point forward.
    // 更新遺傳合約的地址，只能由CEO調用。
    function setGeneScienceAddress(address _address) external onlyCEO {
        GeneScienceInterface candidateContract = GeneScienceInterface(_address);

        // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
        require(candidateContract.isGeneScience());

        // Set the new contract address
        geneScience = candidateContract;
    }

    // @dev 檢查給定的小貓是否能繁殖。 要求目前的冷卻時間結束（對於公貓），並檢查是否有未決的懷孕。
    function _isReadyToBreed(Kitty _kit) internal view returns (bool) {
        // 除了檢查cooldownEndBlock，我們還需要檢查貓是否有未決的出生; 在懷孕計時器結束和出生事件之間可能有一段時間。
        return (_kit.siringWithId == 0) && (_kit.cooldownEndBlock <= uint64(block.number));
    }

    // @dev 檢查一個父親是否授權與這個女主人育種。 如果父親和女兒擁有同一個擁有者，
    // 或者父親已經（通過approveSiring（））給了女主人的擁有權，那麼這是真的。
    function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
        address matronOwner = kittyIndexToOwner[_matronId]; //母貓擁有者
        address sireOwner = kittyIndexToOwner[_sireId]; //公貓擁有者

        // 擁有者是同一人 || 已授權給母貓擁有者
        return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
    }

    // @dev 根據當前的冷卻指數，為給定的小貓設置冷卻時間。 也增加冷卻指數（除非它已經達到了上限）。
    // @param _kitten A reference to the Kitty in storage which needs its timer started.
    function _triggerCooldown(Kitty storage _kitten) internal {
        // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
        _kitten.cooldownEndBlock = uint64((cooldowns[_kitten.cooldownIndex]/secondsPerBlock) + block.number);

        // 增加繁殖計數，將它鎖定在冷卻時間長度為13的位置。 我們可以動態地檢查數組的大小，但是將其固定為一個常量可以節省燃氣。
        if (_kitten.cooldownIndex < 13) {
            _kitten.cooldownIndex += 1;
        }
    }

    // @notice Grants approval to another user to sire with one of your Kitties.
    // @param _addr The address that will be able to sire with your Kitty. Set to
    //  address(0) to clear all siring approvals for this Kitty.
    // @param _sireId A Kitty that you own that _addr will now be able to sire with.
    //  允許公貓讓 另一個擁有者交配
    function approveSiring(address _addr, uint256 _sireId)
        external
        whenNotPaused
    {
        require(_owns(msg.sender, _sireId));
        sireAllowedToAddress[_sireId] = _addr;
    }

    // @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
    //  be called by the COO address. (This fee is used to offset the gas cost incurred
    //  by the autobirth daemon).
    // 更新調用giveBirthAuto（）所需的最低支付金額。 只能由COO地址進行呼叫。 （這個費用是用來彌補由autobirth守護進程產生的氣體成本）。
    function setAutoBirthFee(uint256 val) external onlyCOO {
        autoBirthFee = val;
    }

    // @dev Checks to see if a given Kitty is pregnant and (if so) if the gestation
    //  period has passed.
    // 檢查是否有給定的小貓懷孕（如果是）懷孕期是否已經過去。
    function _isReadyToGiveBirth(Kitty _matron) private view returns (bool) {
        return (_matron.siringWithId != 0) && (_matron.cooldownEndBlock <= uint64(block.number));
    }

    // @notice 檢查一只給定的小貓是否能繁殖（即它沒有懷孕或在冷卻期間）。
    // @param _kittyId reference the id of the kitten, any user can inquire about it
    function isReadyToBreed(uint256 _kittyId)
        public
        view
        returns (bool)
    {
        require(_kittyId > 0);
        Kitty storage kit = kitties[_kittyId];
        return _isReadyToBreed(kit);
    }

    // @dev 檢查一只貓是否正在懷孕。
    // @param _kittyId reference the id of the kitten, any user can inquire about it
    function isPregnant(uint256 _kittyId)
        public
        view
        returns (bool)
    {
        //廢話？ 或是 id 0 的貓不能當母貓？
        require(_kittyId > 0);
        // A kitty is pregnant if and only if this field is set
        // 一只貓咪懷孕，當且僅當這個領域被設置
        return kitties[_kittyId].siringWithId != 0;
    }

    // @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
    //  check ownership permissions (that is up to the caller).
    // @param _matron A reference to the Kitty struct of the potential matron.
    // @param _matronId The matron's ID.
    // @param _sire A reference to the Kitty struct of the potential sire.
    // @param _sireId The sire's ID
    // 內部檢查，看看一個給定的父親和女人是一個有效的交配對。 不檢查所有權權限（由主叫方決定）。
    // 檢查合法配對, 準母貓結構,準母貓id,準公貓結構, 準公貓id
    function _isValidMatingPair(
        Kitty storage _matron,
        uint256 _matronId,
        Kitty storage _sire,
        uint256 _sireId
    )
        private
        view
        returns(bool)
    {
        // 不可以自我繁殖
        if (_matronId == _sireId) {
            return false;
        }

        // 不可以和父母亂倫
        if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
            return false;
        }
        if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
            return false;
        }

        // 如果任何一只貓的基因為零（女性ID為零），我們可以將兄弟姐妹檢查（見下文）短路。
        // gen0之間 可以繁殖
        if (_sire.matronId == 0 || _matron.matronId == 0) {
            return true;
        }

        // 兄弟姐妹不可以繁殖
        if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
            return false;
        }
        if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
            return false;
        }

        // Everything seems cool! Let's get DTF.
        return true;
    }

    // @dev Internal check to see if a given sire and matron are a valid mating pair for
    //  breeding via auction (i.e. skips ownership and siring approval checks).
    // 內部檢查，看看一個給定的父母和女主人是否是通過拍賣繁殖的有效交配對（即跳過所有權和登記核準檢查）。
    function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
        internal
        view
        returns (bool)
    {
        Kitty storage matron = kitties[_matronId];
        Kitty storage sire = kitties[_sireId];
        return _isValidMatingPair(matron, _matronId, sire, _sireId);
    }

    // @notice Checks to see if two cats can breed together, including checks for
    //  ownership and siring approvals. Does NOT check that both cats are ready for
    //  breeding (i.e. breedWith could still fail until the cooldowns are finished).
    //  TODO: Shouldn't this check pregnancy and cooldowns?!?
    // @param _matronId The ID of the proposed matron.
    // @param _sireId The ID of the proposed sire.
    // 檢查兩只貓是否可以一起繁殖，包括檢查所有權和審批。 不檢查兩只貓是否準備好繁殖
    //（即，只有在冷卻時間結束時，犬只仍然可能失敗）。 TODO：這不應該檢查懷孕和冷卻？
    function canBreedWith(uint256 _matronId, uint256 _sireId)
        external
        view
        returns(bool)
    {
        require(_matronId > 0);
        require(_sireId > 0);
        Kitty storage matron = kitties[_matronId];
        Kitty storage sire = kitties[_sireId];

        // 貓血親合法&&擁有者合法
        return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
            _isSiringPermitted(_sireId, _matronId);
    }

    // @dev Internal utility function to initiate breeding, assumes that all breeding
    //  requirements have been checked.
    // 啟動育種的內部效用函數假設所有育種要求都已經過檢查。
    function _breedWith(uint256 _matronId, uint256 _sireId) internal {
        // Grab a reference to the Kitties from storage.
        Kitty storage sire = kitties[_sireId];
        Kitty storage matron = kitties[_matronId];

        // Mark the matron as pregnant, keeping track of who the sire is.
        matron.siringWithId = uint32(_sireId);

        // 增加冷卻時間
        _triggerCooldown(sire);
        _triggerCooldown(matron);

        // Clear siring permission for both parents. This may not be strictly necessary
        // but it's likely to avoid confusion!
        // 明確父母雙方的許可。 這可能不是絕對必要的，但可能會避免混淆！
        delete sireAllowedToAddress[_matronId];
        delete sireAllowedToAddress[_sireId];

        // 當一只貓咪懷孕，計數器增加。
        pregnantKitties++;

        // Emit the pregnancy event.
        // 發出懷孕事件
        Pregnant(kittyIndexToOwner[_matronId], _matronId, _sireId, matron.cooldownEndBlock);
    }

    // @notice Breed a Kitty you own (as matron) with a sire that you own, or for which you
    //  have previously been given Siring approval. Will either make your cat pregnant, or will
    //  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
    // @param _matronId The ID of the Kitty acting as matron (will end up pregnant if successful)
    // @param _sireId The ID of the Kitty acting as sire (will begin its siring cooldown if successful)
    // 培育出一個你擁有的（作為女僕）擁有的，或者你曾經獲得批準的陛下的小貓。 
    // 要麼讓你的貓懷孕，要麼完全失敗。 要求預先支付給giveBirth（）的第一個調用者的費用
    function breedWithAuto(uint256 _matronId, uint256 _sireId)
        external
        payable
        whenNotPaused
    {
        // 檢查付款 交配費要大於 autoBirthFee
        require(msg.value >= autoBirthFee);

        // Caller must own the matron.
        require(_owns(msg.sender, _matronId));

        // Neither sire nor matron are allowed to be on auction during a normal
        // breeding operation, but we don't need to check that explicitly.
        // For matron: The caller of this function can't be the owner of the matron
        //   because the owner of a Kitty on auction is the auction house, and the
        //   auction house will never call breedWith().
        // For sire: Similarly, a sire on auction will be owned by the auction house
        //   and the act of transferring ownership will have cleared any oustanding
        //   siring approval.
        // Thus we don't need to spend gas explicitly checking to see if either cat
        // is on auction.
        // 在正常的育種過程中，不得陛下和女僕拍賣，但我們不需要明確檢查。 
        // 對於女主人：這個功能的來電者不能成為女主人的主人，因為拍賣的小貓的主人是拍賣行，
        // 拍賣行絕對不會把品種叫做（）。 對於父親：同樣，拍賣的父親將由拍賣行擁有，
        // 轉讓所有權的行為將清除任何直接的拍賣批準。 
        // 因此，我們不需要花費氣體明確檢查是否有任何一只貓在拍賣。

        // Check that matron and sire are both owned by caller, or that the sire
        // has given siring permission to caller (i.e. matron's owner).
        // Will fail for _sireId = 0
        // 檢查主管和陛下是否都是主叫方所有，或者父親是否已經給主叫方（即女主人的主人）許可。 將失敗_sireId = 0
        require(_isSiringPermitted(_sireId, _matronId));

        // Grab a reference to the potential matron
        Kitty storage matron = kitties[_matronId];

        // 母貓準備好交配
        require(_isReadyToBreed(matron));

        // Grab a reference to the potential sire
        Kitty storage sire = kitties[_sireId];

        // 公貓準備好交配
        require(_isReadyToBreed(sire));

        // 測試 合法交配
        require(_isValidMatingPair(
            matron,
            _matronId,
            sire,
            _sireId
        ));

        // All checks passed, kitty gets pregnant!
        _breedWith(_matronId, _sireId);
    }

    // @notice Have a pregnant Kitty give birth!
    // @param _matronId A Kitty ready to give birth.
    // @return The Kitty ID of the new kitten.
    // @dev Looks at a given Kitty and, if pregnant and if the gestation period has passed,
    //  combines the genes of the two parents to create a new kitten. The new Kitty is assigned
    //  to the current owner of the matron. Upon successful completion, both the matron and the
    //  new kitten will be ready to breed again. Note that anyone can call this function (if they
    //  are willing to pay the gas!), but the new kitten always goes to the mother's owner.
    // 有一個懷孕的小貓生下一個！
    // 看一個給定的貓，如果懷孕，如果妊娠期已經過去，結合兩個家長的基因，以創建一個新的小貓。 
    // 新的凱蒂分配給現任的女主人。 成功完成後，女主人和新的小貓將準備再次繁殖。 
    // 請註意，任何人都可以調用這個函數（如果他們願意付錢的話），但新的小貓總是去找母親的主人。
    function giveBirth(uint256 _matronId)
        external
        whenNotPaused
        returns(uint256)
    {
        // Grab a reference to the matron in storage.
        Kitty storage matron = kitties[_matronId];

        // 檢查母貓結構是否有效。
        require(matron.birthTime != 0);

        // 檢查是否懷孕且已達預產期
        require(_isReadyToGiveBirth(matron));

        // 找孩子的爸
        uint256 sireId = matron.siringWithId;
        Kitty storage sire = kitties[sireId];

        // 確定兩個父母的上一代人數
        uint16 parentGen = matron.generation;
        if (sire.generation > matron.generation) {
            parentGen = sire.generation;
        }

        // 稱為超級機密基因混合操作。黑盒子
        uint256 childGenes = geneScience.mixGenes(matron.genes, sire.genes, matron.cooldownEndBlock - 1);

        // 產生新的貓
        address owner = kittyIndexToOwner[_matronId];
        uint256 kittenId = _createKitty(_matronId, matron.siringWithId, parentGen + 1, childGenes, owner);

        // 清除懷孕狀態
        delete matron.siringWithId;

        // 每當一只貓咪生下計數器就會減少。
        pregnantKitties--;

        // 費用發生給調用者
        msg.sender.send(autoBirthFee);

        // return the new kitten's ID
        return kittenId;
    }
}










// @title Auction Core 荷蘭式拍賣
// @dev Contains models, variables, and internal methods for the auction.
// @notice We omit a fallback function to prevent accidental sends to this contract.
// 包含拍賣的模型，變量和內部方法。
// 我們省略了後備功能，以防止意外發送到本合約。
contract ClockAuctionBase {

    // 代表NFT(no fixed time 无固定时间)拍賣
    struct Auction {
        // NFT的當前所有者
        address seller;
        // 價格(wei)在拍賣開始時
        uint128 startingPrice;
        // 拍賣結束時的價格
        uint128 endingPrice;
        // 拍賣時間（以秒為單位）
        uint64 duration;
        // 拍賣開始的時間
        // NOTE: 如果本次拍賣已經結束，則為0
        uint64 startedAt;
    }

    // 參考合約跟蹤NFT所有權 //不可互換合約？
    ERC721 public nonFungibleContract;

    // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
    // Values 0-10,000 map to 0%-100%
    // 削減業主承擔每次拍賣，以基點（1/100百分比）衡量。
    // 見 _computeCut 和 ClockAuction 方法
    uint256 public ownerCut; 

    // Map from token ID to their corresponding auction.
    // 從令牌ID對應到相應的拍賣。
    mapping (uint256 => Auction) tokenIdToAuction;

    //事件：拍賣 建立 完成 取消
    event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
    event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
    event AuctionCancelled(uint256 tokenId);

    // @dev Returns true if the claimant owns the token.
    // @param _claimant - Address claiming to own the token.
    // @param _tokenId - ID of token whose ownership to verify.
    // 如果索賠人擁有該token，則返回true。
    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
    }

    // @dev Escrows the NFT, assigning ownership to this contract.
    // Throws if the escrow fails.
    // @param _owner - Current owner address of token to escrow.
    // @param _tokenId - ID of token whose approval to verify.
    // 托管NFT，為此合約分配所有權。 如果托管失敗，則falis。
    // 將貓的所有權從擁有者轉移到拍賣合約
    function _escrow(address _owner, uint256 _tokenId) internal {
        // 如果傳輸失敗，它會falis
        nonFungibleContract.transferFrom(_owner, this, _tokenId);
    }

    // @dev Transfers an NFT owned by this contract to another address.
    // Returns true if the transfer succeeds.
    // @param _receiver - Address to transfer NFT to.
    // @param _tokenId - ID of token to transfer.
    // 將本合約所有的NFT轉移到另一個地址。如果轉移成功，則返回true。
    function _transfer(address _receiver, uint256 _tokenId) internal {
        // it will throw if transfer fails
        nonFungibleContract.transfer(_receiver, _tokenId);
    }

    // @dev Adds an auction to the list of open auctions. Also fires the
    //  AuctionCreated event.
    // @param _tokenId The ID of the token to be put on auction.
    // @param _auction Auction to add.
    // 將拍賣添加到公開競價的列表中。 還會觸發AuctionCreated事件。
    function _addAuction(uint256 _tokenId, Auction _auction) internal {
        // Require that all auctions have a duration of
        // at least one minute. (Keeps our math from getting hairy!)
        // 要求所有拍賣的持續時間至少為一分鐘。 （讓我們的數學變得毛茸茸的！）
        require(_auction.duration >= 1 minutes);

        tokenIdToAuction[_tokenId] = _auction;

        AuctionCreated(
            uint256(_tokenId),
            uint256(_auction.startingPrice),
            uint256(_auction.endingPrice),
            uint256(_auction.duration)
        );
    }

    // @dev Cancels an auction unconditionally.
    // 無條件取消拍賣。
    function _cancelAuction(uint256 _tokenId, address _seller) internal {
        _removeAuction(_tokenId);
        _transfer(_seller, _tokenId);
        AuctionCancelled(_tokenId);
    }

    // @dev Computes the price and transfers winnings.
    // Does NOT transfer ownership of token.
    // 計算價格並轉移獎金。不轉讓令牌的所有權。
    function _bid(uint256 _tokenId, uint256 _bidAmount)
        internal
        returns (uint256)
    {
        // 獲取對拍賣結構的參考
        Auction storage auction = tokenIdToAuction[_tokenId];

        // Explicitly check that this auction is currently live.
        // (Because of how Ethereum mappings work, we can't just count
        // on the lookup above failing. An invalid _tokenId will just
        // return an auction object that is all zeros.)
        // 明確檢查這次拍賣是否現在。 （因為以太坊對應是如何工作的，所以我們不能只依靠上面的查找失敗。一個無效的_tokenId只會返回一個全為零的拍賣對象。
        require(_isOnAuction(auction));

        // 檢查出價是否大於或等於當前價格
        uint256 price = _currentPrice(auction);
        require(_bidAmount >= price);

        // 在拍賣結構被刪除之前抓取賣家的參考。
        address seller = auction.seller;

        // The bid is good! Remove the auction before sending the fees
        // to the sender so we can't have a reentrancy attack.
        // 出價很好！ 在將費用發送給發件人之前取消拍賣，這樣我們就不會有重入式的攻擊。
        _removeAuction(_tokenId);

        // 轉移到賣方（如果有的話）！
        if (price > 0) {
            // Calculate the auctioneer's cut.
            // (NOTE: _computeCut() is guaranteed to return a
            // value <= price, so this subtraction can't go negative.)
            // 計算拍賣人的剪輯。  （注意：_computeCut（）保證返回一個<=價格的值，所以這個減法不能為負數。）
            uint256 auctioneerCut = _computeCut(price);
            uint256 sellerProceeds = price - auctioneerCut;

            // NOTE: Doing a transfer() in the middle of a complex
            // method like this is generally discouraged because of
            // reentrancy attacks and DoS attacks if the seller is
            // a contract with an invalid fallback function. We explicitly
            // guard against reentrancy attacks by removing the auction
            // before calling transfer(), and the only thing the seller
            // can DoS is the sale of their own asset! (And if it's an
            // accident, they can call cancelAuction(). )
            // 註意：如果在這種覆雜方法的中間執行transfer（），通常會因為重入攻擊和DoS攻擊而受到阻礙，
            // 如果賣方是具有無效回退函數的合約。 我們在調用transfer（）之前通過去除拍賣來明確地防止重入攻擊，
            // 而賣方可以拒絕的唯一的事情就是出售他們自己的資產！ （如果這是一個意外，他們可以調用cancelAuction（）。）
            seller.transfer(sellerProceeds);
        }

        // Calculate any excess funds included with the bid. If the excess
        // is anything worth worrying about, transfer it back to bidder.
        // NOTE: We checked above that the bid amount is greater than or
        // equal to the price so this cannot underflow.
        // 計算出價中包含的任何超額資金。 如果多余的東西值得擔心，
        // 將其轉回投標人。 註：我們上面檢查出價金額大於或等於價格，所以這不能下溢。

        //多付的錢還給出價人
        uint256 bidExcess = _bidAmount - price;

        // Return the funds. Similar to the previous transfer, this is
        // not susceptible to a re-entry attack because the auction is
        // removed before any transfers occur.
        // 退還資金。 與之前的轉讓類似，這是不容易的重入攻擊，因為拍賣在任何轉移發生之前被刪除。
        msg.sender.transfer(bidExcess);

        // Tell the world!
        AuctionSuccessful(_tokenId, price, msg.sender);

        return price;
    }

    // @dev Removes an auction from the list of open auctions.
    // @param _tokenId - ID of NFT on auction.
    // 從公開競價清單中刪除拍賣。
    function _removeAuction(uint256 _tokenId) internal {
        delete tokenIdToAuction[_tokenId];
    }

    // @dev Returns true if the NFT is on auction.
    // @param _auction - Auction to check.
    // 如果NFT處於拍賣狀態，則返回true。
    function _isOnAuction(Auction storage _auction) internal view returns (bool) {
        return (_auction.startedAt > 0);
    }

    // @dev Returns current price of an NFT on auction. Broken into two
    //  functions (this one, that computes the duration from the auction
    //  structure, and the other that does the price computation) so we
    //  can easily test that the price computation works correctly.
    // 在拍賣中返回NFT的當前價格。 分為兩個函數（這一個計算從拍賣結構
    // 到另一個價格計算的持續時間），所以我們可以很容易地測試價格計算是否正常工作。
    function _currentPrice(Auction storage _auction)
        internal
        view
        returns (uint256)
    {
        uint256 secondsPassed = 0;

        // A bit of insurance against negative values (or wraparound).
        // Probably not necessary (since Ethereum guarnatees that the
        // now variable doesn't ever go backwards).
        // 一些抵消負面價值（或環繞）的保險。 可能不必要（因為以太坊保證現在變量不會倒退）。
        if (now > _auction.startedAt) {
            secondsPassed = now - _auction.startedAt;
        }

        return _computeCurrentPrice(
            _auction.startingPrice,
            _auction.endingPrice,
            _auction.duration,
            secondsPassed
        );
    }

    // @dev Computes the current price of an auction. Factored out
    //  from _currentPrice so we can run extensive unit tests.
    //  When testing, make this function public and turn on
    //  `Current price computation` test suite.
    // 計算拍賣的當前價格。 從_currentPrice出來，所以我們可以運行大量的單元測試。 在測試時，公開這個函數，並打開`當前價格計算`測試套件。
    function _computeCurrentPrice(
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        uint256 _secondsPassed
    )
        internal
        pure
        returns (uint256)
    {
        // NOTE: We don't use SafeMath (or similar) in this function because
        //  all of our public functions carefully cap the maximum values for
        //  time (at 64-bits) and currency (at 128-bits). _duration is
        //  also known to be non-zero (see the require() statement in
        //  _addAuction())
        // 我们在这个函数中不使用SafeMath（或类似的），因为我们所有的公共函数
        // 都小心地限制了时间（64位）和货币（128位）的最大值。 _duration也被称为非零（参见_addAuction（）中的require（）语句）
        if (_secondsPassed >= _duration) {
            // We've reached the end of the dynamic pricing portion
            // of the auction, just return the end price.
            // 我们已经到了拍卖的动态定价部分的末尾，只是返回最终价格。
            return _endingPrice;
        } else {
            //當前價格 隨時間呈線性變化 ,而不是出價出到哪裡了

            // Starting price can be higher than ending price (and often is!), so
            // this delta can be negative.
            // 起始价可以比结束价格较高（通常是！），因此此增量可以是负数。
            int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);

            // This multiplication can't overflow, _secondsPassed will easily fit within
            // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
            // will always fit within 256-bits.
            // 这个乘法不能溢出，_secondsPassed很容易放在64位内，totalPriceChange很容易放在128位内，它们的产品总是在256位内。
            int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);

            // currentPriceChange can be negative, but if so, will have a magnitude
            // less that _startingPrice. Thus, this result will always end up positive.
            // currentPriceChange可以是负数，但是如果是这样的话，将会有一个小于_startingPrice的数量级。 因此，这个结果总是以积极的方式结束。
            int256 currentPrice = int256(_startingPrice) + currentPriceChange;

            return uint256(currentPrice);
        }
    }

    // @dev Computes owner's cut of a sale.
    // @param _price - Sale price of NFT.
    // 計算出售者的獲利？
    function _computeCut(uint256 _price) internal view returns (uint256) {
        // NOTE: We don't use SafeMath (or similar) in this function because
        //  all of our entry functions carefully cap the maximum values for
        //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
        //  statement in the ClockAuction constructor). The result of this
        //  function is always guaranteed to be <= _price.
        // 我们在这个函数中不使用SafeMath（或者类似的），因为我们所有的入口函数
        // 都仔细地限制了货币的最大值（128位）和ownerCut <= 10000（参见ClockAuction构造函数中的require（）语句）。 
        // 这个函数的结果始终保证是<= _price。
        return _price * ownerCut / 10000;
    }

}







/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 * 基地合同允许儿童实施紧急停止机制。
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev modifier to allow actions only when the contract IS paused
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev modifier to allow actions only when the contract IS NOT paused
   */
  modifier whenPaused {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused returns (bool) {
    paused = true;
    Pause();
    return true;
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused returns (bool) {
    paused = false;
    Unpause();
    return true;
  }
}


// @title Clock auction for non-fungible tokens.
// @notice We omit a fallback function to prevent accidental sends to this contract.
// 不可替代令牌的荷蘭式拍賣。
// 我们省略了后备功能，以防止意外发送到本合同。
contract ClockAuction is Pausable, ClockAuctionBase {

    // @dev The ERC-165 interface signature for ERC-721.
    //  Ref: https://github.com/ethereum/EIPs/issues/165
    //  Ref: https://github.com/ethereum/EIPs/issues/721
    // ERC-721的ERC-165接口签名。
    bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);

    // @dev Constructor creates a reference to the NFT ownership contract
    //  and verifies the owner cut is in the valid range.
    // @param _nftAddress - address of a deployed contract implementing
    //  the Nonfungible Interface.
    // @param _cut - percent cut the owner takes on each auction, must be
    //  between 0-10,000.
    // 构造函数创建对NFT所有权合同的引用，并验证所有者剪切是否在有效范围内。
    function ClockAuction(address _nftAddress, uint256 _cut) public {
        require(_cut <= 10000);
        ownerCut = _cut;

        ERC721 candidateContract = ERC721(_nftAddress);
        require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
        nonFungibleContract = candidateContract;
    }

    // @dev Remove all Ether from the contract, which is the owner's cuts
    //  as well as any Ether sent directly to the contract address.
    //  Always transfers to the NFT contract, but can be called either by
    //  the owner or the NFT contract.
    // 从合同中删除所有的ether，这是业主的削减，以及任何乙醚直接发送到合同地址。 始终转移到NFT合同，但可以由所有者或NFT合同调用。
    function withdrawBalance() external {
        address nftAddress = address(nonFungibleContract);

        require(
            msg.sender == owner ||
            msg.sender == nftAddress
        );
        // We are using this boolean method to make sure that even if one fails it will still work
        bool res = nftAddress.send(this.balance);
    }

    // @dev Creates and begins a new auction.
    // @param _tokenId - ID of token to auction, sender must be owner.
    // @param _startingPrice - Price of item (in wei) at beginning of auction.
    // @param _endingPrice - Price of item (in wei) at end of auction.
    // @param _duration - Length of time to move between starting
    //  price and ending price (in seconds).
    // @param _seller - Seller, if not the message sender
    // 创建并开始新的拍卖。
    function createAuction(
        uint256 _tokenId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        address _seller
    )
        external
        whenNotPaused
    {
        // Sanity check that no inputs overflow how many bits we've allocated
        // to store them in the auction struct.
        // 完整性检查没有输入溢出我们已经分配将它们存储在拍卖结构中的多少位。
        require(_startingPrice == uint256(uint128(_startingPrice)));
        require(_endingPrice == uint256(uint128(_endingPrice)));
        require(_duration == uint256(uint64(_duration)));

        require(_owns(msg.sender, _tokenId));
        _escrow(msg.sender, _tokenId);
        Auction memory auction = Auction(
            _seller,
            uint128(_startingPrice),
            uint128(_endingPrice),
            uint64(_duration),
            uint64(now)
        );
        _addAuction(_tokenId, auction);
    }

    // @dev Bids on an open auction, completing the auction and transferring
    //  ownership of the NFT if enough Ether is supplied.
    // @param _tokenId - ID of token to bid on.
    // 投标公开拍卖，完成拍卖和转让NFT的所有权，如果足够的乙醚供应。
    function bid(uint256 _tokenId)
        external
        payable
        whenNotPaused
    {
        // _bid will throw if the bid or funds transfer fails
        // 如果投标或资金转移失败，投标将被抛出
        _bid(_tokenId, msg.value);
        _transfer(msg.sender, _tokenId);
    }

    // @dev Cancels an auction that hasn't been won yet.
    //  Returns the NFT to original owner.
    // @notice This is a state-modifying function that can
    //  be called while the contract is paused.
    // @param _tokenId - ID of token on auction
    // 取消尚未赢得的拍卖。 将NFT返回给原始所有者。
    function cancelAuction(uint256 _tokenId)
        external
    {
        // 還在拍賣中才可取消
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        // 取消合約的人 必須是拍賣的發起者
        address seller = auction.seller;
        require(msg.sender == seller);
        _cancelAuction(_tokenId, seller);
    }

    // @dev Cancels an auction when the contract is paused.
    //  Only the owner may do this, and NFTs are returned to
    //  the seller. This should only be used in emergencies.
    // @param _tokenId - ID of the NFT on auction to cancel.
    // 合同暂停时取消拍卖。 只有所有者可以这样做，并且NFT被退还给卖方。 这只能在紧急情况下使用。
    // 看起來和上個函數cancelAuction無差異
    function cancelAuctionWhenPaused(uint256 _tokenId)
        whenPaused
        onlyOwner
        external
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        _cancelAuction(_tokenId, auction.seller);
    }

    // @dev Returns auction info for an NFT on auction.
    // @param _tokenId - ID of NFT on auction.
    // 在拍卖中返回NFT的拍卖信息。
    function getAuction(uint256 _tokenId)
        external
        view
        returns
    (
        address seller,
        uint256 startingPrice,
        uint256 endingPrice,
        uint256 duration,
        uint256 startedAt
    ) {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        return (
            auction.seller,
            auction.startingPrice,
            auction.endingPrice,
            auction.duration,
            auction.startedAt
        );
    }

    // @dev Returns the current price of an auction.
    // @param _tokenId - ID of the token price we are checking.
    // 返回拍卖的当前价格。
    function getCurrentPrice(uint256 _tokenId)
        external
        view
        returns (uint256)
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        return _currentPrice(auction);
    }

}


// @title Reverse auction modified for siring
// @notice We omit a fallback function to prevent accidental sends to this contract.
// 反向拍卖修改为招标
// 我们省略了后备功能，以防止意外发送到本合同。
// 租出一隻給別人的來育種
contract SiringClockAuction is ClockAuction {

    // @dev Sanity check that allows us to ensure that we are pointing to the
    //  right auction in our setSiringAuctionAddress() call.
    // 完整性检查，使我们能够确保我们在我们的setSiringAuctionAddress（）调用中指向正确的拍卖。
    bool public isSiringClockAuction = true;

    // Delegate constructor
    // 委托构造函数
    function SiringClockAuction(address _nftAddr, uint256 _cut) public
        ClockAuction(_nftAddr, _cut) {}

    // @dev Creates and begins a new auction. Since this function is wrapped,
    // require sender to be KittyCore contract.
    // @param _tokenId - ID of token to auction, sender must be owner.
    // @param _startingPrice - Price of item (in wei) at beginning of auction.
    // @param _endingPrice - Price of item (in wei) at end of auction.
    // @param _duration - Length of auction (in seconds).
    // @param _seller - Seller, if not the message sender
    // 创建并开始新的拍卖。 由于这个功能被封装，要求发件人是KittyCore合同。
    function createAuction(
        uint256 _tokenId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        address _seller
    )
        external
    {
        // Sanity check that no inputs overflow how many bits we've allocated
        // to store them in the auction struct.
        // 完整性检查没有输入溢出我们已经分配将它们存储在拍卖结构中的多少位。
        require(_startingPrice == uint256(uint128(_startingPrice)));
        require(_endingPrice == uint256(uint128(_endingPrice)));
        require(_duration == uint256(uint64(_duration)));

        require(msg.sender == address(nonFungibleContract));
        _escrow(_seller, _tokenId);
        Auction memory auction = Auction(
            _seller,
            uint128(_startingPrice),
            uint128(_endingPrice),
            uint64(_duration),
            uint64(now)
        );
        _addAuction(_tokenId, auction);
    }

    // @dev Places a bid for siring. Requires the sender
    // is the KittyCore contract because all bid methods
    // should be wrapped. Also returns the kitty to the
    // seller rather than the winner.
    // 出价投标。 要求发件人是KittyCore合同，因为所有出价方法都应该包装。 还将猫归还给卖家而不是赢家。
    // 這什麼詭異的東西
    function bid(uint256 _tokenId)
        external
        payable
    {
        require(msg.sender == address(nonFungibleContract));
        address seller = tokenIdToAuction[_tokenId].seller;
        // _bid checks that token ID is valid and will throw if bid fails
        // _bid检查令牌ID是否有效，如果出价失败则会抛出
        _bid(_tokenId, msg.value);
        // We transfer the kitty back to the seller, the winner will get
        // the offspring
        // 我们将小猫转交给卖家，获胜者将得到后代
        _transfer(seller, _tokenId);
    }

}





// @title Clock auction modified for sale of kitties
// @notice We omit a fallback function to prevent accidental sends to this contract.
// 荷蘭式拍賣修改为出售小猫
// 我们省略了后备功能，以防止意外发送到本合同。
contract SaleClockAuction is ClockAuction {

    // @dev Sanity check that allows us to ensure that we are pointing to the
    //  right auction in our setSaleAuctionAddress() call.
    // 完整性检查，使我们能够确保我们在我们的setSaleAuctionAddress（）调用中指向正确的拍卖。
    bool public isSaleClockAuction = true;

    // Tracks last 5 sale price of gen0 kitty sales
    // 跟踪gen0 kitty销售的最后5个销售价格
    uint256 public gen0SaleCount;
    uint256[5] public lastGen0SalePrices;

    // Delegate constructor
    // 委托构造函数
    function SaleClockAuction(address _nftAddr, uint256 _cut) public
        ClockAuction(_nftAddr, _cut) {}

    // @dev Creates and begins a new auction.
    // @param _tokenId - ID of token to auction, sender must be owner.
    // @param _startingPrice - Price of item (in wei) at beginning of auction.
    // @param _endingPrice - Price of item (in wei) at end of auction.
    // @param _duration - Length of auction (in seconds).
    // @param _seller - Seller, if not the message sender
    // 创建并开始新的拍卖。
    function createAuction(
        uint256 _tokenId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        address _seller
    )
        external
    {
        // Sanity check that no inputs overflow how many bits we've allocated
        // to store them in the auction struct.
        // 完整性检查没有输入溢出我们已经分配将它们存储在拍卖结构中的多少位。
        require(_startingPrice == uint256(uint128(_startingPrice)));
        require(_endingPrice == uint256(uint128(_endingPrice)));
        require(_duration == uint256(uint64(_duration)));

        require(msg.sender == address(nonFungibleContract));
        _escrow(_seller, _tokenId);
        Auction memory auction = Auction(
            _seller,
            uint128(_startingPrice),
            uint128(_endingPrice),
            uint64(_duration),
            uint64(now)
        );
        _addAuction(_tokenId, auction);
    }

    // @dev Updates lastSalePrice if seller is the nft contract
    // Otherwise, works the same as default bid method.
    // 如果卖家是nft合约，则更新lastSalePrice否则，与默认投标方法相同。
    function bid(uint256 _tokenId)
        external
        payable
    {
        // _bid verifies token ID size
        // _bid验证令牌ID大小
        address seller = tokenIdToAuction[_tokenId].seller;
        uint256 price = _bid(_tokenId, msg.value);
        _transfer(msg.sender, _tokenId);

        // If not a gen0 auction, exit
        // 如果不是gen0拍卖，退出
        if (seller == address(nonFungibleContract)) {
            // Track gen0 sale prices
            // 跟踪gen0销售价格
            lastGen0SalePrices[gen0SaleCount % 5] = price;
            gen0SaleCount++;
        }
    }

    function averageGen0SalePrice() external view returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < 5; i++) {
            sum += lastGen0SalePrices[i];
        }
        return sum / 5;
    }

}


// @title Handles creating auctions for sale and siring of kitties.
//  This wrapper of ReverseAuction exists only so that users can create
//  auctions with only one transaction.
// 处理创建拍卖出售和kitties.This ReverseAuction这种包装只存在，使用户可以创建只有一个交易拍卖。
contract KittyAuction is KittyBreeding {

    // @notice The auction contract variables are defined in KittyBase to allow
    //  us to refer to them in KittyOwnership to prevent accidental transfers.
    // `saleAuction` refers to the auction for gen0 and p2p sale of kitties.
    // `siringAuction` refers to the auction for siring rights of kitties.
    // 在KittyBase中定义了拍卖合约变量，以便我们可以用KittyOwnership来提及他们，以防止意外转移。
    //  `saleAuction`是指小猫的gen0和p2p出售的拍卖。 `siringAuction`是指拍卖小猫的权利的拍卖。

    // @dev Sets the reference to the sale auction.
    // @param _address - Address of sale contract.
    // 设置销售拍卖的参考。
    function setSaleAuctionAddress(address _address) external onlyCEO {
        // 注意 CEO 可以覆寫 candidateContract 合約
        SaleClockAuction candidateContract = SaleClockAuction(_address);

        // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
        // 验证合同是我们所期望的
        require(candidateContract.isSaleClockAuction());

        // Set the new contract address
        // 设置新的合同地址
        saleAuction = candidateContract;
    }

    // @dev Sets the reference to the siring auction.
    // @param _address - Address of siring contract.
    // 设置参考拍卖的参考。
    function setSiringAuctionAddress(address _address) external onlyCEO {
        // 注意 CEO 可以覆寫 candidateContract 合約
        SiringClockAuction candidateContract = SiringClockAuction(_address);

        // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
        // 验证合同是我们所期望的
        require(candidateContract.isSiringClockAuction());

        // Set the new contract address
        // 设置新的合同地址
        siringAuction = candidateContract;
    }

    // @dev Put a kitty up for auction.
    //  Does some ownership trickery to create auctions in one tx.
    // 把一只小猫拍卖。
    function createSaleAuction(
        uint256 _kittyId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration
    )
        external
        whenNotPaused
    {
        // Auction contract checks input sizes
        // If kitty is already on any auction, this will throw
        // because it will be owned by the auction contract.
        // 拍卖合同检查输入尺寸如果小猫已经在任何拍卖，这将抛出，因为它将由拍卖合同拥有。
        require(_owns(msg.sender, _kittyId));
        // Ensure the kitty is not pregnant to prevent the auction
        // contract accidentally receiving ownership of the child.
        // NOTE: the kitty IS allowed to be in a cooldown.
        // 确保小猫没有怀孕，以防止拍卖合同意外地收到孩子的所有权。 注意：小猫被允许处于冷却状态。
        require(!isPregnant(_kittyId));
        _approve(_kittyId, saleAuction);
        // Sale auction throws if inputs are invalid and clears
        // transfer and sire approval after escrowing the kitty.
        // 如果输入无效，并且在托管小猫之后清除转让和公貓批准，则拍卖会投标。
        saleAuction.createAuction(
            _kittyId,
            _startingPrice,
            _endingPrice,
            _duration,
            msg.sender
        );
    }

    // @dev Put a kitty up for auction to be sire.
    //  Performs checks to ensure the kitty can be sired, then
    //  delegates to reverse auction.
    // 把一只小猫拍卖成为公貓。 执行检查以确保小猫可以被录取，然后委托进行反向拍卖。
    function createSiringAuction(
        uint256 _kittyId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration
    )
        external
        whenNotPaused
    {
        // Auction contract checks input sizes
        // If kitty is already on any auction, this will throw
        // because it will be owned by the auction contract.
        // 拍卖合同检查输入尺寸如果小猫已经在任何拍卖，这将抛出，因为它将由拍卖合同拥有。
        require(_owns(msg.sender, _kittyId));
        require(isReadyToBreed(_kittyId)); // 準備好交配的貓
        _approve(_kittyId, siringAuction);
        // Siring auction throws if inputs are invalid and clears
        // transfer and sire approval after escrowing the kitty.
        // 如果输入无效，并且在托管小猫之后清除转让和公貓批准，则拍卖会投标。
        siringAuction.createAuction(
            _kittyId,
            _startingPrice,
            _endingPrice,
            _duration,
            msg.sender
        );
    }

    // @dev Completes a siring auction by bidding.
    //  Immediately breeds the winning matron with the sire on auction.
    // @param _sireId - ID of the sire on auction.
    // @param _matronId - ID of the matron owned by the bidder.
    // 通过竞标完成拍卖。 立即在拍卖中孕育与父亲的获胜的母貓。
    function bidOnSiringAuction(
        uint256 _sireId,
        uint256 _matronId
    )
        external
        payable
        whenNotPaused
    {
        // Auction contract checks input sizes
        // 拍卖合同检查输入尺寸
        require(_owns(msg.sender, _matronId));
        require(isReadyToBreed(_matronId));
        require(_canBreedWithViaAuction(_matronId, _sireId));

        // Define the current price of the auction.
        // 定义拍卖的当前价格。
        uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
        require(msg.value >= currentPrice + autoBirthFee);

        // Siring auction will throw if the bid fails.
        // 如果出价失败，拍卖会就会抛售。
        siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
        _breedWith(uint32(_matronId), uint32(_sireId));
    }

    // @dev Transfers the balance of the sale auction contract
    // to the KittyCore contract. We use two-step withdrawal to
    // prevent two transfer calls in the auction bid function.
    // 将拍卖合同的余额转移到KittyCore合同。 我们使用两步撤销来防止拍卖投标功能中的两次转账。
    function withdrawAuctionBalances() external onlyCLevel {
        saleAuction.withdrawBalance();
        siringAuction.withdrawBalance();
    }
}


// @title all functions related to creating kittens
// 所有与创建小猫有关的功能
contract KittyMinting is KittyAuction {

    // Limits the number of cats the contract owner can ever create.
    // 限制合同所有者可以创建的猫的数量。
    uint256 public constant PROMO_CREATION_LIMIT = 5000;
    uint256 public constant GEN0_CREATION_LIMIT = 45000;

    // Constants for gen0 auctions.
    // gen0拍卖的常量。
    uint256 public constant GEN0_STARTING_PRICE = 10 finney;
    uint256 public constant GEN0_AUCTION_DURATION = 1 days;

    // Counts the number of cats the contract owner has created.
    // 计算合同所有者创建的猫的数量。
    uint256 public promoCreatedCount;
    uint256 public gen0CreatedCount;

    // @dev we can create promo kittens, up to a limit. Only callable by COO
    // @param _genes the encoded genes of the kitten to be created, any value is accepted
    // @param _owner the future owner of the created kittens. Default to contract COO
    // 我们可以创造促销小猫，达到极限。 只能由COO调用
    function createPromoKitty(uint256 _genes, address _owner) external onlyCOO {
        address kittyOwner = _owner;
        if (kittyOwner == address(0)) {
             kittyOwner = cooAddress;
        }
        require(promoCreatedCount < PROMO_CREATION_LIMIT);

        promoCreatedCount++;
        _createKitty(0, 0, 0, _genes, kittyOwner);
    }

    // @dev Creates a new gen0 kitty with the given genes and
    //  creates an auction for it.
    // 用给定的基因创建一个新的gen0 kitty，并创建一个拍卖。
    function createGen0Auction(uint256 _genes) external onlyCOO {
        require(gen0CreatedCount < GEN0_CREATION_LIMIT);

        uint256 kittyId = _createKitty(0, 0, 0, _genes, address(this));
        _approve(kittyId, saleAuction);

        saleAuction.createAuction(
            kittyId,
            _computeNextGen0Price(),
            0,
            GEN0_AUCTION_DURATION,
            address(this)
        );

        gen0CreatedCount++;
    }

    // @dev Computes the next gen0 auction starting price, given
    //  the average of the past 5 prices + 50%.
    // 计算下一个gen0拍卖开始价格，给定过去5个价格的平均值+ 50％。
    function _computeNextGen0Price() internal view returns (uint256) {
        uint256 avePrice = saleAuction.averageGen0SalePrice();

        // Sanity check to ensure we don't overflow arithmetic
        // 理智的检查，以确保我们不会溢出算术
        require(avePrice == uint256(uint128(avePrice)));

        uint256 nextPrice = avePrice + (avePrice / 2);

        // We never auction for less than starting price
        // 我们永远不会以低于起始价格拍卖
        if (nextPrice < GEN0_STARTING_PRICE) {
            nextPrice = GEN0_STARTING_PRICE;
        }

        return nextPrice;
    }
}


// @title CryptoKitties: Collectible, breedable, and oh-so-adorable cats on the Ethereum blockchain.
// @author Axiom Zen (https://www.axiomzen.co)
// @dev The main CryptoKitties contract, keeps track of kittens so they don't wander around and get lost.
// CryptoKitties：以太坊区块链上的可收藏，可爱，可爱的猫咪。
// 主要CryptoKitties合同，跟踪小猫，所以他们不会四处流浪，迷路。
contract KittyCore is KittyMinting {

    // This is the main CryptoKitties contract. In order to keep our code seperated into logical sections,
    // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
    // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
    // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
    // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
    // kitty ownership. The genetic combination algorithm is kept seperate so we can open-source all of
    // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
    // Don't worry, I'm sure someone will reverse engineer it soon enough!
    // 这是CryptoKitties的主要合同。 为了保持我们的代码分为逻辑部分，我们已经分解了两种方式。 
    // 首先，我们有几个单独实例化的兄弟姐妹契约处理拍卖和我们的超级绝密遗传组合算法。 
    // 拍卖是分开的，因为他们的逻辑有点复杂，总是有微妙的错误的风险。 
    // 通过保留它们自己的合同，我们可以升级它们，而不会中断追踪小猫所有权的主合同。 
    // 遗传组合算法是保持独立的，所以我们可以开放源代码的所有其他代码，而不是让人们很容易找出遗传学是如何工作的。 别担心，我确定有人会很快反向工程！
    //
    // Secondly, we break the core contract into multiple files using inheritence, one for each major
    // facet of functionality of CK. This allows us to keep related code bundled together while still
    // avoiding a single giant file with everything in it. The breakdown is as follows:
    // 其次，我们使用继承将核心合约分解成多个文件，每个文件的主要方面都是CK的主要方面。 
    // 这使我们可以将相关的代码捆绑在一起，同时避免一个巨大的文件，其中的一切都在其中。 细目如下：
    //
    //      - KittyBase: This is where we define the most fundamental code shared throughout the core
    //             functionality. This includes our main data storage, constants and data types, plus
    //             internal functions for managing these items.
    //      KittyBase：这是我们定义在整个核心功能共享的最基本的代码。 这包括我们的主要数据存储，常量和数据类型，以及用于管理这些项目的内部函数。

    //      - KittyAccessControl: This contract manages the various addresses and constraints for operations
    //             that can be executed only by specific roles. Namely CEO, CFO and COO.
    //      KittyAccessControl：该合同管理只能由特定角色执行的操作的各种地址和约束。 即首席执行官，首席财务官和首席运营官。
    //
    //      - KittyOwnership: This provides the methods required for basic non-fungible token
    //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
    //      KittyOwnership：根据ERC-721规范草案（https://github.com/ethereum/EIPs/issues/721）提供基本的不可互换令牌交易所需的方法。
    //
    //      - KittyBreeding: This file contains the methods necessary to breed cats together, including
    //             keeping track of siring offers, and relies on an external genetic combination contract.
    //      KittyBreeding：这个文件包含必要的方法来养猫一起，包括跟踪提供优惠，并依靠外部的基因组合合同。
    //
    //      - KittyAuctions: Here we have the public methods for auctioning or bidding on cats or siring
    //             services. The actual auction functionality is handled in two sibling contracts (one
    //             for sales and one for siring), while auction creation and bidding is mostly mediated
    //             through this facet of the core contract.
    //      KittyAuctions：在这里，我们有公开的方法来拍卖或招标的猫或服务。 
    //             实际的拍卖功能是在两个兄弟合同（一个用于销售，一个用于招标）中处理的，
    //             而拍卖的创建和投标主要是通过核心合同的这个方面来进行调解。
    //
    //      - KittyMinting: This final facet contains the functionality we use for creating new gen0 cats.
    //             We can make up to 5000 "promo" cats that can be given away (especially important when
    //             the community is new), and all others can only be created and then immediately put up
    //             for auction via an algorithmically determined starting price. Regardless of how they
    //             are created, there is a hard limit of 50k gen0 cats. After that, it's all up to the
    //             community to breed, breed, breed!
    //             KittyMinting：这个最后一个方面包含了我们用来创建新的gen0猫的功能。 
    //             我们最多可以制作5000只可以赠送的“促销”猫（当社区是新的时候特别重要），
    //             其他所有的只能通过算法确定的起始价格创建，然后立即投入拍卖。 
    //             不管它们是如何创造的，都有50k gen0猫的硬性极限。 在那之后，社群就要养殖，繁殖，繁殖！

    // Set in case the core contract is broken and an upgrade is required
    // 如果核心合同被破坏并且需要升级，则设置
    address public newContractAddress;

    // @notice Creates the main CryptoKitties smart contract instance.
    // 创建主要的CryptoKitties智能合约实例。
    function KittyCore() public {
        // Starts paused.
        paused = true;

        // the creator of the contract is the initial CEO
        // 合同的创造者是首席执行官
        ceoAddress = msg.sender;

        // the creator of the contract is also the initial COO
        // 合同的创造者也是最初的首席运营官
        cooAddress = msg.sender;

        // start with the mythical kitten 0 - so we don't have generation-0 parent issues
        // 从神话小猫0开始 - 所以我们没有0代父问题
        _createKitty(0, 0, 0, uint256(-1), address(0));
    }

    // @dev Used to mark the smart contract as upgraded, in case there is a serious
    //  breaking bug. This method does nothing but keep track of the new contract and
    //  emit a message indicating that the new address is set. It's up to clients of this
    //  contract to update to the new contract address in that case. (This contract will
    //  be paused indefinitely if such an upgrade takes place.)
    // @param _v2Address new address
    // 用于将智能合约标记为已升级，以防出现严重的突破性错误。 这个方法什么都不做，只跟踪新的合同，
    // 并发出一个消息，指出新的地址已经设置。 在这种情况下，本合同的客户应该更新到新的合同地址。 （如果升级发生，此合约将无限期暂停。）
    function setNewAddress(address _v2Address) external onlyCEO whenPaused {
        // See README.md for updgrade plan
        newContractAddress = _v2Address;
        ContractUpgrade(_v2Address);
    }

    // @notice No tipping!
    // @dev Reject all Ether from being sent here, unless it's from one of the
    //  two auction contracts. (Hopefully, we can prevent user accidents.)
    // 没有小费！
    // 拒绝所有乙醚被送到这里，除非是来自两个拍卖合同中的一个。 （希望能防止用户意外。）
    function() external payable {
        require(
            msg.sender == address(saleAuction) ||
            msg.sender == address(siringAuction)
        );
    }

    // @notice Returns all the relevant information about a specific kitty.
    // @param _id The ID of the kitty of interest.
    // 返回有关特定小猫的所有相关信息。
    function getKitty(uint256 _id)
        external
        view
        returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    ) {
        Kitty storage kit = kitties[_id];

        // if this variable is 0 then it's not gestating
        // 如果这个变量是0，那么它不是孕育
        isGestating = (kit.siringWithId != 0);
        isReady = (kit.cooldownEndBlock <= block.number);
        cooldownIndex = uint256(kit.cooldownIndex);
        nextActionAt = uint256(kit.cooldownEndBlock);
        siringWithId = uint256(kit.siringWithId);
        birthTime = uint256(kit.birthTime);
        matronId = uint256(kit.matronId);
        sireId = uint256(kit.sireId);
        generation = uint256(kit.generation);
        genes = kit.genes;
    }

    // @dev Override unpause so it requires all external contract addresses
    //  to be set before contract can be unpaused. Also, we can't have
    //  newContractAddress set either, because then the contract was upgraded.
    // @notice This is public rather than external so we can call super.unpause
    //  without using an expensive CALL.
    // 覆盖取消暂停，因此它需要所有的外部合同地址被设置，合同可以解除暂停之前。 此外，我们也不能有newContractAddress设置，因为那么合同升级。
    // 这是公开的，而不是外部的，所以我们可以调用super.unpause而不使用昂贵的CALL。
    function unpause() public onlyCEO whenPaused {
        require(saleAuction != address(0));
        require(siringAuction != address(0));
        require(geneScience != address(0));
        require(newContractAddress == address(0));

        // Actually unpause the contract.
        // 其实取消暂停合同。
        super.unpause();
    }

    // @dev Allows the CFO to capture the balance available to the contract.
    // 允许首席财务官获取合同可用的余额。
    function withdrawBalance() external onlyCFO {
        uint256 balance = this.balance;
        // Subtract all the currently pregnant kittens we have, plus 1 of margin.
        // 减去我们有的所有怀孕的小猫，再加上1个保证金。
        uint256 subtractFees = (pregnantKitties + 1) * autoBirthFee;

        if (balance > subtractFees) {
            cfoAddress.send(balance - subtractFees);
        }
    }
}