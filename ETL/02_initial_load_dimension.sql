SET search_path TO dwh_hotel;

-- -------------------------
-- DIMENSI TAMU
-- -------------------------
INSERT INTO dim_tamu (
    id_tamu_sumber,
    kode_tamu,
    kewarganegaraan,
    tipe_tamu
)
SELECT DISTINCT
    t.id_tamu       AS id_tamu_sumber,
    t.kode_tamu,
    t.kewarganegaraan,
    t.tipe_tamu
FROM stg_pms.tamu t;

-- -------------------------
-- DIMENSI KAMAR
-- -------------------------
INSERT INTO dim_kamar (
    id_kamar_sumber,
    id_tipe_kamar_sumber,
    kode_kamar,
    nomor_kamar,
    kode_tipe_kamar,
    nama_tipe_kamar
)
SELECT
    k.id_kamar          AS id_kamar_sumber,
    k.id_tipe_kamar     AS id_tipe_kamar_sumber,
    k.kode_kamar,
    k.nomor_kamar,
    tk.kode_tipe_kamar,
    tk.nama_tipe        AS nama_tipe_kamar
FROM stg_pms.kamar k
JOIN stg_pms.tipe_kamar tk
      ON k.id_tipe_kamar = tk.id_tipe_kamar;

-- -------------------------
-- DIMENSI PRODUK 
-- -------------------------
-- =====================================================
-- A) ROOM (tarif_tipe_kamar dari PMS)
-- =====================================================
INSERT INTO dim_produk (
  departemen_pendapatan,
  nama_produk,
  kategori_produk,
  id_tipe_kamar_sumber,
  harga_standar,
  tanggal_berlaku_mulai,
  tanggal_berlaku_sampai,
  is_active
)
SELECT
  'Room' AS departemen_pendapatan,
  COALESCE(tk.nama_tipe, 'Tipe Kamar ' || t.id_tipe_kamar::text) AS nama_produk,
  'Kamar' AS kategori_produk,
  t.id_tipe_kamar AS id_tipe_kamar_sumber,
  t.tarif_per_malam AS harga_standar,
  t.berlaku_dari AS tanggal_berlaku_mulai,
  COALESCE(t.berlaku_sampai, DATE '9999-12-31') AS tanggal_berlaku_sampai,
  (t.berlaku_sampai IS NULL) AS is_active
FROM stg_pms.tarif_tipe_kamar t
LEFT JOIN stg_pms.tipe_kamar tk
  ON tk.id_tipe_kamar = t.id_tipe_kamar;

-- =====================================================
-- B) FNB (harga_menu dari FNB)
-- =====================================================
INSERT INTO dim_produk (
  departemen_pendapatan,
  nama_produk,
  kategori_produk,
  id_menu_sumber,
  harga_standar,
  tanggal_berlaku_mulai,
  tanggal_berlaku_sampai,
  is_active
)
SELECT
  'FNB' AS departemen_pendapatan,
  COALESCE(m.nama_menu, 'Menu ' || h.id_menu::text) AS nama_produk,
  COALESCE(km.nama_kategori, 'Tidak diketahui') AS kategori_produk,
  h.id_menu AS id_menu_sumber,
  h.harga AS harga_standar,
  h.berlaku_dari AS tanggal_berlaku_mulai,
  COALESCE(h.berlaku_sampai, DATE '9999-12-31') AS tanggal_berlaku_sampai,
  (h.berlaku_sampai IS NULL) AS is_active
FROM stg_fnb.harga_menu h
LEFT JOIN stg_fnb.menu m
  ON m.id_menu = h.id_menu
LEFT JOIN stg_fnb.kategori_menu km
  ON km.id_kategori = m.id_kategori;

-- =====================================================
-- C) LAUNDRY (harga_laundry dari Laundry)
-- =====================================================
INSERT INTO dim_produk (
  departemen_pendapatan,
  nama_produk,
  kategori_produk,
  id_layanan_laundry_sumber,
  harga_standar,
  tanggal_berlaku_mulai,
  tanggal_berlaku_sampai,
  is_active
)
SELECT
  'Laundry' AS departemen_pendapatan,
  COALESCE(l.nama_layanan, 'Layanan ' || h.id_layanan_laundry::text) AS nama_produk,
  COALESCE(kl.nama_kategori, 'Tidak diketahui') AS kategori_produk,
  h.id_layanan_laundry AS id_layanan_laundry_sumber,
  h.harga AS harga_standar,
  h.berlaku_dari AS tanggal_berlaku_mulai,
  COALESCE(h.berlaku_sampai, DATE '9999-12-31') AS tanggal_berlaku_sampai,
  (h.berlaku_sampai IS NULL) AS is_active
FROM stg_laundry.harga_laundry h
LEFT JOIN stg_laundry.layanan_laundry l
  ON l.id_layanan_laundry = h.id_layanan_laundry
LEFT JOIN stg_laundry.kategori_laundry kl
  ON kl.id_kategori_laundry = l.id_kategori_laundry;



-- -------------------------
-- DIMENSI WAKTU
-- Versi simple: generate dari min-max tanggal di reservasi
-- -------------------------

-- Hapus dulu kalau mau regenerate (opsional, kalau belum ada data bisa dilewat)
-- TRUNCATE TABLE dim_waktu;

WITH batas AS (
    SELECT 
        MIN(tanggal_checkin)  AS min_tanggal,
        MAX(tanggal_checkout) AS max_tanggal
    FROM stg_pms.reservasi
)
INSERT INTO dim_waktu (
    tanggal,
    tahun,
    bulan,
    nama_bulan,
    minggu_tahun,
    hari_bulan,
    nama_hari
)
SELECT
    d::date                                      AS tanggal,
    EXTRACT(YEAR  FROM d)::int                   AS tahun,
    EXTRACT(MONTH FROM d)::int                   AS bulan,
    TO_CHAR(d, 'FMMonth')                        AS nama_bulan,
    EXTRACT(WEEK  FROM d)::int                   AS minggu_tahun,
    EXTRACT(DAY   FROM d)::int                   AS hari_bulan,
    TO_CHAR(d, 'FMDay')                          AS nama_hari
FROM batas b,
     generate_series(b.min_tanggal, b.max_tanggal, interval '1 day') AS d;
