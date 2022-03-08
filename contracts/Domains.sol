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

    string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="-10 6 336.25772950053215 344" width="270" height="270" style="background-color: #228B22"><path fill="url(#B)" /><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="390" width="560"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M248.93 6s-31.05 25.19 -44.59 64.92a229.19 229.19 0 0 0 -10.6 43.9c-18 3.79 -50.9 24.49 -50.9 24.49l-25.18 -2.75 8.67 13.23 -25.95 4.14 11.38 10.77 -21.84 -1L92.35 173l-19.43 -0.49 1.93 15 -17 -3.25 1.93 17.08L46.2 198.64l-0.45 13.94 -21.4 -3.41 1.93 16.12L0.46 232.86V350H128.83l48.62 -83.71 -25.89 -33.15 9.09 -7.11 31.95 40.9c3.24 3.23 6.66 6.24 9 7.23 12.73 5.4 38.32 6 50.11 13.17 6.65 4 14.66 19.38 21.95 22.09a12.31 12.31 0 0 0 3.91 0.48c6.38 0 16.29 -2.26 16.29 -2.26l9 8.8 8.38 -7.23 -22 -22.66 8.23 -8.09 23.29 23.93 1.57 -1.11s7 -39.16 2.31 -51c-5.6 -14.08 -32.9 -31.69 -41.17 -44.38 -6.81 -10.42 -12.23 -35.86 -19.76 -45.7 -7.32 -9.69 -22.43 -24.32 -37.53 -34.45a228.43 228.43 0 0 0 18.31 -41C258 45.05 249 6 249 6Zm47.36 15.72s-15.83 8.22 -33.05 24.46a155.29 155.29 0 0 1 -7.85 42.39 259 259 0 0 1 -14.14 33.79c2.36 1.81 4.65 3.68 6.89 5.57a257.46 257.46 0 0 0 23.69 -31.74C294.36 60.9 296.29 21.72 296.29 21.72Zm-62.2 154.83a11 11 0 1 1 -11 11h0A11 11 0 0 1 234.09 176.55Zm77 73.73c1.93 0 3.52 5.06 3.52 11.36S313 273 311 273s-3.51 -5.08 -3.51 -11.35 1.58 -11.38 3.51 -11.38Z" fill="#F0E68C"/><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#cb5eee"/><stop offset="1" stop-color="#0cd7e4" stop-opacity="0.99"/></linearGradient></defs><text x="3" y="322" font-size="20" fill="#2E8B57" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
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