BEGIN;

SET search_path TO dwh_hotel;

-- =========================================================
-- SCD2 DIM_PRODUK - ROOM
-- (aman dengan uq_dim_produk_room_active)
-- =========================================================
WITH src_room AS (
  SELECT DISTINCT ON (t.id_tipe_kamar)
    t.id_tipe_kamar,
    t.tarif_per_malam
  FROM stg_pms.tarif_tipe_kamar t
  ORDER BY
    t.id_tipe_kamar,
    COALESCE(t.berlaku_sampai, DATE '9999-12-31') DESC,
    t.berlaku_dari DESC
),
room_changed AS (
  SELECT
    dp.produk_key,
    s.id_tipe_kamar,
    s.tarif_per_malam
  FROM src_room s
  JOIN dim_produk dp
    ON dp.departemen_pendapatan = 'Room'
   AND dp.id_tipe_kamar_sumber = s.id_tipe_kamar
   AND dp.is_active = TRUE
  WHERE dp.harga_standar IS DISTINCT FROM s.tarif_per_malam
),
room_closed AS (
  UPDATE dim_produk dp
  SET is_active = FALSE,
      tanggal_berlaku_sampai = CURRENT_DATE - 1
  FROM room_changed rc
  WHERE dp.produk_key = rc.produk_key
  RETURNING rc.id_tipe_kamar, rc.tarif_per_malam
)
INSERT INTO dim_produk (
  departemen_pendapatan, nama_produk, kategori_produk,
  id_tipe_kamar_sumber, id_menu_sumber, id_layanan_laundry_sumber,
  harga_standar, tanggal_berlaku_mulai, tanggal_berlaku_sampai, is_active
)
SELECT
  'Room',
  COALESCE(tk.nama_tipe, 'Tipe Kamar ' || r.id_tipe_kamar::text),
  'Kamar',
  r.id_tipe_kamar, NULL, NULL,
  r.tarif_per_malam,
  CURRENT_DATE, DATE '9999-12-31', TRUE
FROM room_closed r
LEFT JOIN stg_pms.tipe_kamar tk ON tk.id_tipe_kamar = r.id_tipe_kamar;

-- insert produk Room yang benar-benar baru (belum pernah ada di dim)
WITH src_room AS (
  SELECT DISTINCT ON (t.id_tipe_kamar)
    t.id_tipe_kamar,
    t.tarif_per_malam
  FROM stg_pms.tarif_tipe_kamar t
  ORDER BY
    t.id_tipe_kamar,
    COALESCE(t.berlaku_sampai, DATE '9999-12-31') DESC,
    t.berlaku_dari DESC
)
INSERT INTO dim_produk (
  departemen_pendapatan, nama_produk, kategori_produk,
  id_tipe_kamar_sumber, id_menu_sumber, id_layanan_laundry_sumber,
  harga_standar, tanggal_berlaku_mulai, tanggal_berlaku_sampai, is_active
)
SELECT
  'Room',
  COALESCE(tk.nama_tipe, 'Tipe Kamar ' || s.id_tipe_kamar::text),
  'Kamar',
  s.id_tipe_kamar, NULL, NULL,
  s.tarif_per_malam,
  CURRENT_DATE, DATE '9999-12-31', TRUE
FROM src_room s
LEFT JOIN stg_pms.tipe_kamar tk ON tk.id_tipe_kamar = s.id_tipe_kamar
WHERE NOT EXISTS (
  SELECT 1
  FROM dim_produk dp
  WHERE dp.departemen_pendapatan='Room'
    AND dp.id_tipe_kamar_sumber = s.id_tipe_kamar
);

-- =========================================================
-- SCD2 DIM_PRODUK - FNB
-- (aman dengan uq_dim_produk_fnb_active)
-- =========================================================
WITH src_fnb AS (
  SELECT DISTINCT ON (hm.id_menu)
    hm.id_menu,
    hm.harga
  FROM stg_fnb.harga_menu hm
  ORDER BY
    hm.id_menu,
    COALESCE(hm.berlaku_sampai, DATE '9999-12-31') DESC,
    hm.berlaku_dari DESC
),
fnb_changed AS (
  SELECT
    dp.produk_key,
    s.id_menu,
    s.harga
  FROM src_fnb s
  JOIN dim_produk dp
    ON dp.departemen_pendapatan = 'FNB'
   AND dp.id_menu_sumber = s.id_menu
   AND dp.is_active = TRUE
  WHERE dp.harga_standar IS DISTINCT FROM s.harga
),
fnb_closed AS (
  UPDATE dim_produk dp
  SET is_active = FALSE,
      tanggal_berlaku_sampai = CURRENT_DATE - 1
  FROM fnb_changed fc
  WHERE dp.produk_key = fc.produk_key
  RETURNING fc.id_menu, fc.harga
)
INSERT INTO dim_produk (
  departemen_pendapatan, nama_produk, kategori_produk,
  id_tipe_kamar_sumber, id_menu_sumber, id_layanan_laundry_sumber,
  harga_standar, tanggal_berlaku_mulai, tanggal_berlaku_sampai, is_active
)
SELECT
  'FNB',
  COALESCE(m.nama_menu, 'Menu ' || f.id_menu::text),
  COALESCE(km.nama_kategori, 'F&B'),
  NULL, f.id_menu, NULL,
  f.harga,
  CURRENT_DATE, DATE '9999-12-31', TRUE
