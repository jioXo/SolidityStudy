// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
import "./33ERC721.sol";

/**
MerkleProof库有三个函数：

 verify()函数：利用proof数来验证leaf是否属于根为root的Merkle Tree中，如果是，则返回true。它调用了processProof()函数。
 processProof()函数：利用proof和leaf依次计算出Merkle Tree的root。它调用了_hashPair()函数。
 _hashPair()函数：用keccak256()函数计算非根节点对应的两个子节点的哈希（排序后）。
*/
library MerkleProof {
    /**
     * @dev 当通过`proof`和`leaf`重建出的`root`与给定的`root`相等时，返回`true`，数据有效。
     * 在重建时，叶子节点对和元素对都是排序过的。
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Returns 通过Merkle树用`leaf`和`proof`计算出`root`. 当重建出的`root`和给定的`root`相同时，`proof`才是有效的。
     * 在重建时，叶子节点对和元素对都是排序过的。
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    // Sorted Pair Hash
    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a, b)) : keccak256(abi.encodePacked(b, a));
    }
}

/**
合约中共有两个状态变量：

root存储了Merkle Tree的根，部署合约的时候赋值。
mintedAddress是一个mapping，记录了已经mint过的地址，某地址mint成功后进行赋值。

函数
合约中共有4个函数：

构造函数：初始化NFT的名称和代号，还有Merkle Tree的root。
mint()函数：利用白名单铸造NFT。参数为白名单地址account，铸造的tokenId，和proof。首先验证address是否在白名单中，然后验证该地址是否还未铸造，验证通过则先把该地址记录到mintedAddress中防止重入攻击，然后把序号为tokenId的NFT铸造给该地址。此过程中调用了_leaf()和_verify()函数。
_leaf()函数：计算了Merkle Tree的叶子地址的哈希。
_verify()函数：调用了MerkleProof库的verify()函数，进行Merkle Tree验证。
*/
contract MerkleTree is ERC721 {
    bytes32 immutable public root; // Merkle树的根
    mapping(address => bool) public mintedAddress;   // 记录已经mint的地址

    // 构造函数，初始化NFT合集的名称、代号、Merkle树的根
    constructor(string memory name, string memory symbol, bytes32 merkleroot)
    ERC721(name, symbol)
    {
        root = merkleroot;
    }

    // 利用Merkle树验证地址并完成mint
    function mint(address account, uint256 tokenId, bytes32[] calldata proof)
    external
    {
        require(_verify(_leaf(account), proof), "Invalid merkle proof"); // Merkle检验通过
        require(!mintedAddress[account], "Already minted!"); // 地址没有mint过

        mintedAddress[account] = true; // 记录mint过的地址
        _mint(account, tokenId); // mint
    }

    // 计算Merkle树叶子的哈希值
    function _leaf(address account)
    internal pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(account));
    }

    // Merkle树验证，调用MerkleProof库的verify()函数
    function _verify(bytes32 leaf, bytes32[] memory proof)
    internal view returns (bool)
    {
        return MerkleProof.verify(proof, root, leaf);
    }
}
