pragma solidity ^0.4.11;


/// @title Keeping the history of product prices
/// @author Nemanja Branisvljevic
contract BlockTag{



    bytes32 public owner_name;
    address public owner;
    uint8 public decimals = 2; // This is required since ether platform doesn't work with integers. In contract everything is calculated with integers, and decimal numbers have to becalculated at the client level using this data.

    struct Product_data{
        bytes32 code; //This may be a code from the bar code of the product. if product doesn't have a bar code, a unique code has to be supplied to it (TODO Thik=nk about the creation using the owner address)
        bytes32 name; //The name of the product
        bytes32 unit; //Unit, like kg, m3, etc.
        uint  amount; //Like amount in the package
        uint old_price; //Keep one price from the history in the variable
        uint   price; 
        bytes32 currency; //Currency used
        bool exists; //Need to check if the value is already set for specific product
    }

    mapping (bytes32 => Product_data) Products; //Mapping product code to actual product

    ///Good to get the notification if everything went well
    event Price_set(address owner, bytes32 product_code, uint old_price, uint new_price);



  /// @notice Constructor sets owner address and name 
  /// 
  /// @param name Name of the owner
  /// 
    function BlockTag (bytes32 name) public {
        owner=msg.sender;
        owner_name=name;
    }



    /// @notice Adds the product to the variable 
    /// 
    /// @param product_code Product code (idealy barcode)
    /// @param product_name verbose name of the product
    /// @param product_unit product unit
    /// @param product_unit product amount
    /// @paramproduct_price price
    /// @paramproduct_currency currency
    function Add_product (bytes32 product_code, bytes32 product_name, bytes32 product_unit, uint  product_amount, uint   product_price, bytes32 product_currency) public {

        require((msg.sender == owner) && !Products[product_code].exists);//It is required that the owner set the products, and that the product doesnt exist
        Products[product_code].code = product_code;
        Products[product_code].name = product_name;
        Products[product_code].unit = product_unit;
        Products[product_code].amount = product_amount;
        Products[product_code].old_price = product_price;
        Products[product_code].price = product_price;
        Products[product_code].currency = product_currency;
        Products[product_code].exists = true;
    }




    /// @notice Sets the new price of the product 
    /// 
    /// @param product_code Product code (idealy barcode)
    /// @param new_price new price
    function Set_price (bytes32 product_code, uint new_price) public {

        require(msg.sender == owner);
        Products[product_code].old_price=Products[product_code].price;
        Products[product_code].price = new_price;
        Price_set(owner, product_code, Products[product_code].old_price, Products[product_code].price);
    }

}
