package lib::NameMangler;

use strict;
use warnings;

# =========================================================================
#  SOFTWARE   : Obfuscator by Mr.Rm19
#  AUTHOR     : Mr.Rm19
#  GITHUB     : github.com/Rm19x
#  LICENSE    : Open Source - Copyright (c) 2026 Mr.Rm19
# =========================================================================

our $VERSION = '1.0';

sub mangle {
    my ($class, $php_code, $registry) = @_;

    $php_code = $class->_mangle_classes($php_code, $registry);

    $php_code = $class->_mangle_functions($php_code, $registry);

    $php_code = $class->_apply_variable_variables($php_code);

    $php_code = $class->_inject_fake_globals($php_code);

    return $php_code;
}

sub _generate_confusing_name {
    my ($length) = @_;
    $length ||= 12;
    my @chars = ('O', '0', 'o');
    my $name = '_O'; # by Mr.Rm19
    for (1..$length) {
        $name .= $chars[int(rand(@chars))];
    }
    return $name;
}

sub _mangle_classes {
    my ($self, $code, $registry) = @_;

    # Mencari definisi class: class NamaClass
    while ($code =~ /\bclass\s+([a-zA-Z_][a-zA-Z0-9_]*)/g) {
        my $class_name = $1;
		
        next if exists $registry->{classes}->{$class_name};
        
        $registry->{classes}->{$class_name} = _generate_confusing_name(10);
    }

    foreach my $orig (keys %{$registry->{classes}}) {
        my $new = $registry->{classes}->{$orig};
        $code =~ s/\bclass\s+$orig\b/class $new/g;
        $code =~ s/\bnew\s+$orig\b/new $new/g;
        $code =~ s/\b$orig::/$new::/g;
    }

    return $code;
}

sub _mangle_functions {
    my ($self, $code, $registry) = @_;

    while ($code =~ /\bfunction\s+([a-zA-Z_][a-zA-Z0-9_]*)/g) {
        my $func_name = $1;
        next if $func_name =~ /^_(mr_rm19|GLOBALS)/;
        next if exists $registry->{functions}->{$func_name};

        $registry->{functions}->{$func_name} = _generate_confusing_name(12);
    }

    foreach my $orig (keys %{$registry->{functions}}) {
        my $new = $registry->{functions}->{$orig};
        $code =~ s/\bfunction\s+$orig\b/function $new/g;
        $code =~ s/\b$orig\s*\(/$new(/g;
    }

    return $code;
}

sub _apply_variable_variables {
    my ($self, $code) = @_;

    $code =~ s/\b\$([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*([^;]+);/
        my $var_name = $1;
        my $value = $2;
        
        # Batasi agar tidak merusak variabel superglobal bawaan PHP
        if ($var_name =~ /^(this|GET|POST|SERVER|SESSION|COOKIE|GLOBALS|REQUEST)$/) {
            "\$$var_name = $value;";
        } else {
            my $pointer_var = _generate_confusing_name(6);
            "\$$pointer_var = '$var_name'; \$\$\$$pointer_var = $value;";
        }
    /gex;

    return $code;
}

# Fungsi Internal: Menyisipkan data sampah ke dalam array superglobal $GLOBALS (No. 31)
sub _inject_fake_globals {
    my ($self, $code) = @_;

    my $globals_junk = "\n// --- Global Protection Stack by Mr.Rm19 ---\n";
    
    for (1..3) {
        my $key = _generate_confusing_name(6);
        my $val = int(rand(5000)) + 1000;
        $globals_junk .= "\$GLOBALS['$key'] = $val;\n";
    }

    $code = $globals_junk . $code;

    return $code;
}

1;