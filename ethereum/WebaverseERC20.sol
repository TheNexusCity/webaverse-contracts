// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./ERC20Capped.sol";

/**
 * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
 */
contract WebaverseERC20 is ERC20Capped {
    mapping (address => bool) internal allowedMinters; // whether anyone can mint tokens (should be sidechain only)
    uint256 internal numAllowedMinters;
    
    /**
     * @dev Sets the value of the `cap`. This value is immutable, it can only be
     * set once during construction.
     */
    constructor (string memory name, string memory symbol) public ERC20(name, symbol) ERC20Capped(1e27) {
        allowedMinters[msg.sender] = true;
        numAllowedMinters = 1;
    }
    
    function mint(address account, uint256 amount) public {
        require(isAllowedMinter(msg.sender), "sender is not a minter");
        _mint(account, amount);
    }
    
    function isAllowedMinter(address a) public view returns (bool) {
        return allowedMinters[a];
    }
    function addAllowedMinter(address a) public {
        require(isAllowedMinter(msg.sender), "sender is not a minter");
        require(!isAllowedMinter(a), "target is already a minter");
        allowedMinters[a] = true;
        numAllowedMinters = SafeMath.add(numAllowedMinters, 1);
    }
    function removeAllowedMinter(address a) public {
        require(isAllowedMinter(msg.sender), "sender is not a minter");
        require(isAllowedMinter(a), "target is not a minter");
        require(numAllowedMinters > 1, "cannot remove the only minter");
        allowedMinters[a] = false;
        numAllowedMinters = SafeMath.sub(numAllowedMinters, 1);
    }
}
