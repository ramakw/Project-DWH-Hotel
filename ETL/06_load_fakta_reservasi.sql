SET search_path TO dwh_hotel;

-- RESET (TRUNCATE) khusus fakta reservasi
TRUNCATE TABLE fakta_reservasi_kamar;

-- LOAD FACT: RESERVASI KAMAR
INSERT INTO fakta_reservasi_kamar (
  waktu_key,
  kamar_key,
  tamu_key,
  jumlah_malam_menginap
)
SELECT
  dw.waktu_key,
  dk.kamar_key,
  dt.tamu_key,
  COALESCE(rk.jumlah_malam, 0)
FROM stg_pms.reservasi_kamar rk
JOIN stg_pms.reservasi r
  ON r.id_reservasi = rk.id_reservasi
JOIN dim_waktu dw
  ON dw.tanggal = r.tanggal_checkin
JOIN dim_kamar dk
  ON dk.id_kamar_sumber = rk.id_kamar
JOIN dim_tamu dt
  ON dt.id_tamu_sumber = r.id_tamu
WHERE r.tanggal_checkin IS NOT NULL;
