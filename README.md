# Obfuscator by Mr.Rm19

<p align="center">
  <img src="https://img.shields.io/badge/Language-Perl-blue.svg" alt="Perl">
  <img src="https://img.shields.io/badge/Target-PHP-orange.svg" alt="PHP">
  <img src="https://img.shields.io/badge/License-Open%20Source-brightgreen.svg" alt="License">
</p>

**Obfuscator by Mr.Rm19** adalah sebuah *source-code protection* berbasis bahasa **Perl** yang dirancang  untuk mengamankan script **PHP**. Alat ini menerapkan metode *Multi-Layer High-Level Obfuscation* untuk melindungi kekayaan intelektual (*intellectual property*) aplikasi Anda dari analisis statis (*static analysis*) dan upaya pencurian kode (*source code theft*).

---

##  Fitur  

Alat ini mengombinasikan berbagai teknik pengacakan tingkat tinggi yang terbagi dalam beberapa modul:

1. **Advanced Identifier Mangling :** Secara otomatis memburu, mencatat, dan mengubah nama fungsi (*user-defined functions*) serta nama *class* (OOP) menjadi kombinasi karakter acak (`_O0O0OO...`) yang membingungkan mata manusia.
2. **String Mashing via Hex & Octal :** Mentransformasikan seluruh string teks sensitif di dalam kode PHP menjadi representasi *Hexadecimal* (`\x45\x4b`) dan *Octal* (`\101\102`) literal.
3. **High-Level Dead Code Injection :** Menyuntikkan fungsi-fungsi matematika palsu (`sin`, `cos`, `log`, `sqrt`) dengan alur komputasi rumit untuk mengelabui analisis heuristik dan membuang waktu penelaah kode manual.
4. **Dynamic Pointer Manipulation :** Menerapkan teknik *Variable Variables* PHP (`$$$pointer`) untuk memecah assignment variabel standar menjadi tumpukan pointer dinamis di memori.
5. **Logic & Operator Complexity:** Mengubah kata kunci logika standar (`and`, `or`) menjadi operator simbolis, serta mengubah nilai boolean (`true`/`false`) menjadi manipulasi bitwise level rendah (`(!0)` / `(!1)`).
6. **Global Stack Pollution:** Menyuntikkan array superglobal `$GLOBALS` tiruan ke dalam runtime PHP untuk mengalihkan perhatian proses *reverse engineering*.
7. **String Reversing:** Menyimpan string teks sensitif dalam keadaan terbalik secara fisik, lalu menyusunnya kembali saat runtime menggunakan fungsi *native* `strrev()`.
8. **Deflate Gzip Compression:** Memampatkan seluruh struktur kode asli menjadi data biner terkompresi yang kemudian diubah menjadi enkapsulasi string Hex raksasa.
9. **SHA-256 Anti-Tamper Verification :** Mengunci file hasil akhir dengan tanda tangan kriptografi SHA-256. Jika file dimodifikasi secara ilegal (bahkan ditambah satu spasi saja), script akan mendeteksi perubahan tersebut dan langsung menghentikan eksekusi secara total (`die`).

---

## cara pakai
```
perl mr_rm19_obfuscator.pl -h <Menampilkan menu bantuan>

perl mr_rm19_obfuscator.pl -i <Jalur (path) ke file PHP asli yang ingin diacak>

perl mr_rm19_obfuscator.pl -o <Jalur (path) untuk menyimpan file hasil obfuscation>

perl mr_rm19_obfuscator.pl -i <jalur_file_input.php> -o <jalur_file_output.php>

Contoh Uji Coba:

perl mr_rm19_obfuscator.pl -i tests/target_asli.php -o tests/hasil_obfuscated.php
```
---
# Contoh Hasil Pengujian (Uji Coba Internal)
File Input: tests/target_asli.php
```
<?php
// =========================================================================
//  FILE       : target_asli.php
//  DESCRIPTION: Test file sederhana untuk Obfuscator by Mr.Rm19
// =========================================================================

$pesan = "Hallo Dunia by Mr.Rm19";
echo $pesan;
?>
```
File Output Otomatis: tests/hasil_obfuscated.php
```
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
```
#### Project ini bersifat Open Source. Kontribusi untuk pengembangan fitur deteksi AST (Abstract Syntax Tree) yang lebih kompleks sangat terbuka bagi siapa saja.
Mr.Rm19 - ramdan19id@gmail.com
