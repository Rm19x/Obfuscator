package lib::Encoder;

use strict;
use warnings;

# =========================================================================
#  SOFTWARE   : Obfuscator by Mr.Rm19
#  AUTHOR     : Mr.Rm19
#  GITHUB     : github.com/Rm19x
#  LICENSE    : Open Source - Copyright (c) 2026 Mr.Rm19
# =========================================================================

our $VERSION = '1.0';

sub encode {
    my ($class, $php_code) = @_;

    $php_code = $class->_obfuscate_operators($php_code);

    $php_code = $class->_encode_strings($php_code);

    return $php_code;
}

sub _encode_strings {
    my ($self, $code) = @_;

    $code =~ s/(['"])(.*?)\1/
        my $quote = $1;
        my $str_content = $2;
        my $result = "";

        # Jika string kosong atau terlalu pendek, biarkan saja agar tidak error
        if (length($str_content) < 2) {
            $quote . $str_content . $quote;
        } else {
            my $choice = int(rand(3)); # Pilih metode encoding secara acak

            if ($choice == 0) {
                # Metode No. 6: Konversi ke Hexadecimal (\x41\x42...)
                my $hex_str = "";
                foreach my $char (split('', $str_content)) {
                    $hex_str .= sprintf("\\x%02X", ord($char));
                }
                "\"$hex_str\"";
            }
            elsif ($choice == 1) {
                # Metode No. 7: Konversi ke Octal (\101\102...)
                my $oct_str = "";
                foreach my $char (split('', $str_content)) {
                    $oct_str .= sprintf("\\%03o", ord($char));
                }
                "\"$oct_str\"";
            }
            else {
                # Metode No. 32: Teknik String Reversing (strrev)
                my $reversed = reverse($str_content);
                # Melindungi jika ada karakter kutip di dalam string hasil reverse
                $reversed =~ s/'/\\'/g;
                "strrev('$reversed')";
            }
        }
    /gex;

    return $code;
}

# Fungsi Internal: Mengubah operator logika bawaan menjadi bentuk yang rumit (No. 20)
sub _obfuscate_operators {
    my ($self, $code) = @_;

    # Mengubah operator kata kunci 'or' / 'and' menjadi simbol standar, 
    
    $code =~ s/\band\b/ && /gi;

    $code =~ s/\bor\b/ || /gi;

    $code =~ s/\btrue\b/(!0)/gi;
    $code =~ s/\bfalse\b/(!1)/gi;

    return $code;
}

1;