use pos_laundry_timuring;

SELECT id_kategori_laundry, kode_kategori, nama_kategori
FROM pos_laundry_timuring.kategori_laundry
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\laundry\\00-test\\kategori_laundry.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_layanan_laundry, id_kategori_laundry, nama_layanan
FROM pos_laundry_timuring.layanan_laundry
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\laundry\\00-test\\layanan_laundry.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_harga_laundry, id_layanan_laundry, satuan, harga
FROM pos_laundry_timuring.harga_laundry
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\laundry\\00-test\\harga_laundry.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_pesanan_laundry, id_tamu, tanggal_masuk
FROM pos_laundry_timuring.pesanan_laundry
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\laundry\\00-test\\pesanan_laundry.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_detail_pesanan, id_pesanan_laundry, id_layanan_laundry, jumlah, harga_satuan, (jumlah * harga_satuan)
FROM pos_laundry_timuring.detail_pesanan_laundry
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\laundry\\00-test\\detail_pesanan_laundry.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';