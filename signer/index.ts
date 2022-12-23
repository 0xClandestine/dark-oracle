import { keccak256, defaultAbiCoder, toUtf8Bytes, solidityPack } from "ethers/lib/utils"
import { BigNumberish } from "ethers"
import { ecsign } from "ethereumjs-util"

export const signDigest = (digest: any, privateKey: any) => {
  return ecsign(Buffer.from(digest.slice(2), "hex"), privateKey)
}

export const VERIFY_TYPEHASH = "0x9ab9959c79884673dc2ef5c264e4c0b6be131827bbab8fb5369dd7ddd0d6f78c"

// Returns the EIP712 hash which should be signed by the user
export function computeDigest(
    domainName: string,
    verifyingAddress: string,
    chainId: number,
    value: BigNumberish,
    deadline: BigNumberish
) {
  const DOMAIN_SEPARATOR = computeDomainSeparator(domainName, verifyingAddress, chainId)

  console.log("Domain separator: ", DOMAIN_SEPARATOR)
  
  return keccak256(
    solidityPack(
      ["string", "bytes32", "bytes32"],
      [
        "\x19\x01",
        DOMAIN_SEPARATOR,
        keccak256(
          solidityPack(
            ["bytes32", "uint256", "uint256"],
            [VERIFY_TYPEHASH, value, deadline]
          )
        ),
      ]
    )
  )
}

// Gets the EIP712 domain separator
export function computeDomainSeparator(name: string, verifyingAddress: string, chainId: number) {
  return keccak256(
    defaultAbiCoder.encode(
      ["bytes32", "bytes32", "bytes32", "uint8", "address"],
      [
        keccak256(toUtf8Bytes("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")),
        keccak256(toUtf8Bytes(name)),
        keccak256(toUtf8Bytes("1")),
        chainId,
        verifyingAddress,
      ]
    )
  )
}

const name = "DarkOracle"
const verifyingAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
const privateKey = Buffer.from("ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80", "hex");
const signature = signDigest(computeDigest(name, verifyingAddress, 1, 420, 16717551430), privateKey)
const v = signature.v
const r = "0x" + signature.r.toString("hex")
const s = "0x" + signature.s.toString("hex")

console.log("v: ", v)
console.log("r: ", r)
console.log("s: ", s)