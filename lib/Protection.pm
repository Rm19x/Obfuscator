package lib::Protection;

use strict;
use warnings;
use Digest::SHA qw(sha256_hex);
use Compress::Zlib;

# =========================================================================
#  SOFTWARE   : Obfuscator by Mr.Rm19
#  AUTHOR     : Mr.Rm19
#  GITHUB     : github.com/Rm19x
#  LICENSE    : Open Source - Copyright (c) 2026 Mr.Rm19
# =========================================================================

our $VERSION = '1.0';

sub apply {
    my ($class, $php_code) = @_;

    my $compressed_data = compress($php_code);
    
    my $hex_payload = unpack("H*", $compressed_data);

    my $integrity_hash = sha256_hex($hex_payload);

    my $protected_stub = $class->_generate_runtime_stub($hex_payload, $integrity_hash);

    return $protected_stub;
}

sub _generate_runtime_stub {
    my ($self, $payload, $hash) = @_;

    my $stub = <<'EOF';
// --- Mr.Rm19 Engine Pack Runtime Loader ---
$mr_rm19_payload = '%s';
$mr_rm19_expected_hash = '%s';

// Fitur No. 50: Anti-Tamper Verification
// Memastikan payload kode tidak dimodifikasi atau dirusak oleh orang lain
if (hash('sha256', $mr_rm19_payload) !== $mr_rm19_expected_hash) {
    die("Error: Integrity check failed. File has been tampered or corrupted!\n");
}

// Fitur No. 39: Dekompresi Runtime
// Mengembalikan bentuk biner dari hex, lalu melakukan decompress gzuncompress
$mr_rm19_binary = pack("H*", $mr_rm19_payload);
$mr_rm19_source = gzuncompress($mr_rm19_binary);

if ($mr_rm19_source === false) {
    die("Error: Decoupling failed.\n");
}

// Eksekusi kode asli yang sudah aman di dalam memori
eval('?>' . $mr_rm19_source);
EOF

    return sprintf($stub, $payload, $hash);
}

1;