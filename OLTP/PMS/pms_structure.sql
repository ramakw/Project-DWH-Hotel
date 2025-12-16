/*
SQLyog Community v13.3.0 (64 bit)
MySQL - 10.4.32-MariaDB : Database - pms_timuring
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`pms_timuring` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `pms_timuring`;

/*Table structure for table `cek_in` */

CREATE TABLE `cek_in` (
  `id_cek_in` int(11) NOT NULL AUTO_INCREMENT,
  `id_reservasi` int(11) NOT NULL,
  `id_staf_checkin` int(11) NOT NULL,
  `id_staf_checkout` int(11) DEFAULT NULL,
  `waktu_checkin` timestamp NOT NULL DEFAULT current_timestamp(),
  `perkiraan_checkout` date DEFAULT NULL,
  `waktu_checkout_aktual` timestamp NULL DEFAULT NULL,
  `status_cek_in` enum('CheckIn','CheckOut','CheckOutDini','CheckOutTelat') DEFAULT 'CheckIn',
  `catatan` text DEFAULT NULL,
  PRIMARY KEY (`id_cek_in`),
  KEY `id_reservasi` (`id_reservasi`),
  KEY `id_staf_checkin` (`id_staf_checkin`),
  KEY `id_staf_checkout` (`id_staf_checkout`),
  CONSTRAINT `cek_in_ibfk_1` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`),
  CONSTRAINT `cek_in_ibfk_2` FOREIGN KEY (`id_staf_checkin`) REFERENCES `staf` (`id_staf`),
  CONSTRAINT `cek_in_ibfk_3` FOREIGN KEY (`id_staf_checkout`) REFERENCES `staf` (`id_staf`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `cek_in` */

insert  into `cek_in`(`id_cek_in`,`id_reservasi`,`id_staf_checkin`,`id_staf_checkout`,`waktu_checkin`,`perkiraan_checkout`,`waktu_checkout_aktual`,`status_cek_in`,`catatan`) values 
(1,1,1,1,'2025-01-10 14:05:00','2025-01-12','2025-01-12 11:10:00','CheckOut','Normal checkout'),
(2,2,1,2,'2025-02-15 15:20:00','2025-02-18','2025-02-18 10:00:00','CheckOut','Dapat late checkout 1 jam'),
(3,3,1,NULL,'2025-03-20 13:45:00','2025-03-21',NULL,'CheckIn','Masih in-house'),
(4,4,2,NULL,'2025-05-05 16:00:00','2025-05-08',NULL,'CheckIn','Corporate guest'),
(5,5,1,NULL,'2025-07-10 17:30:00','2025-07-13',NULL,'CheckOutDini','Reservasi cancel, tidak jadi menginap');

/*Table structure for table `housekeeping_log` */

CREATE TABLE `housekeeping_log` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_kamar` int(11) NOT NULL,
  `id_staf` int(11) NOT NULL,
  `tanggal` timestamp NOT NULL DEFAULT current_timestamp(),
  `jenis` enum('cleaning','maintenance') NOT NULL,
  `catatan` text DEFAULT NULL,
  PRIMARY KEY (`id_log`),
  KEY `id_kamar` (`id_kamar`),
  KEY `id_staf` (`id_staf`),
  CONSTRAINT `housekeeping_log_ibfk_1` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`),
  CONSTRAINT `housekeeping_log_ibfk_2` FOREIGN KEY (`id_staf`) REFERENCES `staf` (`id_staf`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `housekeeping_log` */

insert  into `housekeeping_log`(`id_log`,`id_kamar`,`id_staf`,`tanggal`,`jenis`,`catatan`) values 
(1,1,3,'2025-01-10 12:00:00','cleaning','Persiapan sebelum check-in RSV0000001'),
(2,2,3,'2025-03-20 09:00:00','cleaning','General cleaning kamar 102'),
(3,4,3,'2025-05-05 11:30:00','cleaning','Persiapan premium suite untuk RSV0000004'),
(4,5,3,'2025-06-01 10:00:00','maintenance','AC bocor, lapor ke teknisi'),
(5,3,3,'2025-02-15 11:00:00','cleaning','Turn down service untuk tamu member');

/*Table structure for table `inventaris_kamar` */

CREATE TABLE `inventaris_kamar` (
  `id_inventaris` int(11) NOT NULL AUTO_INCREMENT,
  `id_kamar` int(11) NOT NULL,
  `nama_item` varchar(200) DEFAULT NULL,
  `jumlah` int(11) DEFAULT 1,
  `catatan` text DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diubah_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_inventaris`),
  KEY `id_kamar` (`id_kamar`),
  CONSTRAINT `inventaris_kamar_ibfk_1` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `inventaris_kamar` */

