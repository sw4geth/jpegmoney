pragma solidity 0.8.4;

interface IVaultMetaRegistry {
    function getMetaProvider(address vault_address) external view returns (address);
}
