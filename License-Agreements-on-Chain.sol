// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LicenseAgreements {
    struct License {
        address licensor;
        address licensee;
        string agreementIPFSHash;
        uint256 timestamp;
    }

    mapping(uint256 => License) public licenses;
    uint256 public licenseCounter;

    event LicenseCreated(
        uint256 indexed licenseId,
        address indexed licensor,
        address indexed licensee,
        string agreementIPFSHash,
        uint256 timestamp
    );

    function createLicense(address _licensee, string calldata _ipfsHash) external {
        licenseCounter++;
        licenses[licenseCounter] = License(msg.sender, _licensee, _ipfsHash, block.timestamp);
        emit LicenseCreated(licenseCounter, msg.sender, _licensee, _ipfsHash, block.timestamp);
    }

    function getLicense(uint256 _licenseId) external view returns (License memory) {
        require(_licenseId > 0 && _licenseId <= licenseCounter, "Invalid license ID");
        return licenses[_licenseId];
    }
}
