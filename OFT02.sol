// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./OFT.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/governance/utils/Votes.sol";

contract OFTVotes is OFT, Votes{

    constructor(address _endpoint) OFT("name", "symbol", _endpoint ) EIP712("name","1"){

    }


    error ERC20ExceededSafeSupply(uint256 increasedSupply, uint256 cap);


    function _maxSupply() internal view virtual returns (uint256) {
        return type(uint208).max;
    }


    function _update(address from, address to, uint256 value) internal virtual override {
        super._update(from, to, value);
        if (from == address(0)) {
            uint256 supply = totalSupply();
            uint256 cap = _maxSupply();
            if (supply > cap) {
                revert ERC20ExceededSafeSupply(supply, cap);
            }
        }
        _transferVotingUnits(from, to, value);
    }


    function _getVotingUnits(address account) internal view virtual override returns (uint256) {
        return balanceOf(account);
    }

    function numCheckpoints(address account) public view virtual returns (uint32) {
        return _numCheckpoints(account);
    }


    function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoints.Checkpoint208 memory) {
        return _checkpoints(account, pos);
    }

}
