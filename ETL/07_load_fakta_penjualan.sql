SET search_path TO dwh_hotel;

TRUNCATE TABLE fakta_penjualan;

-- 1) ROOM
INSERT INTO fakta_penjualan (produk_key, waktu_key, qty_terjual, total_pendapatan)
SELECT
  dp.produk_key,
  dw.waktu_key,
  rk.jumlah_malam::numeric(12,2),
  (rk.jumlah_malam * dp.harga_standar)::numeric(12,2)
FROM stg_pms.reservasi_kamar rk
JOIN stg_pms.reservasi r ON r.id_reservasi = rk.id_reservasi
JOIN stg_pms.kamar k ON k.id_kamar = rk.id_kamar
JOIN dim_waktu dw ON dw.tanggal = r.tanggal_checkin
JOIN dim_produk dp
  ON dp.departemen_pendapatan = 'Room'
 AND dp.id_tipe_kamar_sumber = k.id_tipe_kamar
 AND dw.tanggal BETWEEN dp.tanggal_berlaku_mulai AND dp.tanggal_berlaku_sampai
WHERE r.tanggal_checkin IS NOT NULL;

-- 2) FNB
INSERT INTO fakta_penjualan (produk_key, waktu_key, qty_terjual, total_pendapatan)
SELECT
  dp.produk_key,
  dw.waktu_key,
  d.jumlah::numeric(12,2),
  d.subtotal::numeric(12,2)
FROM stg_fnb.detail_pesanan d
JOIN stg_fnb.pesanan p ON p.id_pesanan = d.id_pesanan
JOIN dim_waktu dw ON dw.tanggal = DATE(p.waktu_pesan)
JOIN dim_produk dp
  ON dp.departemen_pendapatan = 'FNB'
 AND dp.id_menu_sumber = d.id_menu
 AND dw.tanggal BETWEEN dp.tanggal_berlaku_mulai AND dp.tanggal_berlaku_sampai
WHERE p.waktu_pesan IS NOT NULL;

-- 3) LAUNDRY
INSERT INTO fakta_penjualan (produk_key, waktu_key, qty_terjual, total_pendapatan)
SELECT
  dp.produk_key,
  dw.waktu_key,
  d.jumlah::numeric(12,2),
  d.subtotal::numeric(12,2)
FROM stg_laundry.detail_pesanan_laundry d
JOIN stg_laundry.pesanan_laundry p ON p.id_pesanan_laundry = d.id_pesanan_laundry
JOIN dim_waktu dw ON dw.tanggal = DATE(p.tanggal_masuk)
JOIN dim_produk dp
  ON dp.departemen_pendapatan = 'Laundry'
 AND dp.id_layanan_laundry_sumber = d.id_layanan_laundry
 AND dw.tanggal BETWEEN dp.tanggal_berlaku_mulai AND dp.tanggal_berlaku_sampai
WHERE p.tanggal_masuk IS NOT NULL;