FROM fnb_closed f
LEFT JOIN stg_fnb.menu m ON m.id_menu = f.id_menu
LEFT JOIN stg_fnb.kategori_menu km ON km.id_kategori = m.id_kategori;

-- insert produk FNB yang benar-benar baru
WITH src_fnb AS (
  SELECT DISTINCT ON (hm.id_menu)
    hm.id_menu,
    hm.harga
  FROM stg_fnb.harga_menu hm
  ORDER BY
    hm.id_menu,
    COALESCE(hm.berlaku_sampai, DATE '9999-12-31') DESC,
    hm.berlaku_dari DESC
)
INSERT INTO dim_produk (
  departemen_pendapatan, nama_produk, kategori_produk,
  id_tipe_kamar_sumber, id_menu_sumber, id_layanan_laundry_sumber,
  harga_standar, tanggal_berlaku_mulai, tanggal_berlaku_sampai, is_active
)
SELECT
  'FNB',
  COALESCE(m.nama_menu, 'Menu ' || s.id_menu::text),
  COALESCE(km.nama_kategori, 'F&B'),
  NULL, s.id_menu, NULL,
  s.harga,
  CURRENT_DATE, DATE '9999-12-31', TRUE
FROM src_fnb s
LEFT JOIN stg_fnb.menu m ON m.id_menu = s.id_menu
LEFT JOIN stg_fnb.kategori_menu km ON km.id_kategori = m.id_kategori
WHERE NOT EXISTS (
  SELECT 1
  FROM dim_produk dp
  WHERE dp.departemen_pendapatan='FNB'
    AND dp.id_menu_sumber = s.id_menu
);

-- =========================================================
-- SCD2 DIM_PRODUK - LAUNDRY
-- (aman dengan uq_dim_produk_laundry_active)
-- =========================================================
WITH src_laundry AS (
  SELECT DISTINCT ON (hl.id_layanan_laundry)
    hl.id_layanan_laundry,
    hl.harga
  FROM stg_laundry.harga_laundry hl
  ORDER BY
    hl.id_layanan_laundry,
    COALESCE(hl.berlaku_sampai, DATE '9999-12-31') DESC,
    hl.berlaku_dari DESC
),
laundry_changed AS (
  SELECT
    dp.produk_key,
    s.id_layanan_laundry,
    s.harga
  FROM src_laundry s
  JOIN dim_produk dp
    ON dp.departemen_pendapatan = 'Laundry'
   AND dp.id_layanan_laundry_sumber = s.id_layanan_laundry
   AND dp.is_active = TRUE
  WHERE dp.harga_standar IS DISTINCT FROM s.harga
),
laundry_closed AS (
  UPDATE dim_produk dp
  SET is_active = FALSE,
      tanggal_berlaku_sampai = CURRENT_DATE - 1
  FROM laundry_changed lc
  WHERE dp.produk_key = lc.produk_key
  RETURNING lc.id_layanan_laundry, lc.harga
)
INSERT INTO dim_produk (
  departemen_pendapatan, nama_produk, kategori_produk,
  id_tipe_kamar_sumber, id_menu_sumber, id_layanan_laundry_sumber,
  harga_standar, tanggal_berlaku_mulai, tanggal_berlaku_sampai, is_active
)
SELECT
  'Laundry',
  COALESCE(ll.nama_layanan, 'Layanan ' || l.id_layanan_laundry::text),
  COALESCE(kl.nama_kategori, 'Laundry'),
  NULL, NULL, l.id_layanan_laundry,
  l.harga,
  CURRENT_DATE, DATE '9999-12-31', TRUE
FROM laundry_closed l
LEFT JOIN stg_laundry.layanan_laundry ll ON ll.id_layanan_laundry = l.id_layanan_laundry
LEFT JOIN stg_laundry.kategori_laundry kl ON kl.id_kategori_laundry = ll.id_kategori_laundry;

-- insert produk Laundry yang benar-benar baru
WITH src_laundry AS (
  SELECT DISTINCT ON (hl.id_layanan_laundry)
    hl.id_layanan_laundry,
    hl.harga
  FROM stg_laundry.harga_laundry hl
  ORDER BY
    hl.id_layanan_laundry,
    COALESCE(hl.berlaku_sampai, DATE '9999-12-31') DESC,
    hl.berlaku_dari DESC
)
INSERT INTO dim_produk (
  departemen_pendapatan, nama_produk, kategori_produk,
  id_tipe_kamar_sumber, id_menu_sumber, id_layanan_laundry_sumber,
  harga_standar, tanggal_berlaku_mulai, tanggal_berlaku_sampai, is_active
)
SELECT
  'Laundry',
  COALESCE(ll.nama_layanan, 'Layanan ' || s.id_layanan_laundry::text),
  COALESCE(kl.nama_kategori, 'Laundry'),
  NULL, NULL, s.id_layanan_laundry,
  s.harga,
  CURRENT_DATE, DATE '9999-12-31', TRUE
FROM src_laundry s
LEFT JOIN stg_laundry.layanan_laundry ll ON ll.id_layanan_laundry = s.id_layanan_laundry
LEFT JOIN stg_laundry.kategori_laundry kl ON kl.id_kategori_laundry = ll.id_kategori_laundry
WHERE NOT EXISTS (
  SELECT 1
  FROM dim_produk dp
  WHERE dp.departemen_pendapatan='Laundry'
    AND dp.id_layanan_laundry_sumber = s.id_layanan_laundry
);

COMMIT;
