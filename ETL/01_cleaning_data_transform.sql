-- =========================================
-- CLEANING STAGING (PMS, FNB, LAUNDRY)
-- =========================================

-- ===== PMS =====
-- tamu: trim string + isi null seperlunya
UPDATE stg_pms.tamu
SET
  kode_tamu       = NULLIF(TRIM(kode_tamu), ''),
  kewarganegaraan = COALESCE(NULLIF(TRIM(kewarganegaraan), ''), 'Tidak diketahui'),
  tipe_tamu       = COALESCE(NULLIF(TRIM(tipe_tamu), ''), 'Tidak diketahui');

-- tipe_kamar: trim
UPDATE stg_pms.tipe_kamar
SET
  kode_tipe_kamar = NULLIF(TRIM(kode_tipe_kamar), ''),
  nama_tipe       = COALESCE(NULLIF(TRIM(nama_tipe), ''), 'Tidak diketahui');

-- kamar: trim
UPDATE stg_pms.kamar
SET
  kode_kamar  = NULLIF(TRIM(kode_kamar), ''),
  nomor_kamar = NULLIF(TRIM(nomor_kamar), '');

-- reservasi: pastikan checkin < checkout (kalau kebalik, swap)
UPDATE stg_pms.reservasi
SET
  tanggal_checkin  = LEAST(tanggal_checkin, tanggal_checkout),
  tanggal_checkout = GREATEST(tanggal_checkin, tanggal_checkout)
WHERE tanggal_checkin IS NOT NULL
  AND tanggal_checkout IS NOT NULL
  AND tanggal_checkin > tanggal_checkout;

-- reservasi_kamar: jumlah malam minimal 1
UPDATE stg_pms.reservasi_kamar
SET jumlah_malam = 1
WHERE jumlah_malam IS NULL OR jumlah_malam <= 0;

-- tarif_tipe_kamar (log): berlaku_sampai >= berlaku_dari
UPDATE stg_pms.tarif_tipe_kamar
SET berlaku_sampai = NULL
WHERE berlaku_sampai IS NOT NULL AND berlaku_sampai < berlaku_dari;


-- ===== FNB =====
UPDATE stg_fnb.kategori_menu
SET nama_kategori = COALESCE(NULLIF(TRIM(nama_kategori), ''), 'Tidak diketahui');

UPDATE stg_fnb.menu
SET
  kode_menu = NULLIF(TRIM(kode_menu), ''),
  nama_menu = COALESCE(NULLIF(TRIM(nama_menu), ''), 'Tidak diketahui');

-- pesanan: normalisasi waktu_pesan (pastikan bukan string kosong)
-- (kalau waktu_pesan sudah timestamp, ini aman; kalau ada null tetap null)
UPDATE stg_fnb.pesanan
SET waktu_pesan = waktu_pesan
WHERE waktu_pesan IS NOT NULL;

-- detail_pesanan: jumlah minimal 1, subtotal minimal 0
UPDATE stg_fnb.detail_pesanan
SET jumlah = 1
WHERE jumlah IS NULL OR jumlah <= 0;

UPDATE stg_fnb.detail_pesanan
SET subtotal = 0
WHERE subtotal IS NULL OR subtotal < 0;

-- harga_menu (log): periode valid
UPDATE stg_fnb.harga_menu
SET berlaku_sampai = NULL
WHERE berlaku_sampai IS NOT NULL AND berlaku_sampai < berlaku_dari;


-- ===== LAUNDRY =====
UPDATE stg_laundry.kategori_laundry
SET nama_kategori = COALESCE(NULLIF(TRIM(nama_kategori), ''), 'Tidak diketahui');

UPDATE stg_laundry.layanan_laundry
SET nama_layanan = COALESCE(NULLIF(TRIM(nama_layanan), ''), 'Tidak diketahui');

-- pesanan_laundry: tanggal valid (kalau keluar < masuk, swap)
UPDATE stg_laundry.pesanan_laundry
SET
  tanggal_masuk  = LEAST(tanggal_masuk, tanggal_keluar),
  tanggal_keluar = GREATEST(tanggal_masuk, tanggal_keluar)
WHERE tanggal_masuk IS NOT NULL
  AND tanggal_keluar IS NOT NULL
  AND tanggal_masuk > tanggal_keluar;

-- detail_pesanan_laundry: jumlah minimal 1, subtotal minimal 0
UPDATE stg_laundry.detail_pesanan_laundry
SET jumlah = 1
WHERE jumlah IS NULL OR jumlah <= 0;

UPDATE stg_laundry.detail_pesanan_laundry
SET subtotal = 0
WHERE subtotal IS NULL OR subtotal < 0;

-- harga_laundry (log): periode valid
UPDATE stg_laundry.harga_laundry
SET berlaku_sampai = NULL
WHERE berlaku_sampai IS NOT NULL AND berlaku_sampai < berlaku_dari;
