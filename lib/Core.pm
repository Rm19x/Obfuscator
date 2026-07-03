package lib::Core;

use strict;
use warnings;
use Carp;

# =========================================================================
#  SOFTWARE   : Obfuscator by Mr.Rm19
#  AUTHOR     : Mr.Rm19
#  GITHUB     : github.com/Rm19x
#  LICENSE    : Open Source - Copyright (c) 2026 Mr.Rm19
# =========================================================================

our $VERSION = '1.0';

sub new {
    my ($class, %args) = @_;
    
    my $self = {
        input_file  => $args{input_file}  || undef,
        output_file => $args{output_file} || undef,
        raw_content => '',
        php_blocks  => [],
        registry    => {
            variables => {},
            functions => {},
            classes   => {},
        },
        copyright_header => "/*\n" .
                            " * Obfuscated by Mr.Rm19\n" .
                            " * Author: Mr.Rm19\n" .
                            " * GitHub: github.com/Rm19x\n" .
                            " * Protected by Mr.Rm19\n" .
                            " */\n"
    };

    bless $self, $class;
    return $self;
}

sub load_file {
    my ($self) = @_;
    my $file = $self->{input_file};

    unless (defined $file && -e $file) {
        croak "[Error by Mr.Rm19] Input file tidak ditemukan atau tidak ditentukan!\n";
    }

    open(my $fh, '<', $file) or croak "[Error by Mr.Rm19] Tidak bisa membuka file $file: $!\n";
    local $/; # Membaca seluruh file sekaligus (slurp mode)
    $self->{raw_content} = <$fh>;
    close($fh);

    return 1;
}

# Fungsi memisahkan kode PHP dengan kode HTML luar (Tokenization)
sub tokenize_php {
    my ($self) = @_;
    my $content = $self->{raw_content};
    
    my @blocks;
    while ($content =~ /(<\?php|\<\?)(.*?)((\?>)|$)/gs) {
        push @blocks, $2; # Menyimpan konten PHP tanpa tag-nya
    }
    
    $self->{php_blocks} = \@blocks;
    return scalar(@blocks);
}

sub run_obfuscation {
    my ($self) = @_;

    print "[Obfuscator by Mr.Rm19] Memulai proses analisis kode...\n";
    $self->load_file();
    $self->tokenize_php();

    if (scalar(@{$self->{php_blocks}}) == 0) {
        print "[Warning by Mr.Rm19] Tidak ada blok kode PHP valid yang terdeteksi.\n";
        return 0;
    }

    foreach my $block (@{$self->{php_blocks}}) {
        
        $block = $self->_remove_comments($block);


    }

    return 1;
}

sub _remove_comments {
    my ($self, $code) = @_;

    $code =~ s/\/\*.*?\*\///gs;

    $code =~ s/\/\/.*$/ /gm;
    $code =~ s/#.*$/ /gm;

    return $code;
}

sub save_file {
    my ($self) = @_;
    my $output = $self->{output_file};

    unless (defined $output) {
        croak "[Error by Mr.Rm19] File output belum ditentukan!\n";
    }

    open(my $fh, '>', $output) or croak "[Error by Mr.Rm19] Tidak bisa menulis ke file $output: $!\n";
    
    print $fh $self->{copyright_header};
    
    foreach my $block (@{$self->{php_blocks}}) {
        print $fh "<?php\n" . $block . "\n?>";
    }

    close($fh);
    print "[Obfuscator by Mr.Rm19] Sukses! File aman disimpan di: $output\n";
    return 1;
}

1;
