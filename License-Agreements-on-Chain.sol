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
}
