// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract TweeterContract{
    struct Tweet{
    uint id;
    address author;
    string content;
    uint createdAt;
    }
    struct Message{
        uint id;
        string content;
        address from;
        address to;
        uint createdAt;
    }

    mapping (uint => Tweet) public tweets;
    mapping (address => uint[]) public tweetsOf;
    mapping (address => Message[]) public conversations;
    mapping (address => mapping(address=>bool)) public operators;
    mapping (address => address[]) public following;

    uint nextId;
    uint nextMessageId;

    function _tweet(address _from , string memory _content) internal {
        tweets[nextId] = Tweet(nextId, _from, _content, block.timestamp);
        nextId= nextId+1;
    }

    function _sendMessage(address  _from, address _to, string memory _content) internal {
        conversations[_from].push(Message(nextMessageId,_content,_from ,_to,block.timestamp));
        nextMessageId++;
    }

    function tweet(string memory _content) public{ //Owner 
        _tweet(msg.sender,_content);

    }

    function tweet (address _from, string memory _content) public { // Owner => access control
        _tweet(_from,_content);
    }

    function sendMessage(string memory _content, address _to) public {
        _sendMessage(msg.sender, _to, _content);
    }

    function sendMessage(address _from ,address _to, string memory _content) public{
        _sendMessage(_from, _to, _content);
    }
    
    function follow(address _followed) public {
        following [msg.sender].push (_followed);
        
    }

    function allow (address _operator) public {
        operators[msg.sender][_operator] = true;
    }

      function disAllow (address _operator) public {
        operators[msg.sender][_operator] = false;
    }


    function getLatestTweets(uint count) public view returns (Tweet[] memory){
        require (count>0 && count <= nextId , "Count is Not Proper");

        Tweet[] memory _tweets = new Tweet[](count);

        uint j;

        for(uint i =nextId-count; i<nextId ;i++ ){

            Tweet storage _structure = tweets[i];

            _tweets[j] =Tweet(
                _structure.id, 
                _structure.author, 
                _structure.content , 
                _structure.createdAt
                );
            j= j+1;
        }
        return _tweets;
    }


    function getLatestTweetsOfUsers (address _user , uint counts) public view returns ( Tweet[] memory){

        Tweet[] memory _tweets = new Tweet[](counts);
        uint[] memory  ids = tweetsOf[_user];
        require (counts>0 && counts <= ids.length , "Count is Not Defined");
        uint j;
        for(uint i = ids.length-counts ; i<ids.length ; i++){
             Tweet storage _structure = tweets[ids[i]];
            _tweets[j] =Tweet(
                _structure.id, 
                _structure.author, 
                _structure.content , 
                _structure.createdAt
                );
            j= j+1;
        }
        return _tweets;
    }
}
