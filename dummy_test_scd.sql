SET search_path TO dwh_hotel;

-- ROOM: Standard naik 450000 -> 500000
UPDATE stg_pms.tarif_tipe_kamar
SET berlaku_sampai = CURRENT_DATE - 1
WHERE id_tipe_kamar = 1 AND berlaku_sampai IS NULL;

INSERT INTO stg_pms.tarif_tipe_kamar
(id_tarif_tipe_kamar, id_tipe_kamar, tarif_per_malam, berlaku_dari, berlaku_sampai, dibuat_pada)
VALUES
(1001, 1, 500000, CURRENT_DATE, NULL, CURRENT_TIMESTAMP);

-- FNB: Nasi Goreng naik 55000 -> 60000
UPDATE stg_fnb.harga_menu
SET berlaku_sampai = CURRENT_DATE - 1
WHERE id_menu = 1 AND berlaku_sampai IS NULL;

INSERT INTO stg_fnb.harga_menu
(id_harga_menu, id_menu, harga, berlaku_dari, berlaku_sampai, dibuat_pada)
VALUES
(2001, 1, 60000, CURRENT_DATE, NULL, CURRENT_TIMESTAMP);

-- LAUNDRY: Cuci Kering naik 15000 -> 20000
UPDATE stg_laundry.harga_laundry
SET berlaku_sampai = CURRENT_DATE - 1
WHERE id_layanan_laundry = 1 AND berlaku_sampai IS NULL;

INSERT INTO stg_laundry.harga_laundry
(id_harga_laundry, id_layanan_laundry, harga, berlaku_dari, berlaku_sampai, dibuat_pada)
VALUES
(3001, 1, 20000, CURRENT_DATE, NULL, CURRENT_TIMESTAMP);
