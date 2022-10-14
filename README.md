# Huff Runner

Minimal Huff Deployment Library.

The following functions are exposed by importing.

| signature                                                                | functionality              |
| ------------------------------------------------------------------------ | -------------------------- |
| `compile(Vm vm, string memory path) returns (bytes memory)`              | compiles huff file by path |
| `create(bytes bytecode, uint256 value) returns (address)`                | deploys with create        |
| `create2(bytes bytecode, uint256 value, bytes32 salt) returns (bytes32)` | deploys with create2       |
| `appendArgs(bytes bytecode, bytes32[] memory args)`                      | appends args to bytecode   |
