// app.js

// Import Web3
if (typeof window.ethereum !== 'undefined') {
    console.log('MetaMask is installed!');
}

const web3 = new Web3(window.ethereum);

// Replace with your contract's ABI and deployed address
const contractABI = [/* ABI array goes here */];
const contractAddress = "0x256e4780ba5b1f8032d7458902a93553df261f13

";

const contract = new web3.eth.Contract(contractABI, contractAddress);

// Connect wallet
async function connectWallet() {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    return accounts[0];
}

// Create a new license
async function createLicense(licensee, ipfsHash) {
    const account = await connectWallet();
    await contract.methods.createLicense(licensee, ipfsHash).send({ from: account });
}

// Update an existing license
async function updateLicense(licenseId, newIpfsHash) {
    const account = await connectWallet();
    await contract.methods.updateLicense(licenseId, newIpfsHash).send({ from: account });
}

// Delete a license
async function deleteLicense(licenseId) {
    const account = await connectWallet();
    await contract.methods.deleteLicense(licenseId).send({ from: account });
}

// Transfer license to another user
async function transferLicense(licenseId, newLicensee) {
    const account = await connectWallet();
    await contract.methods.transferLicense(licenseId, newLicensee).send({ from: account });
}

// Get a license
async function getLicense(licenseId) {
    return await contract.methods.getLicense(licenseId).call();
}

// Get all licenses associated with a user
async function getUserLicenses(userAddress) {
    return await contract.methods.getUserLicenses(userAddress).call();
}

// Change licensee (by licensor)
async function changeLicensee(licenseId, newLicensee) {
    const account = await connectWallet();
    await contract.methods.changeLicensee(licenseId, newLicensee).send({ from: account });
}

// Check if a license exists
async function licenseExists(licenseId) {
    return await contract.methods.licenseExists(licenseId).call();
}

// Sample usage (example)
document.getElementById('createBtn').onclick = async () => {
    const licensee = document.getElementById('licenseeAddress').value;
    const ipfsHash = document.getElementById('ipfsHash').value;
    await createLicense(licensee, ipfsHash);
    alert("License created!");
};
