set search_path to dwh_hotel;

INSERT INTO dim_tamu (
    id_tamu_sumber,
    kode_tamu,
    kewarganegaraan,
    tipe_tamu
)
SELECT DISTINCT
    t.id_tamu,
    t.kode_tamu,
    t.kewarganegaraan,
    t.tipe_tamu
FROM stg_pms.tamu t
ON CONFLICT (id_tamu_sumber)
DO UPDATE SET
    kode_tamu       = EXCLUDED.kode_tamu,
    kewarganegaraan = EXCLUDED.kewarganegaraan,
    tipe_tamu       = EXCLUDED.tipe_tamu;

INSERT INTO dim_kamar (
    id_kamar_sumber,
    id_tipe_kamar_sumber,
    kode_kamar,
    nomor_kamar,
    kode_tipe_kamar,
    nama_tipe_kamar
)
SELECT
    k.id_kamar,
    k.id_tipe_kamar,
    k.kode_kamar,
    k.nomor_kamar,
    tk.kode_tipe_kamar,
    tk.nama_tipe
FROM stg_pms.kamar k
JOIN stg_pms.tipe_kamar tk
      ON k.id_tipe_kamar = tk.id_tipe_kamar
ON CONFLICT (id_kamar_sumber)
DO UPDATE SET
    id_tipe_kamar_sumber = EXCLUDED.id_tipe_kamar_sumber,
    kode_kamar           = EXCLUDED.kode_kamar,
    nomor_kamar          = EXCLUDED.nomor_kamar,
    kode_tipe_kamar      = EXCLUDED.kode_tipe_kamar,
    nama_tipe_kamar      = EXCLUDED.nama_tipe_kamar;
