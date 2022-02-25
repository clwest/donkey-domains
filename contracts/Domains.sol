// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {StringUtils} from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";
import "hardhat/console.sol";

contract Domains is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public tld;

    string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="450" style="background-color:#483248" fill="black"><path fill="url(#B)" d="M363.426 18.516s-43.17 34.89-62 89.74c-7.55 22.02-12.52 43.05-14.77 60.69-25 5.23-70.76 33.85-70.76 33.85l-35-3.79 12.08 18.29-36.08 5.71 15.83 14.89-30.37-1.35 3.37 12.82-27-.68 2.7 20.798-23.63-4.548 2.7 23.62-18.9-3.77-.67 19.288-29.7-4.72 2.7 22.27L18 332.085V494h178.46l67.597-115.734-36-45.782 12.63-9.82 44.43 56.53c4.5 4.47 9.25 8.63 12.5 10 17.69 7.47 53.25 8.35 69.69 18.21 9.25 5.52 20.38 26.832 30.52 30.522 1.76.516 3.595.742 5.43.67 8.88 0 22.65-3.112 22.65-3.112l12.49 12.16 11.66-10-30.59-31.32 11.44-11.19 32.38 33.09 2.19-1.548s9.76-54.132 3.2-70.512c-7.79-19.47-45.732-43.81-57.232-61.35-9.47-14.4-16.998-49.51-27.468-63.18-10.17-13.32-31.17-33.618-52.17-47.618 8.99-15.24 17.91-34.76 25.41-56.62 18.83-54.88 6.21-108.88 6.21-108.88zm65.79 21.7s-22 11.37-45.94 33.8a214.075 214.075 0 0 1-10.92 58.61 354.6 354.6 0 0 1-19.66 46.71c3.28 2.51 6.47 5.1 9.58 7.71a357.567 357.567 0 0 0 32.94-43.892c31.32-48.77 34-102.94 34-102.94zm-86.43 214.01c13.597 0 20.403 16.437 10.79 26.05-9.613 9.612-26.05 2.805-26.05-10.792 0-8.427 6.833-15.26 15.26-15.26zm106.98 101.92c2.69 0 4.88 7 4.88 15.7s-2.19 15.7-4.88 15.7-4.88-7.03-4.88-15.7c0-8.67 2.19-15.7 4.88-15.7z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".305" width="200%" height="200%"/></filter></defs><path d="M72.863 42.949c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-10.081 6.032-6.85 3.934-10.081 6.032c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-8.013-4.721a4.52 4.52 0 0 1-1.589-1.616c-.384-.665-.594-1.418-.608-2.187v-9.31c-.013-.775.185-1.538.572-2.208a4.25 4.25 0 0 1 1.625-1.595l7.884-4.59c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v6.032l6.85-4.065v-6.032c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595L41.456 24.59c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-14.864 8.655a4.25 4.25 0 0 0-1.625 1.595c-.387.67-.585 1.434-.572 2.208v17.441c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l10.081-5.901 6.85-4.065 10.081-5.901c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v9.311c.013.775-.185 1.538-.572 2.208a4.25 4.25 0 0 1-1.625 1.595l-7.884 4.721c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-7.884-4.59a4.52 4.52 0 0 1-1.589-1.616c-.385-.665-.594-1.418-.608-2.187v-6.032l-6.85 4.065v6.032c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l14.864-8.655c.657-.394 1.204-.95 1.589-1.616s.594-1.418.609-2.187V55.538c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595l-14.993-8.786z" fill="white"/><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="black"/><stop offset="1" stop-color="goldenrod" stop-opacity=".88"/></linearGradient></defs><text x="22" y="444" font-size="26" fill="crimson" filter="drop-shadow(10px 10px 13px black)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = '</text></svg>';

    address payable public owner;

    mapping(string => address) public domains;
    mapping(string => string) public records;
    mapping(uint => string) public names;
    
    error Unauthorized();
    error AlreadyRegistered();
    error InvalidName(string name);


    constructor(string memory _tld) payable ERC721("Donkey Name Service", "DNS")  {
        owner = payable(msg.sender);
        tld = _tld;
        console.log("%s name service deployed", _tld);
    }

    function price(string calldata name) public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len > 0);
        if (len == 3) {
            return 5 * 10 ** 17;
        } else if (len == 4 ) {
            return 3* 10 ** 17;
        } else {
            return 1 * 10 ** 17;
        }
    }

    function register(string calldata name) public payable {
        if (domains[name] != address(0)) revert AlreadyRegistered();
        if (!valid(name)) revert InvalidName(name);
        require(domains[name] == address(0), "domains already registered");
        uint _price = price(name);
        require(msg.value >= _price, "Not enough MATIC");

        string memory _name = string(abi.encodePacked(name, ".", tld));
        string memory finalSVG = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));
        uint256 newRecordId = _tokenIds.current();
        uint256 length = StringUtils.strlen(name);
        string memory strLen = Strings.toString(length);

        console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                    _name,
                    '", "description": "A domain on the Donkey name service", "image": "data:image/svg+xml;base64, ',
                    Base64.encode(bytes(finalSVG)),
                    '", "length":"',
                    strLen,
                    '"}'
                    )
                )
            )
        );

        string memory finalTokeUri = string(abi.encodePacked("data:application/json;Base64,", json));
        console.log("\n----------------------------------");
        console.log("Final tokenURI", finalTokeUri);
        console.log("-------------------------------------\n");


        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokeUri);
        domains[name] = msg.sender;
        names[newRecordId] = name;
        _tokenIds.increment();
    }

    function valid(string calldata name) public pure returns(bool) {
        return StringUtils.strlen(name) >= 3 && StringUtils.strlen(name) <= 10;
    }

    function getAddress(string calldata name) public view returns (address) {
        return domains[name];
    }

    function setRecord(string calldata name, string calldata record) public {
        if (msg.sender != domains[name]) revert Unauthorized();
        records[name] = record;
        console.log("%s has set a record for %s", msg.sender, name);
    }
    
    function getRecord(string calldata name) public view returns (string memory) {
        if (msg.sender != domains[name]) revert Unauthorized();
        return records[name];
    }

    function getAllNames() public view returns (string[] memory) {
        console.log("Getting all names from contract");
        string[] memory allNames = new string[](_tokenIds.current());
        for (uint i = 0; i < _tokenIds.current(); i++) {
            allNames[i] = names[i];
            console.log("Name for token %d is %s", i, allNames[i]);
        }
        return allNames;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function withdraw() public onlyOwner {
        uint amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw Mantic");
    }

}