#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;
use Getopt::Long;

# Mengarahkan Perl agar bisa menemukan modul di dalam folder 'lib'
use lib dirname(__FILE__);
use lib::Core;
use lib::NameMangler;
use lib::JunkGenerator;
use lib::Encoder;
use lib::Protection;

# =========================================================================
#  SOFTWARE   : Obfuscator by Mr.Rm19
#  AUTHOR     : Mr.Rm19
#  GITHUB     : github.com/Rm19x
#  LICENSE    : Open Source - Copyright (c) 2026 Mr.Rm19
# =========================================================================

sub show_banner {
    print <<"EOF";
============================================================
  ____  ___ ___                            _             
 / __ \\|  _ \\_ _|_   _ ___  ___ __ _ _ __ | |_ ___  _ __ 
/ / _` | |_) | | | | | / __|/ __/ _` | '_ \\| __/ _ \\| '__|
| |(_| |  _ <| | | |_| \\__ \\ (_| (_| | |_) | || (_) | |   
\\\\__,_|_| \\_\\___| \\__,_|___/\\___\\__,_| .__/ \\__\\___/|_|   
                                     |_|                  
                 BY: Mr.Rm19
         GitHub: github.com/Rm19x
============================================================
[+] Engine Version: 1.0 (Stable)
[+] Multi-Layer Obfuscation for PHP
------------------------------------------------------------
EOF
}

sub show_usage {
    print "Penggunaan:\n";
    print "  perl mr_rm19_obfuscator.pl -i <file_input.php> -o <file_output.php>\n\n";
    print "Argumen:\n";
    print "  -i, --input   : Jalur (path) ke file PHP asli yang ingin diacak.\n";
    print "  -o, --output  : Jalur (path) untuk menyimpan file hasil obfuscation.\n";
    print "  -h, --help    : Menampilkan menu bantuan ini.\n";
    exit(1);
}

sub main {
    my $input_file  = '';
    my $output_file = '';
    my $help        = 0;

    # Membaca argumen dari command line
    GetOptions(
        'input|i=s'  => \$input_file,
        'output|o=s' => \$output_file,
        'help|h'     => \$help,
    ) or show_usage();

    show_banner();

    if ($help || !$input_file || !$output_file) {
        show_usage();
    }

    my $core = lib::Core->new(
        input_file  => $input_file,
        output_file => $output_file
    );

    print "[*] Membaca file target: $input_file\n";
    $core->load_file();
    
    print "[*] Memisahkan blok kode PHP...\n";
    my $block_count = $core->tokenize_php();
    print "[+] Menemukan $block_count blok kode PHP valid.\n";

    if ($block_count == 0) {
        print "[-] Proses dihentikan: Tidak ada kode PHP yang bisa diolah.\n";
        exit(1);
    }

    print "[*] Menjalankan mesin pengacak otomatis...\n";
    
    foreach my $block (@{$core->{php_blocks}}) {
        $block = $core->_remove_comments($block);

        $block = lib::NameMangler->mangle($block, $core->{registry});

        $block = lib::JunkGenerator->inject($block);

        $block = lib::Encoder->encode($block);

        $block = lib::Protection->apply($block);
    }

    print "[*] Menyusun struktur akhir file teks...\n";
    $core->save_file();

    print "\n[+] SELESAI! Project-mu siap di-upload ke GitHub, Mr.Rm19!\n";
}

main();