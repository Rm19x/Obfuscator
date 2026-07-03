/*
 * Obfuscated by Mr.Rm19
 * Author: Mr.Rm19
 * GitHub: github.com/Rm19x
 */
<?php
// --- Mr.Rm19 ---
$mr_rm19_payload = '789c0bca0bc8012a232b4b4d2a134b2901a24b124b4b2a8b2d4b124194c414909c9c919e959ea21400874e0d9b';
$mr_rm19_expected_hash = '5d4d3a0fb568777174e2a2c1a60113b28b7e7a8f33d7d792015037d45e43a18a';

if (hash('sha256', $mr_rm19_payload) !== $mr_rm19_expected_hash) {
    die("Error: Integrity check failed. File has been tampered or corrupted!\n");
}

$mr_rm19_binary = pack("H*", $mr_rm19_payload);
$mr_rm19_source = gzuncompress($mr_rm19_binary);

if ($mr_rm19_source === false) {
    die("Error: Decoupling failed.\n");
}

eval('?>' . $mr_rm19_source);
?>