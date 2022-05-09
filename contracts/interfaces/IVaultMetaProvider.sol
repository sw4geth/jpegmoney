pragma solidity 0.8.4;

interface IVaultMetaProvider {
    function getTokenURI(address vault_address, uint256 tokenId) external view returns (string memory);
    function getBaseURI() external view returns (string memory);
}
