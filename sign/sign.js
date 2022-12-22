const sigUtil = require('eth-sig-util')
const ethers = require('ethers');

const privateKey = 'ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'
const signerAddress = '0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266'
const verifyingContract = "0x5fbdb2315678afecb367f032d93f642f64180aa3"

const privateKeyBuffer = Buffer.from(privateKey, 'hex')

const chainId = 1

const value = 12345
const deadline = 1500000000

const typedData = {
    'types': {
        'EIP712Domain': [
            {'name': 'name', 'type': 'string'},
            {'name': 'version', 'type': 'string'},
            {'name': 'chainId', 'type': 'uint256'},
            {'name': 'verifyingContract', 'type': 'address'},
        ],
        'Verify': [
            {'name': 'value', 'type': 'uint256'},
            {'name': 'deadline', 'type': 'uint256'},
        ]
    },
    'primaryType': 'Verify',
    'domain': {
        'name': 'DarkOracle',
        'version': '1',
        'chainId': chainId,
        'verifyingContract': verifyingContract,
    },
    'message': {
        'value': value,
        'deadline': deadline,
    }
}

const signedData = sigUtil.signTypedData(privateKeyBuffer, {
  data: typedData
})

const { v, r, s } = ethers.utils.splitSignature(signedData);

console.log(v);
console.log(r); 
console.log(s);  