insert  into `inventaris_kamar`(`id_inventaris`,`id_kamar`,`nama_item`,`jumlah`,`catatan`,`dibuat_pada`,`diubah_pada`) values 
(1,1,'Bantal',4,'Standar 4 bantal per kamar','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(2,1,'Handuk',2,'Handuk mandi','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(3,3,'Bantal',4,'Deluxe room','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(4,4,'Bantal',6,'Premium suite, tambahan bantal','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(5,4,'Mini Bar Set',1,'Mini bar untuk premium suite','2025-12-10 09:35:54','2025-12-10 09:35:54');

/*Table structure for table `kamar` */

CREATE TABLE `kamar` (
  `id_kamar` int(11) NOT NULL AUTO_INCREMENT,
  `kode_kamar` varchar(20) NOT NULL,
  `nomor_kamar` varchar(10) NOT NULL,
  `id_tipe_kamar` int(11) NOT NULL,
  `status_kamar` enum('available','occupied','dirty','cleaning','maintenance','out_of_order') DEFAULT 'available',
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diubah_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_kamar`),
  UNIQUE KEY `kode_kamar` (`kode_kamar`),
  UNIQUE KEY `nomor_kamar` (`nomor_kamar`),
  KEY `id_tipe_kamar` (`id_tipe_kamar`),
  CONSTRAINT `kamar_ibfk_1` FOREIGN KEY (`id_tipe_kamar`) REFERENCES `tipe_kamar` (`id_tipe_kamar`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `kamar` */

insert  into `kamar`(`id_kamar`,`kode_kamar`,`nomor_kamar`,`id_tipe_kamar`,`status_kamar`,`dibuat_pada`,`diubah_pada`) values 
(1,'KMR0000001','101',1,'available','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(2,'KMR0000002','102',1,'dirty','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(3,'KMR0000003','201',2,'available','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(4,'KMR0000004','301',3,'occupied','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(5,'KMR0000005','302',3,'maintenance','2025-12-10 09:35:54','2025-12-10 09:35:54');

/*Table structure for table `pembayaran` */

CREATE TABLE `pembayaran` (
  `id_pembayaran` int(11) NOT NULL AUTO_INCREMENT,
  `kode_pembayaran` varchar(50) NOT NULL,
  `id_reservasi` int(11) NOT NULL,
  `id_tamu` int(11) NOT NULL,
  `jumlah` decimal(12,2) NOT NULL,
  `metode_pembayaran` enum('Tunai','Kartu Kredit','Debit','Transfer Bank','QRIS') DEFAULT 'Tunai',
  `waktu_pembayaran` timestamp NOT NULL DEFAULT current_timestamp(),
  `catatan` text DEFAULT NULL,
  PRIMARY KEY (`id_pembayaran`),
  UNIQUE KEY `kode_pembayaran` (`kode_pembayaran`),
  KEY `id_reservasi` (`id_reservasi`),
  KEY `id_tamu` (`id_tamu`),
  CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`),
  CONSTRAINT `pembayaran_ibfk_2` FOREIGN KEY (`id_tamu`) REFERENCES `tamu` (`id_tamu`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `pembayaran` */

insert  into `pembayaran`(`id_pembayaran`,`kode_pembayaran`,`id_reservasi`,`id_tamu`,`jumlah`,`metode_pembayaran`,`waktu_pembayaran`,`catatan`) values 
(1,'PAY0000001',1,1,900000.00,'Tunai','2025-01-12 11:15:00','2 malam x 450.000'),
(2,'PAY0000002',2,2,1755000.00,'Kartu Kredit','2025-02-18 10:05:00','3 malam x 650.000 - 10% member'),
(3,'PAY0000003',3,3,450000.00,'QRIS','2025-03-20 14:00:00','Full payment at check-in'),
(4,'PAY0000004',4,4,0.00,'Transfer Bank','2025-05-04 09:00:00','Deposit via company (akan ditagih setelah stay)'),
(5,'PAY0000005',5,5,0.00,'Kartu Kredit','2025-07-09 16:30:00','Pre-auth, dibatalkan setelah cancel');

/*Table structure for table `reservasi` */

CREATE TABLE `reservasi` (
  `id_reservasi` int(11) NOT NULL AUTO_INCREMENT,
  `kode_reservasi` varchar(20) NOT NULL,
  `id_tamu` int(11) NOT NULL,
  `id_kamar` int(11) NOT NULL,
  `tanggal_checkin` date NOT NULL,
  `tanggal_checkout` date NOT NULL,
  `tarif_per_malam` decimal(12,2) NOT NULL,
  `status_reservasi` enum('booked','checked_in','checked_out','cancelled') DEFAULT 'booked',
  `catatan` text DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diubah_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_reservasi`),
  UNIQUE KEY `kode_reservasi` (`kode_reservasi`),
  KEY `id_tamu` (`id_tamu`),
  KEY `id_kamar` (`id_kamar`),
  CONSTRAINT `reservasi_ibfk_1` FOREIGN KEY (`id_tamu`) REFERENCES `tamu` (`id_tamu`),
  CONSTRAINT `reservasi_ibfk_2` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `reservasi` */

insert  into `reservasi`(`id_reservasi`,`kode_reservasi`,`id_tamu`,`id_kamar`,`tanggal_checkin`,`tanggal_checkout`,`tarif_per_malam`,`status_reservasi`,`catatan`,`dibuat_pada`,`diubah_pada`) values 
(1,'RSV0000001',1,1,'2025-01-10','2025-01-12',450000.00,'checked_out','Stay 2 malam standard room','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(2,'RSV0000002',2,3,'2025-02-15','2025-02-18',650000.00,'checked_out','Member discount 10% (di pembayaran)','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(3,'RSV0000003',3,2,'2025-03-20','2025-03-21',450000.00,'checked_in','Early check-in request','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(4,'RSV0000004',4,4,'2025-05-05','2025-05-08',950000.00,'booked','Corporate booking','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(5,'RSV0000005',5,4,'2025-07-10','2025-07-13',950000.00,'cancelled','Cancelled by guest via email','2025-12-10 09:35:54','2025-12-10 09:35:54');

/*Table structure for table `reservasi_kamar` */

CREATE TABLE `reservasi_kamar` (
  `id_reservasi_kamar` int(11) NOT NULL AUTO_INCREMENT,
  `id_reservasi` int(11) NOT NULL,
  `id_kamar` int(11) DEFAULT NULL,
  `tarif_per_malam` decimal(12,2) DEFAULT NULL,
  `jumlah_malam` int(11) DEFAULT 1,
  `jumlah_biaya` decimal(12,2) GENERATED ALWAYS AS (`tarif_per_malam` * `jumlah_malam`) VIRTUAL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_reservasi_kamar`),
  KEY `id_reservasi` (`id_reservasi`),
  KEY `id_kamar` (`id_kamar`),
  CONSTRAINT `reservasi_kamar_ibfk_1` FOREIGN KEY (`id_reservasi`) REFERENCES `reservasi` (`id_reservasi`) ON DELETE CASCADE,
  CONSTRAINT `reservasi_kamar_ibfk_2` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `reservasi_kamar` */

insert  into `reservasi_kamar`(`id_reservasi_kamar`,`id_reservasi`,`id_kamar`,`tarif_per_malam`,`jumlah_malam`,`dibuat_pada`) values 
(1,1,1,450000.00,2,'2025-12-10 09:35:54'),
(2,2,3,650000.00,3,'2025-12-10 09:35:54'),
(3,3,2,450000.00,1,'2025-12-10 09:35:54'),
(4,4,4,950000.00,3,'2025-12-10 09:35:54'),
(5,5,4,950000.00,3,'2025-12-10 09:35:54');

/*Table structure for table `staf` */

CREATE TABLE `staf` (
  `id_staf` int(11) NOT NULL AUTO_INCREMENT,
  `kode_staf` varchar(20) NOT NULL,
  `nama_lengkap` varchar(200) NOT NULL,
  `username` varchar(100) NOT NULL,
  `kata_sandi_hash` varchar(255) NOT NULL,
  `jabatan` enum('Resepsionis','Manajer','Housekeeping','FrontDesk','Admin') DEFAULT 'Resepsionis',
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diubah_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_staf`),
  UNIQUE KEY `kode_staf` (`kode_staf`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `staf` */

insert  into `staf`(`id_staf`,`kode_staf`,`nama_lengkap`,`username`,`kata_sandi_hash`,`jabatan`,`dibuat_pada`,`diubah_pada`) values 
(1,'STF0000001','Kadek Wayan','kadek.w','$2y$10$hashkadekdummy','Resepsionis','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(2,'STF0000002','Made Dewi','made.dewi','$2y$10$hashdewidummy','Manajer','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(3,'STF0000003','Komang Sari','komang.s','$2y$10$hashsaridummy','Housekeeping','2025-12-10 09:35:54','2025-12-10 09:35:54');

/*Table structure for table `tamu` */

CREATE TABLE `tamu` (
  `id_tamu` int(11) NOT NULL AUTO_INCREMENT,
  `kode_tamu` varchar(20) NOT NULL,
  `nama_lengkap` varchar(200) NOT NULL,
  `jenis_kelamin` varchar(20) DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `kewarganegaraan` varchar(100) DEFAULT NULL,
  `telepon` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `tipe_tamu` enum('Walk-in','Member','Korporat') DEFAULT 'Walk-in',
  `terdaftar_sejak` date DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diubah_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_tamu`),
  UNIQUE KEY `kode_tamu` (`kode_tamu`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `tamu` */

insert  into `tamu`(`id_tamu`,`kode_tamu`,`nama_lengkap`,`jenis_kelamin`,`tanggal_lahir`,`kewarganegaraan`,`telepon`,`email`,`alamat`,`tipe_tamu`,`terdaftar_sejak`,`dibuat_pada`,`diubah_pada`) values 
(1,'TAM0000001','I Made Aditya','Laki-laki','1995-03-10','Indonesia','081230000001','made.aditya@example.com','Denpasar, Bali','Walk-in','2025-01-05','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(2,'TAM0000002','Ni Putu Anisa','Perempuan','1998-07-21','Indonesia','081230000002','putu.anisa@example.com','Badung, Bali','Member','2025-02-01','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(3,'TAM0000003','Agus Santoso','Laki-laki','1990-11-15','Indonesia','081230000003','agus.santoso@example.com','Jakarta','Walk-in','2025-03-10','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(4,'TAM0000004','Siti Rahma','Perempuan','1988-09-05','Indonesia','081230000004','siti.rahma@example.com','Surabaya','Korporat','2025-04-01','2025-12-10 09:35:54','2025-12-10 09:35:54'),
(5,'TAM0000005','John Smith','Laki-laki','1985-01-22','Australia','+61400000005','john.smith@example.com','Sydney, Australia','Member','2025-05-15','2025-12-10 09:35:54','2025-12-10 09:35:54');

/*Table structure for table `tarif_tipe_kamar` */

CREATE TABLE `tarif_tipe_kamar` (
  `id_tarif` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipe_kamar` int(11) NOT NULL,
  `tarif` decimal(12,2) NOT NULL,
  `berlaku_dari` date NOT NULL,
  `berlaku_sampai` date DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_tarif`),
  KEY `id_tipe_kamar` (`id_tipe_kamar`),
  CONSTRAINT `tarif_tipe_kamar_ibfk_1` FOREIGN KEY (`id_tipe_kamar`) REFERENCES `tipe_kamar` (`id_tipe_kamar`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `tarif_tipe_kamar` */

insert  into `tarif_tipe_kamar`(`id_tarif`,`id_tipe_kamar`,`tarif`,`berlaku_dari`,`berlaku_sampai`,`dibuat_pada`) values 
(1,1,400000.00,'2025-01-01','2025-03-31','2025-12-10 09:35:54'),
(2,1,450000.00,'2025-04-01',NULL,'2025-12-10 09:35:54'),
(3,2,600000.00,'2025-01-01','2025-06-30','2025-12-10 09:35:54'),
(4,2,650000.00,'2025-07-01',NULL,'2025-12-10 09:35:54'),
(5,3,900000.00,'2025-02-01','2025-08-31','2025-12-10 09:35:54'),
(6,3,950000.00,'2025-09-01',NULL,'2025-12-10 09:35:54');

/*Table structure for table `tipe_kamar` */

CREATE TABLE `tipe_kamar` (
  `id_tipe_kamar` int(11) NOT NULL AUTO_INCREMENT,
  `kode_tipe_kamar` varchar(20) NOT NULL,
  `nama_tipe` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `kapasitas` int(11) DEFAULT 2,
  `tarif_per_malam` decimal(12,2) NOT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diubah_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_tipe_kamar`),
  UNIQUE KEY `kode_tipe_kamar` (`kode_tipe_kamar`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `tipe_kamar` */

insert  into `tipe_kamar`(`id_tipe_kamar`,`kode_tipe_kamar`,`nama_tipe`,`deskripsi`,`kapasitas`,`tarif_per_malam`,`dibuat_pada`,`diubah_pada`) values 
(1,'STD','Standard Room','Kamar standard dengan fasilitas basic.',2,450000.00,'2025-12-10 09:35:54','2025-12-10 09:35:54'),
(2,'DLX','Deluxe Room','Kamar deluxe dengan balkon.',2,650000.00,'2025-12-10 09:35:54','2025-12-10 09:35:54'),
(3,'PRM','Premium Suite','Suite luas dengan ruang tamu.',3,950000.00,'2025-12-10 09:35:54','2025-12-10 09:35:54');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
