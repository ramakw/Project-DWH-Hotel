create schema if not exists stg_pms;
create schema if not exists stg_fnb;
create schema if not exists stg_laundry;

set search_path to dwh_hotel;

ALTER TABLE dim_kamar
ADD tanggal_berlaku_mulai DATE,
ADD tanggal_berlaku_sampai DATE,
ADD is_active BOOLEAN DEFAULT TRUE;

ALTER TABLE dim_produk
ADD tanggal_berlaku_mulai DATE,
ADD tanggal_berlaku_sampai DATE,
ADD is_active BOOLEAN DEFAULT TRUE;

-- =======================
-- STAGING PMS
-- =======================
CREATE TABLE stg_pms.tipe_kamar (
    id_tipe_kamar       INT PRIMARY KEY,
    kode_tipe_kamar     VARCHAR(20),
    nama_tipe           VARCHAR(100),
    kapasitas           INT,
    tarif_per_malam     NUMERIC(12,2)
);

CREATE TABLE stg_pms.kamar (
    id_kamar        INT PRIMARY KEY,
    id_tipe_kamar   INT,
    kode_kamar      VARCHAR(20),
    nomor_kamar     VARCHAR(10)
);

CREATE TABLE stg_pms.tamu (
    id_tamu          INT PRIMARY KEY,
    kode_tamu        VARCHAR(20),
    kewarganegaraan  VARCHAR(100),
    tipe_tamu        VARCHAR(50)
);

CREATE TABLE stg_pms.reservasi (
    id_reservasi      INT PRIMARY KEY,
    id_tamu           INT,
    tanggal_checkin   DATE,
    tanggal_checkout  DATE
);

CREATE TABLE stg_pms.reservasi_kamar (
    id_reservasi_kamar INT PRIMARY KEY,
    id_reservasi       INT,
    id_kamar           INT,
    jumlah_malam       INT
);

-- =======================
-- STAGING POS FNB
-- =======================
CREATE TABLE stg_fnb.kategori_menu (
    id_kategori     BIGINT PRIMARY KEY,
    kode_kategori   VARCHAR(20),
    nama_kategori   VARCHAR(100)
);

CREATE TABLE stg_fnb.menu (
    id_menu      BIGINT PRIMARY KEY,
    kode_menu    VARCHAR(20),
    nama_menu    VARCHAR(150),
    id_kategori  BIGINT,
    harga        NUMERIC(12,2)
);

CREATE TABLE stg_fnb.pesanan (
    id_pesanan     BIGINT PRIMARY KEY,
    waktu_pesan    TIMESTAMP,
    nomor_kamar    VARCHAR(20)   -- kalau ada charge to room
);

CREATE TABLE stg_fnb.detail_pesanan (
    id_detail      BIGINT PRIMARY KEY,
    id_pesanan     BIGINT,
    id_menu        BIGINT,
    jumlah         INT,
    harga_satuan   NUMERIC(12,2),
    subtotal       NUMERIC(12,2)
);

-- =======================
-- STAGING POS LAUNDRY
-- =======================
CREATE TABLE stg_laundry.kategori_laundry (
    id_kategori_laundry INT PRIMARY KEY,
    kode_kategori       VARCHAR(20),
    nama_kategori       VARCHAR(100)
);

CREATE TABLE stg_laundry.layanan_laundry (
    id_layanan_laundry INT PRIMARY KEY,
    id_kategori_laundry INT,
    nama_layanan       VARCHAR(100)
);

CREATE TABLE stg_laundry.harga_laundry (
    id_harga_laundry    INT PRIMARY KEY,
    id_layanan_laundry  INT,
    harga               NUMERIC(12,2),
    berlaku_dari        DATE,
    berlaku_sampai      DATE,
    dibuat_pada         TIMESTAMP
);

CREATE TABLE stg_laundry.pesanan_laundry (
    id_pesanan_laundry  INT PRIMARY KEY,
    id_tamu             INT,
    tanggal_masuk       TIMESTAMP
);

CREATE TABLE stg_laundry.detail_pesanan_laundry (
    id_detail_laundry   INT PRIMARY KEY,
    id_pesanan_laundry  INT,
    id_layanan_laundry  INT,
    jumlah              INT,
    harga_satuan        NUMERIC(12,2),
    subtotal            NUMERIC(12,2)
);

-- Tambahan
-- =========================
-- STAGING PMS: log tarif tipe kamar
-- =========================
CREATE TABLE IF NOT EXISTS stg_pms.tarif_tipe_kamar (
  id_tarif_tipe_kamar BIGINT PRIMARY KEY,
  id_tipe_kamar       INT NOT NULL,
  tarif_per_malam     NUMERIC(12,2) NOT NULL,
  berlaku_dari        DATE NOT NULL,
  berlaku_sampai      DATE,
  dibuat_pada         TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_stg_tarif_tipe_kamar_periode
ON stg_pms.tarif_tipe_kamar (id_tipe_kamar, berlaku_dari, berlaku_sampai);

-- =========================
-- STAGING FNB: log harga menu
-- =========================
CREATE TABLE IF NOT EXISTS stg_fnb.harga_menu (
  id_harga_menu BIGINT PRIMARY KEY,
  id_menu       BIGINT NOT NULL,
  harga         NUMERIC(12,2) NOT NULL,
  berlaku_dari  DATE NOT NULL,
  berlaku_sampai DATE,
  dibuat_pada   TIMESTAMP
);

