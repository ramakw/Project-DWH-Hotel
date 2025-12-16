-- =====================================
-- 0. SCHEMA DWH
-- =====================================
CREATE SCHEMA IF NOT EXISTS dwh_hotel;
SET search_path TO dwh_hotel;

-- =====================================
-- 1. DIMENSI
-- =====================================

-- 1.1 Dimensi Waktu
CREATE TABLE dim_waktu (
    waktu_key    SERIAL PRIMARY KEY,
    tanggal      DATE NOT NULL UNIQUE,
    tahun        INT  NOT NULL,
    bulan        INT  NOT NULL,
    nama_bulan   VARCHAR(20),
    minggu_tahun INT,
    hari_bulan   INT,
    nama_hari    VARCHAR(20)
);

-- 1.2 Dimensi Kamar
--    Bisa tetap simpan harga_per_malam untuk analisis tarif, tapi
--    pendapatan tetap dihitung di fakta_penjualan.
CREATE TABLE dim_kamar (
    kamar_key            SERIAL PRIMARY KEY,
    id_kamar_sumber      INT,          -- ID kamar di OLTP PMS
    id_tipe_kamar_sumber INT,          -- ID tipe kamar di OLTP PMS
    kode_kamar           VARCHAR(20),
    nomor_kamar          VARCHAR(10),
    kode_tipe_kamar      VARCHAR(20),
    nama_tipe_kamar      VARCHAR(100),
    harga_per_malam      NUMERIC(12,2) -- room rate standard (opsional)
);

CREATE UNIQUE INDEX uq_dim_kamar_id_kamar
    ON dim_kamar(id_kamar_sumber)
    WHERE id_kamar_sumber IS NOT NULL;

-- 1.3 Dimensi Tamu
--    Tanpa nama (karena nggak kepakai analisis)
CREATE TABLE dim_tamu (
    tamu_key        SERIAL PRIMARY KEY,
    id_tamu_sumber  INT,             -- ID tamu di OLTP PMS
    kode_tamu       VARCHAR(20),
    kewarganegaraan VARCHAR(100),
    tipe_tamu       VARCHAR(50)      -- Walk-in / Member / Corporate / dsb
);

CREATE UNIQUE INDEX uq_dim_tamu_id_tamu
    ON dim_tamu(id_tamu_sumber)
    WHERE id_tamu_sumber IS NOT NULL;

-- 1.4 Dimensi Produk
--    Sekarang kembali menampung:
--    - Room (tipe kamar)
--    - FNB (menu)
--    - Laundry (layanan)
CREATE TABLE dim_produk (
    produk_key                 BIGSERIAL PRIMARY KEY,
    departemen_pendapatan      VARCHAR(20) NOT NULL,   -- 'Room' / 'FNB' / 'Laundry'
    nama_produk                VARCHAR(150) NOT NULL,  -- nama tipe kamar / menu / layanan
    jenis_produk               VARCHAR(50),            -- 'Kamar' / 'Menu' / 'Layanan'
    kategori_produk            VARCHAR(100),           -- tipe kamar / kategori menu / kategori laundry
    harga_standar              NUMERIC(12,2),

    -- kolom teknis untuk mapping ke OLTP
    id_tipe_kamar_sumber       INT,      -- dari PMS.tipe_kamar
    id_menu_sumber             BIGINT,   -- dari POS FNB.menu
    id_layanan_laundry_sumber  INT       -- dari POS Laundry.layanan_laundry
);

CREATE UNIQUE INDEX uq_dim_produk_tipe_kamar
    ON dim_produk(id_tipe_kamar_sumber)
    WHERE id_tipe_kamar_sumber IS NOT NULL;

CREATE UNIQUE INDEX uq_dim_produk_menu
    ON dim_produk(id_menu_sumber)
    WHERE id_menu_sumber IS NOT NULL;

CREATE UNIQUE INDEX uq_dim_produk_laundry
    ON dim_produk(id_layanan_laundry_sumber)
    WHERE id_layanan_laundry_sumber IS NOT NULL;