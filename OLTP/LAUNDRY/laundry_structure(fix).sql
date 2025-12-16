/*
SQLyog Ultimate v12.5.1 (64 bit)
MySQL - 10.4.32-MariaDB : Database - pos_laundry_timuring
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`pos_laundry_timuring` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `pos_laundry_timuring`;

/*Table structure for table `detail_pesanan_laundry` */

CREATE TABLE `detail_pesanan_laundry` (
  `id_detail_pesanan` int(11) NOT NULL AUTO_INCREMENT,
  `id_pesanan_laundry` int(11) NOT NULL,
  `id_layanan_laundry` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 1,
  `harga_satuan` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS (`jumlah` * `harga_satuan`) VIRTUAL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_detail_pesanan`),
  KEY `id_pesanan_laundry` (`id_pesanan_laundry`),
  KEY `id_layanan_laundry` (`id_layanan_laundry`),
  CONSTRAINT `detail_pesanan_laundry_ibfk_1` FOREIGN KEY (`id_pesanan_laundry`) REFERENCES `pesanan_laundry` (`id_pesanan_laundry`) ON DELETE CASCADE,
  CONSTRAINT `detail_pesanan_laundry_ibfk_2` FOREIGN KEY (`id_layanan_laundry`) REFERENCES `layanan_laundry` (`id_layanan_laundry`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `detail_pesanan_laundry` */

insert  into `detail_pesanan_laundry`(`id_detail_pesanan`,`id_pesanan_laundry`,`id_layanan_laundry`,`jumlah`,`harga_satuan`,`dibuat_pada`) values 
(1,1,1,5,15000.00,'2025-12-10 09:34:08'),
(2,1,2,3,20000.00,'2025-12-10 09:34:08'),
(3,2,1,4,15000.00,'2025-12-10 09:34:08'),
(4,2,3,2,30000.00,'2025-12-10 09:34:08'),
(5,3,2,6,20000.00,'2025-12-10 09:34:08'),
(6,4,4,8,25000.00,'2025-12-10 09:34:08'),
(7,4,5,5,28000.00,'2025-12-10 09:34:08'),
(8,5,2,7,20000.00,'2025-12-10 09:34:08'),
(9,5,3,1,30000.00,'2025-12-10 09:34:08');

/*Table structure for table `harga_laundry` */

CREATE TABLE `harga_laundry` (
  `id_harga_laundry` int(11) NOT NULL AUTO_INCREMENT,
  `id_layanan_laundry` int(11) NOT NULL,
  `harga` decimal(12,2) NOT NULL,
  `berlaku_dari` date NOT NULL,
  `berlaku_sampai` date DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_harga_laundry`),
  KEY `id_layanan_laundry` (`id_layanan_laundry`),
  CONSTRAINT `harga_laundry_ibfk_1` FOREIGN KEY (`id_layanan_laundry`) REFERENCES `layanan_laundry` (`id_layanan_laundry`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `harga_laundry` */

insert  into `harga_laundry`(`id_harga_laundry`,`id_layanan_laundry`,`harga`,`berlaku_dari`,`berlaku_sampai`,`dibuat_pada`) values 
(1,1,25000.00,'2025-01-01','2025-12-15','2025-12-10 09:34:08'),
(2,2,20000.00,'2025-01-01',NULL,'2025-12-10 09:34:08'),
(3,3,30000.00,'2025-02-01',NULL,'2025-12-10 09:34:08'),
(4,4,25000.00,'2025-03-01',NULL,'2025-12-10 09:34:08'),
(5,5,28000.00,'2025-04-01',NULL,'2025-12-10 09:34:08'),
(6,1,15000.00,'2025-12-16',NULL,'2025-12-16 14:39:19');

/*Table structure for table `kategori_laundry` */

CREATE TABLE `kategori_laundry` (
  `id_kategori_laundry` int(11) NOT NULL AUTO_INCREMENT,
  `kode_kategori` varchar(20) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diperbarui_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_kategori_laundry`),
  UNIQUE KEY `kode_kategori` (`kode_kategori`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `kategori_laundry` */

insert  into `kategori_laundry`(`id_kategori_laundry`,`kode_kategori`,`nama_kategori`,`deskripsi`,`dibuat_pada`,`diperbarui_pada`) values 
(1,'KAT0000001','Pakaian','Layanan untuk pakaian harian seperti kaos, kemeja, celana.','2025-12-10 09:34:08','2025-12-10 09:34:08'),
(2,'KAT0000002','Bed Cover','Layanan cuci untuk bed cover dan selimut besar.','2025-12-10 09:34:08','2025-12-10 09:34:08'),
(3,'KAT0000003','Hotel Linen','Linen hotel seperti sprei, sarung bantal, handuk.','2025-12-10 09:34:08','2025-12-10 09:34:08');

/*Table structure for table `layanan_laundry` */

CREATE TABLE `layanan_laundry` (
  `id_layanan_laundry` int(11) NOT NULL AUTO_INCREMENT,
  `kode_layanan` varchar(20) NOT NULL,
  `id_kategori_laundry` int(11) NOT NULL,
  `nama_layanan` varchar(100) NOT NULL,
  `satuan` varchar(30) NOT NULL,
  `harga_aktif` decimal(12,2) NOT NULL DEFAULT 0.00,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diperbarui_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_layanan_laundry`),
  UNIQUE KEY `kode_layanan` (`kode_layanan`),
  KEY `id_kategori_laundry` (`id_kategori_laundry`),
  CONSTRAINT `layanan_laundry_ibfk_1` FOREIGN KEY (`id_kategori_laundry`) REFERENCES `kategori_laundry` (`id_kategori_laundry`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `layanan_laundry` */

insert  into `layanan_laundry`(`id_layanan_laundry`,`kode_layanan`,`id_kategori_laundry`,`nama_layanan`,`satuan`,`harga_aktif`,`dibuat_pada`,`diperbarui_pada`) values 
(1,'LYN0000001',1,'Cuci Kering Pakaian','kg',15000.00,'2025-12-10 09:34:08','2025-12-16 14:39:19'),
(2,'LYN0000002',1,'Cuci Setrika Pakaian','kg',20000.00,'2025-12-10 09:34:08','2025-12-16 14:36:54'),
(3,'LYN0000003',2,'Cuci Bed Cover','buah',30000.00,'2025-12-10 09:34:08','2025-12-16 14:36:54'),
(4,'LYN0000004',3,'Cuci Linen Hotel','kg',25000.00,'2025-12-10 09:34:08','2025-12-16 14:36:54'),
(5,'LYN0000005',3,'Setrika Linen Hotel','kg',28000.00,'2025-12-10 09:34:08','2025-12-16 14:36:54');

/*Table structure for table `pesanan_laundry` */

CREATE TABLE `pesanan_laundry` (
  `id_pesanan_laundry` int(11) NOT NULL AUTO_INCREMENT,
  `kode_pesanan` varchar(30) NOT NULL,
  `id_tamu` int(11) NOT NULL,
  `id_status_laundry` int(11) NOT NULL,
  `tanggal_masuk` datetime DEFAULT current_timestamp(),
  `tanggal_selesai` datetime DEFAULT NULL,
  `total_biaya` decimal(12,2) DEFAULT 0.00,
  `catatan` text DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diperbarui_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_pesanan_laundry`),
  UNIQUE KEY `kode_pesanan` (`kode_pesanan`),
  KEY `id_status_laundry` (`id_status_laundry`),
  KEY `id_tamu` (`id_tamu`),
  CONSTRAINT `pesanan_laundry_ibfk_1` FOREIGN KEY (`id_status_laundry`) REFERENCES `status_laundry` (`id_status_laundry`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `pesanan_laundry` */

insert  into `pesanan_laundry`(`id_pesanan_laundry`,`kode_pesanan`,`id_tamu`,`id_status_laundry`,`tanggal_masuk`,`tanggal_selesai`,`total_biaya`,`catatan`,`dibuat_pada`,`diperbarui_pada`) values 
(1,'ORD0000001',1,1,'2025-01-10 09:15:00',NULL,0.00,'Laundry pakaian tamu check-in awal tahun','2025-12-10 09:34:08','2025-12-10 09:34:08'),
(2,'ORD0000002',2,2,'2025-02-05 14:30:00',NULL,0.00,'Sedang diproses, minta selesai sebelum jam 10 pagi','2025-12-10 09:34:08','2025-12-10 09:34:08'),
(3,'ORD0000003',3,3,'2025-03-18 10:05:00','2025-03-19 16:30:00',0.00,'Sudah selesai, tinggal diambil','2025-12-10 09:34:08','2025-12-10 09:34:08'),
(4,'ORD0000004',4,4,'2025-05-02 11:45:00','2025-05-03 15:00:00',0.00,'Sudah diambil oleh tamu','2025-12-10 09:34:08','2025-12-10 09:34:08'),
(5,'ORD0000005',5,2,'2025-07-22 08:20:00',NULL,0.00,'Express service, tamu VIP','2025-12-10 09:34:08','2025-12-10 09:34:08');

/*Table structure for table `staf_laundry` */

CREATE TABLE `staf_laundry` (
  `id_staf_laundry` int(11) NOT NULL AUTO_INCREMENT,
  `kode_staf` varchar(20) NOT NULL,
  `nama_lengkap` varchar(150) NOT NULL,
  `nomor_telepon` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `jabatan` varchar(50) DEFAULT NULL,
  `dibuat_pada` timestamp NOT NULL DEFAULT current_timestamp(),
  `diperbarui_pada` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_staf_laundry`),
  UNIQUE KEY `kode_staf` (`kode_staf`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `staf_laundry` */

insert  into `staf_laundry`(`id_staf_laundry`,`kode_staf`,`nama_lengkap`,`nomor_telepon`,`email`,`jabatan`,`dibuat_pada`,`diperbarui_pada`) values 
(1,'STF0000001','Made Surya','081200000001','made.surya@timuring.com','Operator','2025-12-10 09:34:08','2025-12-10 09:34:08'),
(2,'STF0000002','Ni Luh Ayu','081200000002','niluh.ayu@timuring.com','Operator','2025-12-10 09:34:08','2025-12-10 09:34:08'),
(3,'STF0000003','Kadek Budi','081200000003','kadek.budi@timuring.com','Supervisor','2025-12-10 09:34:08','2025-12-10 09:34:08');

/*Table structure for table `status_laundry` */

CREATE TABLE `status_laundry` (
  `id_status_laundry` int(11) NOT NULL AUTO_INCREMENT,
  `kode_status` varchar(20) NOT NULL,
  `nama_status` varchar(50) NOT NULL,
  PRIMARY KEY (`id_status_laundry`),
  UNIQUE KEY `kode_status` (`kode_status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `status_laundry` */

insert  into `status_laundry`(`id_status_laundry`,`kode_status`,`nama_status`) values 
(1,'MENUNGGU','Menunggu Diproses'),
(2,'PROSES','Sedang Diproses'),
(3,'SELESAI','Selesai'),
(4,'DIAMBIL','Sudah Diambil');

/* Trigger structure for table `layanan_laundry` */

DELIMITER $$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `trg_layanan_laundry_ai` AFTER INSERT ON `layanan_laundry` FOR EACH ROW 
BEGIN
  -- kalau ada harga_aktif > 0, buat record histori awal
  IF NEW.harga_aktif IS NOT NULL AND NEW.harga_aktif > 0 THEN
    INSERT INTO harga_laundry (id_layanan_laundry, harga, berlaku_dari, berlaku_sampai)
    VALUES (NEW.id_layanan_laundry, NEW.harga_aktif, CURDATE(), NULL);
  END IF;
END */$$


DELIMITER ;

/* Trigger structure for table `layanan_laundry` */

DELIMITER $$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `trg_layanan_laundry_price_au` AFTER UPDATE ON `layanan_laundry` FOR EACH ROW 
BEGIN
  -- hanya jalan kalau harga_aktif berubah
  IF NEW.harga_aktif <> OLD.harga_aktif THEN

    -- CASE A: jika sudah ada harga aktif mulai hari ini, update saja (hindari periode negatif)
    IF EXISTS (
      SELECT 1
      FROM harga_laundry h
      WHERE h.id_layanan_laundry = NEW.id_layanan_laundry
        AND h.berlaku_sampai IS NULL
        AND h.berlaku_dari = CURDATE()
    ) THEN

      UPDATE harga_laundry
      SET harga = NEW.harga_aktif
      WHERE id_layanan_laundry = NEW.id_layanan_laundry
        AND berlaku_sampai IS NULL
        AND berlaku_dari = CURDATE();

    ELSE
      -- CASE B: tutup harga aktif sebelumnya (kalau ada)
      UPDATE harga_laundry
      SET berlaku_sampai = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
      WHERE id_layanan_laundry = NEW.id_layanan_laundry
        AND berlaku_sampai IS NULL;

      -- insert harga baru mulai hari ini
      INSERT INTO harga_laundry (id_layanan_laundry, harga, berlaku_dari, berlaku_sampai)
      VALUES (NEW.id_layanan_laundry, NEW.harga_aktif, CURDATE(), NULL);
    END IF;

  END IF;
END */$$


DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
