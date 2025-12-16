/*
SQLyog Ultimate v12.5.1 (64 bit)
MySQL - 10.4.32-MariaDB : Database - pos_fnb
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`pos_fnb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `pos_fnb`;

/*Table structure for table `detail_pesanan` */

CREATE TABLE `detail_pesanan` (
  `id_detail` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_pesanan` bigint(20) NOT NULL,
  `id_menu` bigint(20) NOT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 1,
  `harga_satuan` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS (`jumlah` * `harga_satuan`) VIRTUAL,
  PRIMARY KEY (`id_detail`),
  KEY `id_pesanan` (`id_pesanan`),
  KEY `id_menu` (`id_menu`),
  CONSTRAINT `detail_pesanan_ibfk_1` FOREIGN KEY (`id_pesanan`) REFERENCES `pesanan` (`id_pesanan`) ON DELETE CASCADE,
  CONSTRAINT `detail_pesanan_ibfk_2` FOREIGN KEY (`id_menu`) REFERENCES `menu` (`id_menu`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `detail_pesanan` */

insert  into `detail_pesanan`(`id_detail`,`id_pesanan`,`id_menu`,`jumlah`,`harga_satuan`) values 
(1,1,1,1,55000.00),
(2,1,2,1,60000.00),
(3,1,7,1,32000.00),
(4,2,3,1,35000.00),
(5,2,4,1,38000.00),
(6,3,8,1,45000.00),
(7,3,5,2,30000.00),
(8,4,7,1,32000.00),
(9,4,3,1,35000.00),
(10,5,1,1,55000.00),
(11,5,6,1,25000.00);

/*Table structure for table `kategori_menu` */

CREATE TABLE `kategori_menu` (
  `id_kategori` bigint(20) NOT NULL AUTO_INCREMENT,
  `kode_kategori` varchar(20) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  PRIMARY KEY (`id_kategori`),
  UNIQUE KEY `kode_kategori` (`kode_kategori`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `kategori_menu` */

insert  into `kategori_menu`(`id_kategori`,`kode_kategori`,`nama_kategori`,`deskripsi`) values 
(1,'KTM0000001','Makanan Utama','Main course'),
(2,'KTM0000002','Minuman','Beverage'),
(3,'KTM0000003','Dessert','Dessert & sweets'),
(4,'KTM0000004','Snack','Snack & finger food');

/*Table structure for table `meja` */

CREATE TABLE `meja` (
  `id_meja` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_outlet` bigint(20) NOT NULL,
  `nomor_meja` varchar(20) NOT NULL,
  `status_meja` enum('Tersedia','Terisi','Reserved') DEFAULT 'Tersedia',
  `kapasitas` int(11) DEFAULT 2,
  PRIMARY KEY (`id_meja`),
  KEY `id_outlet` (`id_outlet`),
  CONSTRAINT `meja_ibfk_1` FOREIGN KEY (`id_outlet`) REFERENCES `outlet` (`id_outlet`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `meja` */

insert  into `meja`(`id_meja`,`id_outlet`,`nomor_meja`,`status_meja`,`kapasitas`) values 
(1,1,'R1','Tersedia',4),
(2,1,'R2','Tersedia',2),
(3,2,'C1','Tersedia',2),
(4,2,'C2','Reserved',4),
(5,3,'P1','Tersedia',4);

/*Table structure for table `menu` */

CREATE TABLE `menu` (
  `id_menu` bigint(20) NOT NULL AUTO_INCREMENT,
  `kode_menu` varchar(20) NOT NULL,
  `nama_menu` varchar(150) NOT NULL,
  `id_kategori` bigint(20) NOT NULL,
  `id_outlet` bigint(20) NOT NULL,
  `harga` decimal(12,2) NOT NULL,
  `ketersediaan` enum('Tersedia','Habis') DEFAULT 'Tersedia',
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diubah_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_menu`),
  UNIQUE KEY `kode_menu` (`kode_menu`),
  KEY `id_kategori` (`id_kategori`),
  KEY `id_outlet` (`id_outlet`),
  CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `kategori_menu` (`id_kategori`),
  CONSTRAINT `menu_ibfk_2` FOREIGN KEY (`id_outlet`) REFERENCES `outlet` (`id_outlet`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `menu` */

insert  into `menu`(`id_menu`,`kode_menu`,`nama_menu`,`id_kategori`,`id_outlet`,`harga`,`ketersediaan`,`dibuat_pada`,`diubah_pada`) values 
(1,'MNU0000001','Nasi Goreng Spesial',1,1,55000.00,'Tersedia','2025-12-10 09:36:54','2025-12-10 09:36:54'),
(2,'MNU0000002','Mie Goreng Seafood',1,1,60000.00,'Tersedia','2025-12-10 09:36:54','2025-12-10 09:36:54'),
(3,'MNU0000003','Cappuccino Hot',2,2,35000.00,'Tersedia','2025-12-10 09:36:54','2025-12-10 09:36:54'),
(4,'MNU0000004','Iced Latte',2,2,38000.00,'Tersedia','2025-12-10 09:36:54','2025-12-10 09:36:54'),
(5,'MNU0000005','Fresh Orange Juice',2,3,30000.00,'Tersedia','2025-12-10 09:36:54','2025-12-10 09:36:54'),
(6,'MNU0000006','French Fries',4,2,25000.00,'Tersedia','2025-12-10 09:36:54','2025-12-10 09:36:54'),
(7,'MNU0000007','Chocolate Brownies',3,1,32000.00,'Tersedia','2025-12-10 09:36:54','2025-12-10 09:36:54'),
(8,'MNU0000008','Chicken Wings',4,3,45000.00,'Tersedia','2025-12-10 09:36:54','2025-12-10 09:36:54');

/*Table structure for table `outlet` */

CREATE TABLE `outlet` (
  `id_outlet` bigint(20) NOT NULL AUTO_INCREMENT,
  `kode_outlet` varchar(20) NOT NULL,
  `nama_outlet` varchar(100) NOT NULL,
  `tipe_outlet` enum('Restaurant','Cafe','Bar','InRoomDining','PoolBar','Lounge') NOT NULL,
  `lokasi` varchar(100) DEFAULT NULL,
  `jam_buka` time DEFAULT NULL,
  `jam_tutup` time DEFAULT NULL,
  `status_outlet` enum('Aktif','NonAktif') DEFAULT 'Aktif',
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diubah_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_outlet`),
  UNIQUE KEY `kode_outlet` (`kode_outlet`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `outlet` */

insert  into `outlet`(`id_outlet`,`kode_outlet`,`nama_outlet`,`tipe_outlet`,`lokasi`,`jam_buka`,`jam_tutup`,`status_outlet`,`dibuat_pada`,`diubah_pada`) values 
(1,'OUT0000001','Timuring Restaurant','Restaurant','Lantai 1','07:00:00','22:00:00','Aktif','2025-12-10 09:36:54','2025-12-10 09:36:54'),
(2,'OUT0000002','Sunset Cafe','Cafe','Lantai 2','10:00:00','23:00:00','Aktif','2025-12-10 09:36:54','2025-12-10 09:36:54'),
(3,'OUT0000003','Pool Bar','PoolBar','Area Kolam','11:00:00','20:00:00','Aktif','2025-12-10 09:36:54','2025-12-10 09:36:54');

/*Table structure for table `pesanan` */

CREATE TABLE `pesanan` (
  `id_pesanan` bigint(20) NOT NULL AUTO_INCREMENT,
  `kode_pesanan` varchar(30) NOT NULL,
  `id_outlet` bigint(20) NOT NULL,
  `id_staff` bigint(20) DEFAULT NULL,
  `id_meja` bigint(20) DEFAULT NULL,
  `tipe_pesanan` enum('DineIn','TakeAway','InRoomDining') NOT NULL,
  `nomor_kamar` varchar(10) DEFAULT NULL,
  `waktu_pesan` timestamp NOT NULL DEFAULT current_timestamp(),
  `waktu_selesai` timestamp NULL DEFAULT NULL,
  `status_pesanan` enum('Diproses','Selesai','Dibatalkan') DEFAULT 'Diproses',
  `total_harga` decimal(12,2) DEFAULT 0.00,
  `catatan` text DEFAULT NULL,
  PRIMARY KEY (`id_pesanan`),
  UNIQUE KEY `kode_pesanan` (`kode_pesanan`),
  KEY `id_outlet` (`id_outlet`),
  KEY `id_staff` (`id_staff`),
  KEY `id_meja` (`id_meja`),
  CONSTRAINT `pesanan_ibfk_1` FOREIGN KEY (`id_outlet`) REFERENCES `outlet` (`id_outlet`),
  CONSTRAINT `pesanan_ibfk_2` FOREIGN KEY (`id_staff`) REFERENCES `staff` (`id_staff`),
  CONSTRAINT `pesanan_ibfk_3` FOREIGN KEY (`id_meja`) REFERENCES `meja` (`id_meja`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `pesanan` */

insert  into `pesanan`(`id_pesanan`,`kode_pesanan`,`id_outlet`,`id_staff`,`id_meja`,`tipe_pesanan`,`nomor_kamar`,`waktu_pesan`,`waktu_selesai`,`status_pesanan`,`total_harga`,`catatan`) values 
(1,'ORD0000001',1,1,1,'DineIn',NULL,'2025-01-10 12:15:00','2025-01-10 13:00:00','Selesai',145000.00,'Lunch tamu walk-in'),
(2,'ORD0000002',2,2,3,'DineIn',NULL,'2025-02-16 09:30:00','2025-02-16 10:05:00','Selesai',73000.00,'Breakfast coffee'),
(3,'ORD0000003',3,4,NULL,'InRoomDining','101','2025-03-20 20:10:00','2025-03-20 20:50:00','Selesai',105000.00,'Order ke kamar 101'),
(4,'ORD0000004',2,4,4,'DineIn',NULL,'2025-05-05 18:30:00',NULL,'Diproses',63000.00,'Pesanan dessert dan kopi'),
(5,'ORD0000005',1,1,NULL,'TakeAway',NULL,'2025-07-22 11:45:00','2025-07-22 12:10:00','Selesai',80000.00,'Takeaway untuk tamu corporate');

/*Table structure for table `staff` */

CREATE TABLE `staff` (
  `id_staff` bigint(20) NOT NULL AUTO_INCREMENT,
  `kode_staff` varchar(20) NOT NULL,
  `nama_staff` varchar(150) NOT NULL,
  `jabatan` enum('Waiter','Runner','Kasir','Koki','Chef','SousChef','Bartender','Barista','Steward','Captain','Manager') NOT NULL,
  `departemen` enum('FNB','Kitchen','Bar','Steward','Management') DEFAULT 'FNB',
  `status_pekerja` enum('Aktif','NonAktif') DEFAULT 'Aktif',
  `mulai_bekerja` date DEFAULT curdate(),
  `berhenti_pada` date DEFAULT NULL,
  PRIMARY KEY (`id_staff`),
  UNIQUE KEY `kode_staff` (`kode_staff`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `staff` */

insert  into `staff`(`id_staff`,`kode_staff`,`nama_staff`,`jabatan`,`departemen`,`status_pekerja`,`mulai_bekerja`,`berhenti_pada`) values 
(1,'STF0000001','Rudi Pratama','Waiter','FNB','Aktif','2025-01-01',NULL),
(2,'STF0000002','Ayu Lestari','Kasir','FNB','Aktif','2025-01-10',NULL),
(3,'STF0000003','Budi Santika','Koki','Kitchen','Aktif','2025-02-01',NULL),
(4,'STF0000004','Dewi Kartika','Barista','Bar','Aktif','2025-02-15',NULL),
(5,'STF0000005','Made Wirawan','Manager','Management','Aktif','2025-01-05',NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
