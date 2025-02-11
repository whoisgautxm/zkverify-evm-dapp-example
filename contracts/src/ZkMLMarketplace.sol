// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {IZkVerifyAttestation} from "../interface/IZkverifyAttestation.sol";

contract ZkMLMarketplace {
    /// The hash of the identifier of the proving system used (groth16 in this case)
    bytes32 public constant PROVING_SYSTEM_ID =
        keccak256(abi.encodePacked("risc0"));

    /// The address of the ZkvAttestationContract
    address public immutable zkVerify;
    /// The hash of the verification key of the circuit
    bytes32 public immutable vkey;

    /// version hash
    bytes32 public immutable vhash;

    /// A mapping for recording the addresses which have submitted valid proofs
    mapping(address => bool) public hasSubmittedValidProof;

    event SuccessfulProofSubmission(address indexed from);

    constructor(address _zkVerify, bytes32 _vkey, bytes32 _vhash) {
        zkVerify = _zkVerify;
        vkey = _vkey;
        vhash = _vhash;
    }

    // Version hash used to generate a leaf

    // Proof::V1_0: sha256("risc0:v1.0")="0xdf801e3397d2a8fbb77c2fa30c7f7806ee8a60de44cb536108e7ef272618e2da"
    // Proof::V1_1: sha256("risc0:v1.1")="0x2a06d398245e645477a795d1b707344669459840d154e17fde4df2b40eea5558"
    // Proof::V1_2: sha256("risc0:v1.2")="0x5f39e7751602fc8dbc1055078b61e2704565e3271312744119505ab26605a942"


    function checkHash(
    bytes memory _hash,
    uint256 _attestationId,
    bytes32[] calldata _merklePath,
    uint256 _leafCount,
    uint256 _index
) public {

    bytes32 leaf = keccak256(abi.encodePacked(PROVING_SYSTEM_ID, vkey, vhash, keccak256(abi.encodePacked(_hash))));

    require(IZkVerifyAttestation(zkVerify).verifyProofAttestation(
        _attestationId,
        leaf,
        _merklePath,
        _leafCount,
        _index
    ), "Invalid proof");
}

}
