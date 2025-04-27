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

    event LicenseUpdated(
        uint256 indexed licenseId,
        string newAgreementIPFSHash,
        uint256 timestamp
    );

    event LicenseDeleted(
        uint256 indexed licenseId,
        uint256 timestamp
    );

    modifier onlyLicensor(uint256 _licenseId) {
        require(licenses[_licenseId].licensor == msg.sender, "Only the licensor can perform this action");
        _;
    }

    modifier onlyLicensee(uint256 _licenseId) {
        require(licenses[_licenseId].licensee == msg.sender, "Only the licensee can perform this action");
        _;
    }

    function createLicense(address _licensee, string calldata _ipfsHash) external {
        licenseCounter++;
        licenses[licenseCounter] = License(msg.sender, _licensee, _ipfsHash, block.timestamp);
        emit LicenseCreated(licenseCounter, msg.sender, _licensee, _ipfsHash, block.timestamp);
    }

    function updateLicense(uint256 _licenseId, string calldata _newIpfsHash) external onlyLicensor(_licenseId) {
        License storage license = licenses[_licenseId];
        license.agreementIPFSHash = _newIpfsHash;
        license.timestamp = block.timestamp;
        emit LicenseUpdated(_licenseId, _newIpfsHash, block.timestamp);
    }

    function deleteLicense(uint256 _licenseId) external onlyLicensor(_licenseId) {
        delete licenses[_licenseId];
        emit LicenseDeleted(_licenseId, block.timestamp);
    }

    function getLicense(uint256 _licenseId) external view returns (License memory) {
        require(_licenseId > 0 && _licenseId <= licenseCounter, "Invalid license ID");
        return licenses[_licenseId];
    }

    // New functions:

    // Transfer license to another licensee
    function transferLicense(uint256 _licenseId, address _newLicensee) external onlyLicensee(_licenseId) {
        licenses[_licenseId].licensee = _newLicensee;
    }

    // Check if a license exists
    function licenseExists(uint256 _licenseId) external view returns (bool) {
        return licenses[_licenseId].licensor != address(0);
    }

    // Get all license IDs for a particular user (both licensor and licensee)
    function getUserLicenses(address _user) external view returns (uint256[] memory) {
        uint256 count = 0;
        for (uint256 i = 1; i <= licenseCounter; i++) {
            if (licenses[i].licensor == _user || licenses[i].licensee == _user) {
                count++;
            }
        }

        uint256[] memory userLicenses = new uint256[](count);
        uint256 index = 0;
        for (uint256 i = 1; i <= licenseCounter; i++) {
            if (licenses[i].licensor == _user || licenses[i].licensee == _user) {
                userLicenses[index] = i;
                index++;
            }
        }

        return userLicenses;
    }

    // Allow licensor to change the licensee
    function changeLicensee(uint256 _licenseId, address _newLicensee) external onlyLicensor(_licenseId) {
        licenses[_licenseId].licensee = _newLicensee;
    }
}

