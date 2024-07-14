-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 14, 2024 at 06:28 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ayam`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_kandang_by_id_and_unit` (IN `kandang_id` INT, IN `unit_id` INT)   BEGIN
  IF kandang_id IS NOT NULL AND unit_id IS NOT NULL THEN
    SELECT * 
    FROM kandang
    WHERE id_kandang = kandang_id AND id_unit = unit_id;
  ELSEIF kandang_id IS NOT NULL THEN
    SELECT * 
    FROM kandang
    WHERE id_kandang = kandang_id;
  ELSEIF unit_id IS NOT NULL THEN
    SELECT * 
    FROM kandang
    WHERE id_unit = unit_id;
  ELSE
    SELECT * 
    FROM kandang;
  END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_all_pekerja` ()   BEGIN
  DECLARE total_pekerja INT;
  SELECT COUNT(*) INTO total_pekerja FROM pekerja;

  IF total_pekerja > 0 THEN
    SELECT * FROM pekerja;
  ELSE
    SELECT 'Tidak ada data pekerja' AS message;
  END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `count_kandang` () RETURNS INT(11)  BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM kandang;
  RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_total_pendapatan` (`idKandang` INT, `idPanen` INT) RETURNS INT(11)  BEGIN
  DECLARE totalPendapatan INT;

  SELECT p.pendapatan INTO totalPendapatan
  FROM panen p
  WHERE p.jenis_kandang = idKandang AND p.hasil_panen = idPanen;
  
  RETURN totalPendapatan;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kandang`
--

CREATE TABLE `kandang` (
  `id_kandang` int(11) NOT NULL,
  `ayam_masuk` int(11) DEFAULT NULL,
  `ayam_mati` int(11) DEFAULT NULL,
  `jumlah_ayam` int(11) DEFAULT NULL,
  `id_unit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kandang`
--

INSERT INTO `kandang` (`id_kandang`, `ayam_masuk`, `ayam_mati`, `jumlah_ayam`, `id_unit`) VALUES
(1, 100, 5, 95, 1),
(2, 150, 10, 140, 2),
(3, 200, 16, 185, 3),
(4, 120, 6, 114, 4),
(5, 180, 12, 168, 5);

-- --------------------------------------------------------

--
-- Stand-in structure for view `kandang_besar`
-- (See below for the actual view)
--
CREATE TABLE `kandang_besar` (
`id_kandang` int(11)
,`ayam_masuk` int(11)
,`ayam_mati` int(11)
,`jumlah_ayam` int(11)
,`id_unit` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `kandang_log`
--

CREATE TABLE `kandang_log` (
  `jumlah_ayam_sebelumnya` int(11) DEFAULT NULL,
  `jumlah_ayam_mati` int(11) DEFAULT NULL,
  `jumlah_ayam_sekarang` int(11) DEFAULT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `kandang_log`
--
DELIMITER $$
CREATE TRIGGER `after_delete_kandang_log` AFTER DELETE ON `kandang_log` FOR EACH ROW BEGIN
    INSERT INTO kandang_log_trigger (action_type, jumlah_ayam_sebelumnya, jumlah_ayam_mati, jumlah_ayam_sekarang, time_stamp)
    VALUES ('AFTER_DELETE', OLD.jumlah_ayam_sebelumnya, OLD.jumlah_ayam_mati, OLD.jumlah_ayam_sekarang, OLD.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_kandang_log` AFTER INSERT ON `kandang_log` FOR EACH ROW BEGIN
    INSERT INTO kandang_log_trigger (action_type, jumlah_ayam_sebelumnya, jumlah_ayam_mati, jumlah_ayam_sekarang, time_stamp)
    VALUES ('AFTER_INSERT', NEW.jumlah_ayam_sebelumnya, NEW.jumlah_ayam_mati, NEW.jumlah_ayam_sekarang, NEW.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_kandang_log` AFTER UPDATE ON `kandang_log` FOR EACH ROW BEGIN
    INSERT INTO kandang_log_trigger (action_type, jumlah_ayam_sebelumnya, jumlah_ayam_mati, jumlah_ayam_sekarang, time_stamp)
    VALUES ('AFTER_UPDATE', NEW.jumlah_ayam_sebelumnya, NEW.jumlah_ayam_mati, NEW.jumlah_ayam_sekarang, NEW.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_kandang_log` BEFORE DELETE ON `kandang_log` FOR EACH ROW BEGIN
    INSERT INTO kandang_log_trigger (action_type, jumlah_ayam_sebelumnya, jumlah_ayam_mati, jumlah_ayam_sekarang, time_stamp)
    VALUES ('BEFORE_DELETE', OLD.jumlah_ayam_sebelumnya, OLD.jumlah_ayam_mati, OLD.jumlah_ayam_sekarang, OLD.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_kandang_log` BEFORE INSERT ON `kandang_log` FOR EACH ROW BEGIN
    INSERT INTO kandang_log_trigger (action_type, jumlah_ayam_sebelumnya, jumlah_ayam_mati, jumlah_ayam_sekarang, time_stamp)
    VALUES ('BEFORE_INSERT', NEW.jumlah_ayam_sebelumnya, NEW.jumlah_ayam_mati, NEW.jumlah_ayam_sekarang, NEW.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_kandang_log` BEFORE UPDATE ON `kandang_log` FOR EACH ROW BEGIN
    INSERT INTO kandang_log_trigger (action_type, jumlah_ayam_sebelumnya, jumlah_ayam_mati, jumlah_ayam_sekarang, time_stamp)
    VALUES ('BEFORE_UPDATE', OLD.jumlah_ayam_sebelumnya, OLD.jumlah_ayam_mati, OLD.jumlah_ayam_sekarang, OLD.time_stamp);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kandang_log_trigger`
--

CREATE TABLE `kandang_log_trigger` (
  `action_type` varchar(10) DEFAULT NULL,
  `jumlah_ayam_sebelumnya` int(11) DEFAULT NULL,
  `jumlah_ayam_mati` int(11) DEFAULT NULL,
  `jumlah_ayam_sekarang` int(11) DEFAULT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `change_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kandang_log_trigger`
--

INSERT INTO `kandang_log_trigger` (`action_type`, `jumlah_ayam_sebelumnya`, `jumlah_ayam_mati`, `jumlah_ayam_sekarang`, `time_stamp`, `change_time`) VALUES
('BEFORE_INS', 100, 5, 95, '2024-07-14 14:03:21', '2024-07-14 14:03:21'),
('AFTER_INSE', 100, 5, 95, '2024-07-14 14:03:21', '2024-07-14 14:03:21'),
('BEFORE_UPD', 100, 5, 95, '2024-07-14 14:03:21', '2024-07-14 14:03:53'),
('AFTER_UPDA', 100, 5, 90, '2024-07-14 14:03:53', '2024-07-14 14:03:53'),
('BEFORE_DEL', 100, 5, 90, '2024-07-14 14:03:53', '2024-07-14 14:04:22'),
('AFTER_DELE', 100, 5, 90, '2024-07-14 14:03:53', '2024-07-14 14:04:22');

-- --------------------------------------------------------

--
-- Table structure for table `new_kandang`
--

CREATE TABLE `new_kandang` (
  `id_kandang` int(11) NOT NULL,
  `ayam_masuk` int(11) DEFAULT NULL,
  `ayam_mati` int(11) DEFAULT NULL,
  `jumlah_ayam` int(11) DEFAULT NULL,
  `id_unit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `panen`
--

CREATE TABLE `panen` (
  `hasil_panen` int(11) NOT NULL,
  `bobot_ayam` int(11) DEFAULT NULL,
  `ayam_gagal` int(11) DEFAULT NULL,
  `total_pengeluaran` int(11) DEFAULT NULL,
  `pendapatan` int(11) DEFAULT NULL,
  `jumlah_ayam` int(11) DEFAULT NULL,
  `jenis_kandang` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `panen`
--

INSERT INTO `panen` (`hasil_panen`, `bobot_ayam`, `ayam_gagal`, `total_pengeluaran`, `pendapatan`, `jumlah_ayam`, `jenis_kandang`) VALUES
(1, 1000, 10, 500, 1500, 90, 1),
(2, 1500, 15, 700, 2100, 135, 2),
(3, 2000, 20, 1000, 3000, 170, 3),
(4, 1100, 11, 600, 1600, 103, 4),
(5, 1600, 16, 800, 2200, 152, 5),
(8, 1800, 10, 900, 2500, 160, 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `panen_sukses`
-- (See below for the actual view)
--
CREATE TABLE `panen_sukses` (
`hasil_panen` int(11)
,`bobot_ayam` int(11)
,`ayam_gagal` int(11)
,`total_pengeluaran` int(11)
,`pendapatan` int(11)
,`jumlah_ayam` int(11)
,`jenis_kandang` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `panen_sukses_profit`
-- (See below for the actual view)
--
CREATE TABLE `panen_sukses_profit` (
`hasil_panen` int(11)
,`bobot_ayam` int(11)
,`ayam_gagal` int(11)
,`total_pengeluaran` int(11)
,`pendapatan` int(11)
,`jumlah_ayam` int(11)
,`jenis_kandang` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `pekerja`
--

CREATE TABLE `pekerja` (
  `id_pekerja` int(11) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pekerja`
--

INSERT INTO `pekerja` (`id_pekerja`, `nama`, `alamat`) VALUES
(0, 'Sarah Johnson', NULL),
(1, 'John Doe', '123 Main St'),
(2, 'Jane Smith', '456 Elm St'),
(3, 'Mike Johnson', '789 Oak St'),
(4, 'Alice Brown', '101 Pine St'),
(5, 'Bob White', '202 Maple St');

-- --------------------------------------------------------

--
-- Stand-in structure for view `pekerja_info`
-- (See below for the actual view)
--
CREATE TABLE `pekerja_info` (
`id_pekerja` int(11)
,`nama` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `pengeluaran`
--

CREATE TABLE `pengeluaran` (
  `total_pengeluaran` int(11) NOT NULL,
  `listrik` int(11) DEFAULT NULL,
  `air` int(11) DEFAULT NULL,
  `pakan` int(11) DEFAULT NULL,
  `dana_takterduga` int(11) DEFAULT NULL,
  `hasil_panen` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengeluaran`
--

INSERT INTO `pengeluaran` (`total_pengeluaran`, `listrik`, `air`, `pakan`, `dana_takterduga`, `hasil_panen`) VALUES
(1, 200, 100, 150, 50, 1),
(2, 300, 150, 200, 50, 2),
(3, 400, 200, 300, 100, 3),
(4, 250, 120, 180, 60, 4),
(5, 350, 170, 220, 60, 5);

-- --------------------------------------------------------

--
-- Table structure for table `pengeluaran_log`
--

CREATE TABLE `pengeluaran_log` (
  `jenis_pengeluaran` varchar(255) DEFAULT NULL,
  `jumlah_pengeluaran` decimal(10,2) DEFAULT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `pengeluaran_log`
--
DELIMITER $$
CREATE TRIGGER `after_delete_pengeluaran_log` AFTER DELETE ON `pengeluaran_log` FOR EACH ROW BEGIN
    INSERT INTO pengeluaran_log_trigger (action_type, jenis_pengeluaran, jumlah_pengeluaran, time_stamp)
    VALUES ('AFTER_DELETE', OLD.jenis_pengeluaran, OLD.jumlah_pengeluaran, OLD.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_pengeluaran_log` AFTER INSERT ON `pengeluaran_log` FOR EACH ROW BEGIN
    INSERT INTO pengeluaran_log_trigger (action_type, jenis_pengeluaran, jumlah_pengeluaran, time_stamp)
    VALUES ('AFTER_INSERT', NEW.jenis_pengeluaran, NEW.jumlah_pengeluaran, NEW.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_pengeluaran_log` AFTER UPDATE ON `pengeluaran_log` FOR EACH ROW BEGIN
    INSERT INTO pengeluaran_log_trigger (action_type, jenis_pengeluaran, jumlah_pengeluaran, time_stamp)
    VALUES ('AFTER_UPDATE', NEW.jenis_pengeluaran, NEW.jumlah_pengeluaran, NEW.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_pengeluaran_log` BEFORE DELETE ON `pengeluaran_log` FOR EACH ROW BEGIN
    INSERT INTO pengeluaran_log_trigger (action_type, jenis_pengeluaran, jumlah_pengeluaran, time_stamp)
    VALUES ('BEFORE_DELETE', OLD.jenis_pengeluaran, OLD.jumlah_pengeluaran, OLD.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_pengeluaran_log` BEFORE INSERT ON `pengeluaran_log` FOR EACH ROW BEGIN
    INSERT INTO pengeluaran_log_trigger (action_type, jenis_pengeluaran, jumlah_pengeluaran, time_stamp)
    VALUES ('BEFORE_INSERT', NEW.jenis_pengeluaran, NEW.jumlah_pengeluaran, NEW.time_stamp);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_pengeluaran_log` BEFORE UPDATE ON `pengeluaran_log` FOR EACH ROW BEGIN
    INSERT INTO pengeluaran_log_trigger (action_type, jenis_pengeluaran, jumlah_pengeluaran, time_stamp)
    VALUES ('BEFORE_UPDATE', OLD.jenis_pengeluaran, OLD.jumlah_pengeluaran, OLD.time_stamp);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pengeluaran_log_trigger`
--

CREATE TABLE `pengeluaran_log_trigger` (
  `action_type` varchar(10) DEFAULT NULL,
  `jenis_pengeluaran` varchar(255) DEFAULT NULL,
  `jumlah_pengeluaran` decimal(10,2) DEFAULT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `change_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengeluaran_log_trigger`
--

INSERT INTO `pengeluaran_log_trigger` (`action_type`, `jenis_pengeluaran`, `jumlah_pengeluaran`, `time_stamp`, `change_time`) VALUES
('BEFORE_INS', 'Pakan', 50000.00, '2024-07-14 14:29:38', '2024-07-14 14:29:38'),
('AFTER_INSE', 'Pakan', 50000.00, '2024-07-14 14:29:38', '2024-07-14 14:29:38'),
('BEFORE_UPD', 'Pakan', 50000.00, '2024-07-14 14:29:38', '2024-07-14 14:30:02'),
('AFTER_UPDA', 'Pakan', 55000.00, '2024-07-14 14:30:02', '2024-07-14 14:30:02'),
('BEFORE_DEL', 'Pakan', 55000.00, '2024-07-14 14:30:02', '2024-07-14 14:30:27'),
('AFTER_DELE', 'Pakan', 55000.00, '2024-07-14 14:30:02', '2024-07-14 14:30:27');

-- --------------------------------------------------------

--
-- Table structure for table `unit_kerja`
--

CREATE TABLE `unit_kerja` (
  `id_unit` int(11) NOT NULL,
  `id_pekerja` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `unit_kerja`
--

INSERT INTO `unit_kerja` (`id_unit`, `id_pekerja`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Structure for view `kandang_besar`
--
DROP TABLE IF EXISTS `kandang_besar`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `kandang_besar`  AS SELECT `kandang`.`id_kandang` AS `id_kandang`, `kandang`.`ayam_masuk` AS `ayam_masuk`, `kandang`.`ayam_mati` AS `ayam_mati`, `kandang`.`jumlah_ayam` AS `jumlah_ayam`, `kandang`.`id_unit` AS `id_unit` FROM `kandang` WHERE `kandang`.`jumlah_ayam` > 150 ;

-- --------------------------------------------------------

--
-- Structure for view `panen_sukses`
--
DROP TABLE IF EXISTS `panen_sukses`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `panen_sukses`  AS SELECT `panen`.`hasil_panen` AS `hasil_panen`, `panen`.`bobot_ayam` AS `bobot_ayam`, `panen`.`ayam_gagal` AS `ayam_gagal`, `panen`.`total_pengeluaran` AS `total_pengeluaran`, `panen`.`pendapatan` AS `pendapatan`, `panen`.`jumlah_ayam` AS `jumlah_ayam`, `panen`.`jenis_kandang` AS `jenis_kandang` FROM `panen` WHERE `panen`.`ayam_gagal` < 15WITH CASCADEDCHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `panen_sukses_profit`
--
DROP TABLE IF EXISTS `panen_sukses_profit`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `panen_sukses_profit`  AS SELECT `panen_sukses`.`hasil_panen` AS `hasil_panen`, `panen_sukses`.`bobot_ayam` AS `bobot_ayam`, `panen_sukses`.`ayam_gagal` AS `ayam_gagal`, `panen_sukses`.`total_pengeluaran` AS `total_pengeluaran`, `panen_sukses`.`pendapatan` AS `pendapatan`, `panen_sukses`.`jumlah_ayam` AS `jumlah_ayam`, `panen_sukses`.`jenis_kandang` AS `jenis_kandang` FROM `panen_sukses` WHERE `panen_sukses`.`pendapatan` > 2000WITH LOCALCHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `pekerja_info`
--
DROP TABLE IF EXISTS `pekerja_info`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pekerja_info`  AS SELECT `pekerja`.`id_pekerja` AS `id_pekerja`, `pekerja`.`nama` AS `nama` FROM `pekerja` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kandang`
--
ALTER TABLE `kandang`
  ADD PRIMARY KEY (`id_kandang`),
  ADD KEY `id_unit` (`id_unit`),
  ADD KEY `idx_kandang_unit` (`id_kandang`,`id_unit`);

--
-- Indexes for table `new_kandang`
--
ALTER TABLE `new_kandang`
  ADD PRIMARY KEY (`id_kandang`),
  ADD KEY `idx_id_kandang_unit` (`id_kandang`,`id_unit`);

--
-- Indexes for table `panen`
--
ALTER TABLE `panen`
  ADD PRIMARY KEY (`hasil_panen`),
  ADD KEY `jenis_kandang` (`jenis_kandang`),
  ADD KEY `idx_hasil_panen_bobot` (`hasil_panen`,`bobot_ayam`);

--
-- Indexes for table `pekerja`
--
ALTER TABLE `pekerja`
  ADD PRIMARY KEY (`id_pekerja`);

--
-- Indexes for table `pengeluaran`
--
ALTER TABLE `pengeluaran`
  ADD PRIMARY KEY (`total_pengeluaran`),
  ADD KEY `hasil_panen` (`hasil_panen`);

--
-- Indexes for table `unit_kerja`
--
ALTER TABLE `unit_kerja`
  ADD PRIMARY KEY (`id_unit`),
  ADD KEY `id_pekerja` (`id_pekerja`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kandang`
--
ALTER TABLE `kandang`
  ADD CONSTRAINT `kandang_ibfk_1` FOREIGN KEY (`id_unit`) REFERENCES `unit_kerja` (`id_unit`);

--
-- Constraints for table `panen`
--
ALTER TABLE `panen`
  ADD CONSTRAINT `panen_ibfk_1` FOREIGN KEY (`jenis_kandang`) REFERENCES `kandang` (`id_kandang`);

--
-- Constraints for table `pengeluaran`
--
ALTER TABLE `pengeluaran`
  ADD CONSTRAINT `pengeluaran_ibfk_1` FOREIGN KEY (`hasil_panen`) REFERENCES `panen` (`hasil_panen`);

--
-- Constraints for table `unit_kerja`
--
ALTER TABLE `unit_kerja`
  ADD CONSTRAINT `unit_kerja_ibfk_1` FOREIGN KEY (`id_pekerja`) REFERENCES `pekerja` (`id_pekerja`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
