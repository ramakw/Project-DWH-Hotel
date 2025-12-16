SET search_path TO dwh_hotel;

WITH batas AS (
  SELECT
    LEAST(
      (SELECT MIN(tanggal_checkin) FROM stg_pms.reservasi),
      (SELECT MIN(DATE(waktu_pesan)) FROM stg_fnb.pesanan),
      (SELECT MIN(DATE(tanggal_masuk)) FROM stg_laundry.pesanan_laundry)
    ) AS min_tgl,
    GREATEST(
      (SELECT MAX(tanggal_checkin) FROM stg_pms.reservasi),
      (SELECT MAX(DATE(waktu_pesan)) FROM stg_fnb.pesanan),
      (SELECT MAX(DATE(tanggal_masuk)) FROM stg_laundry.pesanan_laundry)
    ) AS max_tgl
)
INSERT INTO dim_waktu (tanggal, tahun, bulan, nama_bulan, minggu_tahun, hari_bulan, nama_hari)
SELECT
  d::date,
  EXTRACT(YEAR FROM d)::int,
  EXTRACT(MONTH FROM d)::int,
  TO_CHAR(d, 'TMMonth'),
  EXTRACT(WEEK FROM d)::int,
  EXTRACT(DAY FROM d)::int,
  TO_CHAR(d, 'TMDay')
FROM batas b
CROSS JOIN generate_series(b.min_tgl, b.max_tgl, interval '1 day') AS d
ON CONFLICT (tanggal) DO NOTHING;
