// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Vm} from "forge-std/Vm.sol";

enum EvmVersion {
    Frontier,
    Homestead,
    Dao,
    Tangerine,
    SpuriousDragon,
    Byzantium,
    Constantinople,
    Petersburg,
    Istanbul,
    MuirGlacier,
    Berlin,
    London,
    ArrowGlacier,
    GrayGlacier,
    Paris,
    Shanghai
}

function compile(Vm vm, string memory path) returns (bytes memory) {
    string[] memory cmd = new string[](3);
    cmd[0] = "huffc";
    cmd[1] = "--bytecode";
    cmd[2] = path;
    return vm.ffi(cmd);
}

function compileWithVersion(Vm vm, string memory path, EvmVersion evmVersion ) returns (bytes memory) {
    string[16] memory evmVersions = [
        "frontier", 
        "homestead", 
        "dao", 
        "tangerine_whistle", 
        "spurious_dragon", 
        "byzantium", 
        "constantinople", 
        "petersburg", 
        "istanbul",
        "muir_glacier",
        "berlin",
        "london",
        "arrow_glacier",
        "gray_glacier",
        "paris",
        "shanghai"
    ];
    string[] memory cmd = new string[](5);
    cmd[0] = "huffc";
    cmd[1] = "--bytecode";
    cmd[2] = path;
    cmd[3] = "--evm-version";
    cmd[4] = evmVersions[uint8(evmVersion)];
    return vm.ffi(cmd);
}

error DeploymentFailure(bytes bytecode);

function create(bytes memory bytecode, uint256 value) returns (address deployedAddress) {
    assembly {
        deployedAddress := create(value, add(bytecode, 0x20), mload(bytecode))
    }

    if (deployedAddress == address(0)) revert DeploymentFailure(bytecode);
}

function create2(
    bytes memory bytecode,
    uint256 value,
    bytes32 salt
) returns (address deployedAddress) {
    assembly {
        deployedAddress := create2(value, add(bytecode, 0x20), mload(bytecode), salt)
    }

    if (deployedAddress == address(0)) revert DeploymentFailure(bytecode);
}

function appendArgs(bytes memory bytecode, bytes32[] memory args) pure returns (bytes memory) {
    return bytes.concat(bytecode, abi.encodePacked(args));
}
