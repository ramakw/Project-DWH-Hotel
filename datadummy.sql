SET search_path TO dwh_hotel;

-- =========================
-- STG PMS
-- =========================
INSERT INTO stg_pms.tipe_kamar (id_tipe_kamar, kode_tipe_kamar, nama_tipe, kapasitas, tarif_per_malam) VALUES
(1, 'STD', 'Standard Room', 2, 450000),
(2, 'DLX', 'Deluxe Room',   2, 650000);

INSERT INTO stg_pms.kamar (id_kamar, id_tipe_kamar, kode_kamar, nomor_kamar) VALUES
(1, 1, 'KMR0001', '101'),
(2, 2, 'KMR0002', '201');

INSERT INTO stg_pms.tamu (id_tamu, kode_tamu, kewarganegaraan, tipe_tamu) VALUES
(1, 'TAM0001', 'Indonesia', 'Walk-in'),
(2, 'TAM0002', 'Indonesia', 'Member');

INSERT INTO stg_pms.reservasi (id_reservasi, id_tamu, tanggal_checkin, tanggal_checkout) VALUES
(1, 1, '2025-01-10', '2025-01-12'),
(2, 2, '2025-02-15', '2025-02-18');

INSERT INTO stg_pms.reservasi_kamar (id_reservasi_kamar, id_reservasi, id_kamar, jumlah_malam) VALUES
(1, 1, 1, 2),
(2, 2, 2, 3);

-- LOG tarif tipe kamar (ini yang dipakai SCD2 untuk Room) :contentReference[oaicite:3]{index=3}
INSERT INTO stg_pms.tarif_tipe_kamar (id_tarif_tipe_kamar, id_tipe_kamar, tarif_per_malam, berlaku_dari, berlaku_sampai, dibuat_pada) VALUES
(101, 1, 450000, '2025-01-01', NULL, '2025-01-01 00:00:00'),
(102, 2, 650000, '2025-01-01', NULL, '2025-01-01 00:00:00');


-- =========================
-- STG FNB
-- =========================
INSERT INTO stg_fnb.kategori_menu (id_kategori, kode_kategori, nama_kategori) VALUES
(1, 'KAT01', 'Makanan'),
(2, 'KAT02', 'Minuman');

INSERT INTO stg_fnb.menu (id_menu, kode_menu, nama_menu, id_kategori, harga) VALUES
(1, 'MNU01', 'Nasi Goreng', 1, 55000),
(2, 'MNU02', 'Cappuccino',  2, 35000);

INSERT INTO stg_fnb.pesanan (id_pesanan, waktu_pesan, nomor_kamar) VALUES
(1, '2025-01-10 12:00:00', NULL),
(2, '2025-02-16 09:30:00', '101');

INSERT INTO stg_fnb.detail_pesanan (id_detail, id_pesanan, id_menu, jumlah, harga_satuan, subtotal) VALUES
(1, 1, 1, 2, 55000, 110000),
(2, 2, 2, 1, 35000, 35000);

-- LOG harga menu (ini yang dipakai SCD2 untuk FNB) :contentReference[oaicite:4]{index=4}
INSERT INTO stg_fnb.harga_menu (id_harga_menu, id_menu, harga, berlaku_dari, berlaku_sampai, dibuat_pada) VALUES
(201, 1, 55000, '2025-01-01', NULL, '2025-01-01 00:00:00'),
(202, 2, 35000, '2025-01-01', NULL, '2025-01-01 00:00:00');


-- =========================
-- STG LAUNDRY
-- =========================
INSERT INTO stg_laundry.kategori_laundry (id_kategori_laundry, kode_kategori, nama_kategori) VALUES
(1, 'KL01', 'Pakaian'),
(2, 'KL02', 'Linen');

INSERT INTO stg_laundry.layanan_laundry (id_layanan_laundry, id_kategori_laundry, nama_layanan) VALUES
(1, 1, 'Cuci Kering (kg)'),
(2, 2, 'Cuci Linen (kg)');

-- LOG harga laundry (ini yang dipakai SCD2 untuk Laundry) :contentReference[oaicite:5]{index=5}
INSERT INTO stg_laundry.harga_laundry (id_harga_laundry, id_layanan_laundry, harga, berlaku_dari, berlaku_sampai, dibuat_pada) VALUES
(301, 1, 15000, '2025-01-01', NULL, '2025-01-01 00:00:00'),
(302, 2, 25000, '2025-01-01', NULL, '2025-01-01 00:00:00');

INSERT INTO stg_laundry.pesanan_laundry (id_pesanan_laundry, id_tamu, tanggal_masuk) VALUES
(1, 1, '2025-01-10 09:00:00'),
(2, 2, '2025-02-05 14:30:00');

INSERT INTO stg_laundry.detail_pesanan_laundry (id_detail_laundry, id_pesanan_laundry, id_layanan_laundry, jumlah, harga_satuan, subtotal) VALUES
(1, 1, 1, 5, 15000, 75000),
(2, 2, 2, 2, 25000, 50000);
