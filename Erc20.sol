pragma solidity >=0.4.0 < 0.9.0; 

interface IERC20 {

    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient,uint256 amount) external returns (bool);
    event Transfer(address indexed from,address indexed to,uint256 value);
}

contract Mytoken is IERC20 {
    string public  name;
    string public  symbol;
    uint8 public  decimals;
    address private owner;
    address admin;
    event Approval(address indexed tokenOwner,address indexed spender ,uint256 token);
   // event Transfer(address indexed from,address indexed to,uint256 token);

    mapping(address=>uint256) balances;
    mapping(address=>mapping(address=>uint256)) allowed;
 
    uint256 totalSupply_;

    constructor(string memory _name,string memory _symbol,uint8 _decimal,uint256 _tolSupply) public {
     totalSupply_=_tolSupply;
     balances[msg.sender] = totalSupply_;
     name=_name;
     symbol=_symbol;
     decimals=_decimal;
     admin=msg.sender;     
      }

     function getOwner() public view returns (address) {    
        return admin;
    }
     function totalSupply() public override view returns(uint256){
       return totalSupply_;
     }

     function balanceOf(address tokenOwner) public override view returns(uint256){
         return balances[tokenOwner];
     }

     function transfer(address receiver,uint256 numTokens) public override returns (bool){
         require(numTokens<=balances[msg.sender]);
         balances[msg.sender] -= numTokens;
         balances[receiver]+=numTokens;
         emit Transfer(msg.sender,receiver,numTokens);
         return true;
     }

     modifier onlyAdmin {
         require(msg.sender==admin,'Only admin can run this function');
         _;
     }

     function mint(uint256 totlsup) public onlyAdmin returns(uint256) {
         totalSupply_ += totlsup;
         balances[msg.sender]+=totlsup;
         return totalSupply_;
     }

     function burn(uint256 totlsup) public onlyAdmin returns(uint256) {
        require(balances[msg.sender]>=totlsup);
         totalSupply_ -= totlsup;
         balances[msg.sender]-=totlsup;
         return totalSupply_;
     }

    function allowance(address _owner,address _spender) public view returns(uint256 remaining) {
       return allowed[_owner][_spender];
    } 

    function approve(address _spender,uint256 _value) public returns (bool success){
        allowed[msg.sender][_spender]=_value;
        emit Approval(msg.sender,_spender,_value);
        return true;
    } 

     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender]-=_value;
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }
    

}
