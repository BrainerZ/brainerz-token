pragma solidity ^0.4.18;

import "../../misc/BytesDeserializer.sol";

contract PreSaleDeserializer {
    using BytesDeserializer for bytes;

    struct PreSalePayload {
        address buyer; // 20 bytes
        uint32 userId; // 4 bytes
        uint32 weiPerToken; // 4 bytes
        uint32 tokensToPurchase; // 4 bytes
    }

    function deserialize (bytes data) public returns 
                                            (address buyer,
                                            uint32 userId,
                                            uint32 weiPerToken,
                                            uint32 tokensToPurchase) 
    {
        address tokenReceiver = data.sliceAddress(0); // AUDIT: should check weather it is the same as msg.sender?
        uint32 uid = uint32(data.slice4(20));
        uint32 price = uint32(data.slice4(24));
        uint32 amountOfTokens = uint32(data.slice4(28));

        return (tokenReceiver, uid, price, amountOfTokens);
    }


}
