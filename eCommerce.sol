//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 < 0.9.0;

contract eCommerceProject {

    struct Product{
        string title;
        string desc;
        address payable seller;
        uint productId;
        uint price;
        address buyer;
        bool isDelivered;
    }

    uint counter = 1;
    Product[] public products;

    event registerd(string title , uint productId , address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);
    event CheckPrice(uint senValue , uint orignalValue);

    function register(string memory _title, string memory _desc , uint _price) public {
        require(_price > 0 , "Should be greater than zero");
        Product memory tempProduct ;
        tempProduct.title = _title;
        tempProduct.desc = _desc;
        tempProduct.price = _price * 10 ** 18;
        tempProduct.seller = payable(msg.sender);
        tempProduct.productId = counter++;
        products.push(tempProduct);
        emit registerd(_title , tempProduct.productId , msg.sender);
    }

    function buy(uint _productId) payable public {
        require(products[_productId-1].price == msg.value, "Please pay the exact price");
        require(products[_productId-1].seller != msg.sender , "Seller cannot buy its own product");
        products[_productId-1].buyer = msg.sender;
        emit bought(_productId, msg.sender);
    }
    
    function delivery(uint _productId) public {
        require(products[_productId-1].buyer == msg.sender , "only buyer can confirm");
        products[_productId - 1].isDelivered = true;
        products[_productId - 1].seller.transfer(products[_productId - 1].price);
        emit delivered(_productId);
    }

}