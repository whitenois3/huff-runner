// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {compile, create, create2, appendArgs} from "src/Deploy.sol";

using { compile } for Vm;
using { appendArgs, create, create2 } for bytes;

address constant mockDeployment = address(0xCe71065D4017F316EC606Fe4422e11eB2c47c246);

bytes32 constant salt = 0x713e2693e50c074b604477dac814a71316b96441e6c214c3755e73aa144608d8;
address constant mockDeployment2 = address(0xA23399c32fb4D4B9FEBB93302509808A599ed0fc);

contract DeployTest is Test {

    function testCompile() public {
        bytes memory mockBytecode = hex"600a8060093d393df3600160005260206000f3";

        assertEq(
            mockBytecode,
            vm.compile("test/mocks/Mock.huff")
        );
    }

    function testCreate() public {
        address deployment = vm.compile("test/mocks/Mock.huff").create({value: 0});

        assertEq(deployment, mockDeployment);
    }

    function testCreateWithValue() public {
        address deployment = vm.compile("test/mocks/Mock.huff").create({value: 1});

        assertEq(1, deployment.balance);
    }

    function testCreate2() public {
        address deployment = vm.compile("test/mocks/Mock.huff").create2({ value: 0, salt: salt });

        assertEq(deployment, mockDeployment2);
    }

    function testCreateWithArgs() public {
        bytes32[] memory args = new bytes32[](1);
        args[0] = salt;

        (bool success, bytes memory data) = vm.compile("test/mocks/MockWithArg.huff")
            .appendArgs(args)
            .create({value: 0})
            .call(new bytes(0));

        require(success, "failed call");

        assertEq(salt, abi.decode(data, (bytes32)));
    }
}
