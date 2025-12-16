use pms_timuring;

SELECT id_tipe_kamar, kode_tipe_kamar, nama_tipe, kapasitas, tarif_per_malam
FROM pms_timuring.tipe_kamar
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\pms\\00-test\\tipe_kamar.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_kamar, id_tipe_kamar, kode_kamar, nomor_kamar
FROM pms_timuring.kamar
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\pms\\00-test\\kamar.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_tamu, kode_tamu, kewarganegaraan, tipe_tamu
FROM pms_timuring.tamu
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\pms\\00-test\\tamu.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_reservasi, id_tamu, tanggal_checkin, tanggal_checkout
FROM pms_timuring.reservasi
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\pms\\00-test\\reservasi.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';

SELECT id_reservasi_kamar, id_reservasi, id_kamar, jumlah_malam
FROM pms_timuring.reservasi_kamar
INTO OUTFILE 'C:\\Users\\Iguba\\Downloads\\DWH_Timuring\\pms\\00-test\\reservasi_kamar.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n';