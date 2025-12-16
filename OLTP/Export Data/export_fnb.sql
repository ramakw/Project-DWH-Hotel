use pos_fnb;

SELECT id_kategori, kode_kategori, nama_kategori
FROM pos_fnb.kategori_menu
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\fnb\\00-test\\kategori_menu.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_menu, kode_menu, nama_menu, id_kategori, harga
FROM pos_fnb.menu
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\fnb\\00-test\\menu.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_pesanan, waktu_pesan, nomor_kamar
FROM pos_fnb.pesanan
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\fnb\\00-test\\pesanan.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_detail, id_pesanan, id_menu, jumlah, harga_satuan, (jumlah * harga_satuan) AS subtotal
FROM pos_fnb.detail_pesanan
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\fnb\\00-test\\detail_pesanan.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';