// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "lib/forge-std/src/Script.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }
}
/**forge create --rpc-url "https://eth-sepolia.g.alchemy.com/v2/QF_rlvr4V0ZORimK7ysBA4mJvl0Bk47c" --private-key "c45f85a5ec0d4bd6c655c9fc2c505c3b6576a9d81e73635f77deb457aa68f3d9" src/Proxy1967_UUPS.sol 
forge create --rpc-url "https://eth-sepolia.g.alchemy.com/v2/QF_rlvr4V0ZORimK7ysBA4mJvl0Bk47c" --private-key "c45f85a5ec0d4bd6c655c9fc2c505c3b6576a9d81e73635f77deb457aa68f3d9" src/ImplementacionV1.sol
forge create --rpc-url "https://eth-sepolia.g.alchemy.com/v2/QF_rlvr4V0ZORimK7ysBA4mJvl0Bk47c" --private-key "c45f85a5ec0d4bd6c655c9fc2c505c3b6576a9d81e73635f77deb457aa68f3d9" src/ImplementacionV1.sol
forge create --rpc-url "https://eth-sepolia.g.alchemy.com/v2/QF_rlvr4V0ZORimK7ysBA4mJvl0Bk47c" --private-key "c45f85a5ec0d4bd6c655c9fc2c505c3b6576a9d81e73635f77deb457aa68f3d9" --etherscan-api-key "WJGMIDXZRNYM9QW8EEZATUAEGWF5N521CG" --verify src/ImplementacionV1.sol

$ forge create --rpc-url <your_rpc_url> \
    --constructor-args "ForgeUSD" "FUSD" 18 1000000000000000000000 \
    --private-key <your_private_key> \
    --etherscan-api-key <your_etherscan_api_key> \
    --verify \
    src/MyToken.sol:MyToken*/


