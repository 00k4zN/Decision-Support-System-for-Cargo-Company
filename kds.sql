-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 29 Ara 2022, 15:22:23
-- Sunucu sürümü: 8.0.27
-- PHP Sürümü: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `kds`
--

DELIMITER $$
--
-- Yordamlar
--
DROP PROCEDURE IF EXISTS `anlasma_sayisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `anlasma_sayisi` ()  SELECT COUNT(antlasmalar.antlasmaID) FROM antlasmalar$$

DROP PROCEDURE IF EXISTS `araclar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `araclar` ()  SELECT arac.plaka, arac.aracTipi, arac.aracHacmi,arac_bakim.bakimTutar,sube.subeAd
FROM arac,sube, arac_bakim
WHERE sube.subeID=arac.subeID AND arac_bakim.plaka=arac.plaka
GROUP BY arac.plaka
ORDER BY arac_bakim.bakimTutar ASC$$

DROP PROCEDURE IF EXISTS `arac_bakim_tutari`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arac_bakim_tutari` ()  SELECT sube.subeAd,arac.plaka, arac.aracTipi, arac.aracHacmi, arac_bakim.bakimTutar, arac_bakim.tarih
FROM sube,arac_bakim,arac
WHERE sube.subeID=arac.subeID AND arac_bakim.plaka=arac.plaka
GROUP BY arac.plaka$$

DROP PROCEDURE IF EXISTS `arac_sayisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arac_sayisi` ()  SELECT COUNT(arac.plaka) a_sayisi FROM arac$$

DROP PROCEDURE IF EXISTS `en_cok_antlasma_yapan_mudurler`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `en_cok_antlasma_yapan_mudurler` ()  SELECT sube.subeAd, personel.perAd, personel.perSoyad,personel.anlasmaSayisi, gorev.gorevAd
FROM personel,gorev,sube
WHERE sube.subeID=personel.subeID AND personel.gorevID=gorev.gorevID AND gorev.gorevAd LIKE '%Şube Müdürü%'
GROUP BY sube.subeID$$

DROP PROCEDURE IF EXISTS `en_cok_tercih_edilen_arac`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `en_cok_tercih_edilen_arac` ()  SELECT arac.aracTipi as pid, COUNT(arac.plaka) as arac_sayisi
FROM arac
GROUP BY arac.aracTipi 
ORDER BY arac_sayisi DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `gelen`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `gelen` ()  SELECT sube.subeAd as "Şube Adı" , COUNT(kargo.durumID) AS "Gelen Kargo Sayısı"
FROM kargo_tur, kargo, sube
WHERE kargo_tur.kargoTurID=kargo.kargoTurID and sube.subeID=kargo.subeID and kargo_tur.kargoTurAd LIKE'Gelen Kargo'
GROUP BY sube.subeID$$

DROP PROCEDURE IF EXISTS `gelir`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `gelir` ()  SELECT sube.subeAd as x, sube_gelir.gelir_yillik as y FROM sube,sube_gelir WHERE sube.subeID=sube_gelir.subeID GROUP BY sube.subeID$$

DROP PROCEDURE IF EXISTS `giden`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `giden` ()  SELECT sube.subeAd as "Şube Adı" , COUNT(kargo.durumID) AS "Gönderilen Kargo Sayısı"
FROM kargo_tur, kargo, sube
WHERE kargo_tur.kargoTurID=kargo.kargoTurID and sube.subeID=kargo.subeID and kargo_tur.kargoTurID LIKE 353535
GROUP BY sube.subeID$$

DROP PROCEDURE IF EXISTS `gider`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `gider` ()  SELECT sube.subeAd as x, sube_gider.gider_yillik as y FROM sube,sube_gider WHERE sube.subeID=sube_gider.subeID GROUP BY sube.subeID$$

DROP PROCEDURE IF EXISTS `kar_sayisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `kar_sayisi` ()  SELECT (SUM(sube_gelir.gelir_yillik))-(SUM(sube_gider.gider_yillik)) k_sayisi FROM sube_gelir,sube_gider$$

DROP PROCEDURE IF EXISTS `maks_antlasma_mudur`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `maks_antlasma_mudur` ()  SELECT CONCAT(personel.perAd,' ',personel.perSoyad) as pid, COUNT(antlasmalar.antlasmaID) as agreement_count
FROM antlasmalar
JOIN personel ON antlasmalar.perID = personel.perID
GROUP BY personel.perID
ORDER BY agreement_count DESC LIMIT 1$$

DROP PROCEDURE IF EXISTS `maks_puan`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `maks_puan` ()  SELECT MAX(personel.performansPuani) FROM personel$$

DROP PROCEDURE IF EXISTS `ortalama_puan`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ortalama_puan` ()  SELECT round(AVG(personel.performansPuani),1) FROM personel$$

DROP PROCEDURE IF EXISTS `personel_sayisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `personel_sayisi` ()  SELECT COUNT(personel.perID) p_sayisi FROM personel$$

DROP PROCEDURE IF EXISTS `pers_tablo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `pers_tablo` ()  SELECT concat(personel.perAd,' ',personel.perSoyad), gorev.gorevAd, sube.subeAd, personel.performansPuani
FROM sube,personel,gorev
WHERE sube.subeID=personel.subeID AND gorev.gorevID=personel.gorevID
GROUP BY personel.perID
ORDER BY personel.performansPuani ASC$$

DROP PROCEDURE IF EXISTS `sube_arac_sayisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sube_arac_sayisi` ()  SELECT sube.subeAd, COUNT(arac.plaka) as arac_sayisi
FROM arac,sube
WHERE sube.subeID=arac.subeID
GROUP BY sube.subeID$$

DROP PROCEDURE IF EXISTS `sube_bilgisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sube_bilgisi` (IN `subeId` INT)  SELECT sube.subeID, sube.subeAd, concat(sube.kira, "TL") as kira, sube.subeKapasite as kapasite, COUNT(personel.perID) as personel, round(AVG(personel.performansPuani),1) as performansPuani,
       (CASE
            WHEN (sube_gelir.gelir_yillik)-(sube_gider.gider_yillik) > 0 THEN 'Şube Karda'
            ELSE 'Şube Son Bir Yılda Fazla Zarar Etti Kapatılması Öneriliyor'
        END) as kar_zarar_durumu
FROM sube
JOIN personel ON sube.subeID=personel.subeID
JOIN sube_gider ON sube_gider.subeID=sube.subeID
JOIN sube_gelir ON sube_gelir.subeID=sube.subeID
WHERE sube.subeID = subeId
GROUP BY sube.subeID$$

DROP PROCEDURE IF EXISTS `sube_kargo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sube_kargo` ()  SELECT sube.subeAd AS "Şube Adı", COUNT(kargo.kargoID) AS "kargo sayısı"
FROM sube, kargo
WHERE sube.subeID=kargo.subeID
GROUP BY sube.subeID$$

DROP PROCEDURE IF EXISTS `sube_personel_bilgisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sube_personel_bilgisi` ()  SELECT personel.perAd, personel.perSoyad, personel.performansPuani, personel.personelMaas, personel.perTel, personel.perMail, gorev.gorevAd
FROM personel,gorev,sube
WHERE sube.subeID=personel.subeID AND personel.gorevID=gorev.gorevID AND sube.subeAd LIKE '%Buca-2%'$$

DROP PROCEDURE IF EXISTS `sube_sayisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sube_sayisi` ()  SELECT COUNT(sube.subeID) s_sayisi FROM sube$$

DROP PROCEDURE IF EXISTS `toplam_gelen_kargo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `toplam_gelen_kargo` ()  SELECT COUNT(kargo.kargoTurID) FROM kargo
WHERE kargo.kargoTurID LIKE 353531$$

DROP PROCEDURE IF EXISTS `toplam_gonderilen_kargo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `toplam_gonderilen_kargo` ()  SELECT COUNT(kargo.kargoTurID) FROM kargo
WHERE kargo.kargoTurID LIKE 353535$$

DROP PROCEDURE IF EXISTS `toplam_kira`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `toplam_kira` ()  SELECT SUM(sube.kira) FROM sube$$

DROP PROCEDURE IF EXISTS `toplam_maas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `toplam_maas` ()  SELECT SUM(personel.personelMaas) FROM personel$$

DROP PROCEDURE IF EXISTS `toplam_musteri`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `toplam_musteri` ()  SELECT COUNT(musteri.musID) FROM musteri$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `antlasmalar`
--

DROP TABLE IF EXISTS `antlasmalar`;
CREATE TABLE IF NOT EXISTS `antlasmalar` (
  `antlasmaID` int NOT NULL,
  `antlasmaTuru` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `perID` int NOT NULL,
  PRIMARY KEY (`antlasmaID`),
  KEY `personel_ant` (`perID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `antlasmalar`
--

INSERT INTO `antlasmalar` (`antlasmaID`, `antlasmaTuru`, `perID`) VALUES
(827, 'Kurumsal', 10101014),
(828, 'Kurumsal', 10101014),
(829, 'Kurumsal', 10101014),
(830, 'Kurumsal', 10101014),
(831, 'Kurumsal', 10101014),
(832, 'Kurumsal', 10101014),
(833, 'Kurumsal', 10101014),
(834, 'Kurumsal', 10101014),
(835, 'Kurumsal', 10101020),
(836, 'Kurumsal', 10101020),
(837, 'Kurumsal', 10101020),
(838, 'Kurumsal', 10101020),
(839, 'Kurumsal', 10101020),
(840, 'Kurumsal', 10101020),
(858, 'Kurumsal', 10101032),
(859, 'Kurumsal', 10101032),
(860, 'Kurumsal', 10101032),
(861, 'Kurumsal', 10101032),
(862, 'Kurumsal', 10101032),
(871, 'Kurumsal', 10101044),
(872, 'Kurumsal', 10101044),
(873, 'Kurumsal', 10101044),
(874, 'Kurumsal', 10101044),
(875, 'Kurumsal', 10101044);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `arac`
--

DROP TABLE IF EXISTS `arac`;
CREATE TABLE IF NOT EXISTS `arac` (
  `plaka` varchar(55) COLLATE utf8_turkish_ci NOT NULL,
  `aracTipi` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `aracHacmi` int NOT NULL,
  `subeID` int NOT NULL,
  PRIMARY KEY (`plaka`),
  KEY `sube_arac` (`subeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `arac`
--

INSERT INTO `arac` (`plaka`, `aracTipi`, `aracHacmi`, `subeID`) VALUES
('35ACB7982', 'Panelvan', 15, 3500400),
('35CCC2243', 'Panelvan', 15, 35001300),
('35GGG9513', 'Panelvan', 15, 35001200),
('35HFG2147', 'Panelvan', 15, 35002100),
('35KKK8520', 'Kamyonet', 20, 35001300),
('35KSK9600', 'Panelvan', 15, 35002900),
('35LMS5828', 'Panelvan', 15, 35002200);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `arac_bakim`
--

DROP TABLE IF EXISTS `arac_bakim`;
CREATE TABLE IF NOT EXISTS `arac_bakim` (
  `bakimID` int NOT NULL,
  `plaka` varchar(55) COLLATE utf8_turkish_ci NOT NULL,
  `bakimTutar` int NOT NULL,
  `tarih` date NOT NULL,
  PRIMARY KEY (`bakimID`),
  KEY `bakimaracc` (`plaka`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `arac_bakim`
--

INSERT INTO `arac_bakim` (`bakimID`, `plaka`, `bakimTutar`, `tarih`) VALUES
(2021100, '35KSK9600', 8500, '2022-12-01'),
(2021103, '35ACB7982', 1000, '2021-02-11'),
(2021110, '35CCC2243', 1000, '2021-09-25'),
(2021111, '35GGG9513', 1690, '2022-12-14'),
(2021115, '35LMS5828', 1140, '2022-12-09'),
(2021116, '35HFG2147', 2500, '2022-12-12'),
(2021117, '35KKK8520', 6530, '2022-12-22');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `dagitim`
--

DROP TABLE IF EXISTS `dagitim`;
CREATE TABLE IF NOT EXISTS `dagitim` (
  `dagitimID` int NOT NULL,
  `subeID` int NOT NULL,
  `aylikDagitimKapasite` int NOT NULL,
  PRIMARY KEY (`dagitimID`),
  KEY `dagitim_sube_sube` (`subeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `dagitim`
--

INSERT INTO `dagitim` (`dagitimID`, `subeID`, `aylikDagitimKapasite`) VALUES
(20210005, 3500400, 300),
(20210009, 35002100, 300),
(202100012, 35001300, 300),
(202100016, 35001200, 300),
(202100019, 35002200, 300),
(202100023, 35002900, 300);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `durum`
--

DROP TABLE IF EXISTS `durum`;
CREATE TABLE IF NOT EXISTS `durum` (
  `durumID` int NOT NULL,
  `durumAdi` varchar(255) COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`durumID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `durum`
--

INSERT INTO `durum` (`durumID`, `durumAdi`) VALUES
(30001, 'Teslim Alındı'),
(30002, 'Teslim Edildi'),
(30003, 'Teslim Alınamadı'),
(30004, 'Teslim Edilemedi'),
(30005, 'Zarar Gören Kargo');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `gorev`
--

DROP TABLE IF EXISTS `gorev`;
CREATE TABLE IF NOT EXISTS `gorev` (
  `gorevID` int NOT NULL,
  `gorevAd` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`gorevID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `gorev`
--

INSERT INTO `gorev` (`gorevID`, `gorevAd`) VALUES
(10001, 'Şube Müdürü'),
(10002, 'Kargo Operatörü'),
(10003, 'Depo Sorumlusu'),
(10004, 'Kurye'),
(10005, 'Yükleme Boşaltma Elemanı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `il`
--

DROP TABLE IF EXISTS `il`;
CREATE TABLE IF NOT EXISTS `il` (
  `ilID` int NOT NULL,
  `ilAd` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`ilID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `il`
--

INSERT INTO `il` (`ilID`, `ilAd`) VALUES
(9035, 'İzmir');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `ilce`
--

DROP TABLE IF EXISTS `ilce`;
CREATE TABLE IF NOT EXISTS `ilce` (
  `ilceID` int NOT NULL,
  `ilceAd` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `ilceNufus` int NOT NULL,
  `ilID` int NOT NULL,
  PRIMARY KEY (`ilceID`),
  KEY `ilce_il` (`ilID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `ilce`
--

INSERT INTO `ilce` (`ilceID`, `ilceAd`, `ilceNufus`, `ilID`) VALUES
(350001, 'Aliağa', 103364, 9035),
(350002, 'Balçova', 80513, 9035),
(350003, 'Bayındır', 40049, 9035),
(350004, 'Bayraklı', 296839, 9035),
(350005, 'Bergama', 104980, 9035),
(350006, 'Beydağ', 12197, 9035),
(350007, 'Bornova', 452867, 9035),
(350008, 'Buca', 517963, 9035),
(350009, 'Çeşme', 48167, 9035),
(350010, 'Çiğli', 209951, 9035),
(350011, 'Dikili', 46587, 9035),
(350012, 'Foça', 33611, 9035),
(350013, 'Gaziemir', 137856, 9035),
(350014, 'Güzelbahçe', 37572, 9035),
(350015, 'Karabağlar', 478788, 9035),
(350016, 'Karaburun', 11927, 9035),
(350017, 'Karşıyaka', 347023, 9035),
(350018, 'Kemalpaşa', 112049, 9035),
(350019, 'Kınık', 28513, 9035),
(350020, 'Kiraz', 43674, 9035),
(350021, 'Konak', 336545, 9035),
(350022, 'Menderes', 104147, 9035),
(350023, 'Menemen', 193229, 9035),
(350024, 'Narlıdere', 63438, 9035),
(350025, 'Ödemiş', 132769, 9035),
(350026, 'Seferihisar', 52507, 9035),
(350027, 'Selçuk', 37689, 9035),
(350028, 'Tire', 86758, 9035),
(350029, 'Torbalı ', 201476, 9035),
(350030, 'Urla', 72741, 9035);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kara_liste`
--

DROP TABLE IF EXISTS `kara_liste`;
CREATE TABLE IF NOT EXISTS `kara_liste` (
  `perAd` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `perSoyad` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `performansPuani` int NOT NULL,
  `eklenme_tarihi` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `kara_liste`
--

INSERT INTO `kara_liste` (`perAd`, `perSoyad`, `performansPuani`, `eklenme_tarihi`) VALUES
('Tuna', 'YUTAN', 2, '0000-00-00 00:00:00'),
('Mustafa Kemal', 'Koçak', 6, '0000-00-00 00:00:00'),
('Semih', 'UYAR', 2, '2022-12-28 07:03:47'),
('Kadir', 'Aksu', 1, '2022-12-28 10:21:32'),
('Arzu', 'Gül', 2, '2022-12-28 10:31:50');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kargo`
--

DROP TABLE IF EXISTS `kargo`;
CREATE TABLE IF NOT EXISTS `kargo` (
  `kargoID` int NOT NULL,
  `kargoTurID` int NOT NULL,
  `durumID` int NOT NULL,
  `subeID` int NOT NULL,
  `musID` int NOT NULL,
  `kargoUcret` float NOT NULL,
  PRIMARY KEY (`kargoID`),
  KEY `kargo_durum` (`durumID`),
  KEY `kargo_sube` (`subeID`),
  KEY `kargo_musteri` (`musID`),
  KEY `kargo_turu` (`kargoTurID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `kargo`
--

INSERT INTO `kargo` (`kargoID`, `kargoTurID`, `durumID`, `subeID`, `musID`, `kargoUcret`) VALUES
(202202, 353531, 30002, 3500400, 3524, 12),
(202203, 353531, 30001, 3500400, 3525, 10),
(202204, 353531, 30002, 3500400, 3526, 20),
(202206, 353531, 30002, 3500400, 3528, 5),
(202207, 353531, 30001, 3500400, 3529, 5),
(202208, 353531, 30002, 3500400, 3530, 6),
(202210, 353531, 30002, 35002100, 3532, 8),
(202211, 353535, 30001, 3500400, 3533, 9),
(202212, 353531, 30002, 35001200, 3534, 10),
(202213, 353535, 30001, 35002900, 3535, 11),
(202214, 353535, 30001, 3500400, 3536, 12),
(202216, 353535, 30001, 3500400, 3538, 14),
(202217, 353531, 30002, 3500400, 3539, 15),
(202219, 353531, 30002, 3500400, 3541, 17),
(202220, 353535, 30001, 3500400, 3542, 18),
(202221, 353531, 30002, 3500400, 3543, 19),
(202223, 353531, 30002, 35002100, 3545, 21),
(202224, 353535, 30001, 3500400, 3546, 22),
(202225, 353531, 30002, 35001200, 3547, 23),
(202226, 353535, 30001, 35002900, 3548, 24),
(202227, 353535, 30001, 3500400, 3523, 10),
(202229, 353531, 30001, 35002200, 3524, 21),
(202230, 353531, 30001, 35002200, 3525, 22),
(202231, 353531, 30001, 35002200, 3526, 23),
(202232, 353531, 30001, 35002200, 3527, 24),
(202233, 353531, 30001, 35002200, 3528, 25),
(202234, 353531, 30001, 35002100, 3529, 26),
(202235, 353531, 30001, 35002100, 3530, 27),
(202236, 353531, 30001, 35002100, 3531, 28),
(202237, 353531, 30001, 35002100, 3532, 29),
(202238, 353531, 30001, 35002200, 3533, 30),
(202239, 353531, 30001, 35002200, 3534, 31),
(202240, 353531, 30001, 35002200, 3535, 32),
(202241, 353531, 30001, 35002200, 3536, 33),
(202242, 353531, 30001, 35002200, 3537, 34),
(202243, 353531, 30001, 35002100, 3538, 35),
(202244, 353531, 30001, 35002100, 3539, 36),
(202245, 353531, 30001, 35002100, 3540, 37),
(202246, 353531, 30001, 35002100, 3541, 38),
(202247, 353531, 30001, 35002100, 3542, 39),
(202248, 353531, 30001, 35002100, 3543, 40),
(202249, 353531, 30001, 35002100, 3544, 41),
(202250, 353531, 30001, 35002100, 3545, 42),
(202251, 353531, 30001, 35002100, 3546, 43),
(202252, 353531, 30001, 35002100, 3547, 44),
(202253, 353531, 30001, 35002100, 3548, 45),
(202254, 353531, 30001, 35002100, 3549, 46),
(202255, 353531, 30001, 35002100, 3550, 47),
(202256, 353531, 30001, 35002100, 3551, 48),
(202257, 353531, 30001, 35002100, 3552, 49),
(202258, 353531, 30001, 35002100, 3553, 50),
(202259, 353531, 30001, 35002100, 3554, 51),
(202260, 353531, 30001, 35002100, 3555, 31),
(202261, 353531, 30001, 35002100, 3556, 32),
(202262, 353531, 30001, 35002100, 3557, 33),
(202263, 353531, 30001, 35002100, 3558, 34),
(202264, 353531, 30001, 35002100, 3559, 35),
(202265, 353531, 30001, 35002100, 3560, 36),
(202266, 353531, 30001, 35002100, 3561, 37),
(202267, 353531, 30001, 35002100, 3534, 38),
(202268, 353531, 30001, 35002100, 3535, 39),
(202269, 353531, 30001, 35002100, 3536, 40),
(202270, 353531, 30001, 35002100, 3537, 41),
(202271, 353531, 30001, 35002100, 3538, 42),
(202272, 353531, 30001, 35002100, 3539, 43),
(202273, 353535, 30002, 35001200, 3534, 12),
(202274, 353535, 30002, 35001200, 3535, 10),
(202275, 353535, 30002, 35001200, 3536, 20),
(202276, 353535, 30002, 35001200, 3537, 30),
(202277, 353535, 30002, 35001200, 3538, 5),
(202278, 353535, 30002, 35001200, 3539, 5),
(202279, 353535, 30002, 35001200, 3540, 6),
(202280, 353535, 30002, 35001200, 3541, 7),
(202281, 353535, 30002, 35001200, 3542, 8),
(202282, 353535, 30002, 35001200, 3543, 9),
(202283, 353535, 30002, 35001200, 3544, 10),
(202284, 353535, 30002, 35001200, 3545, 11),
(202285, 353535, 30002, 35001200, 3546, 12),
(202286, 353535, 30002, 35001200, 3547, 13),
(202287, 353535, 30002, 35001200, 3548, 14),
(202288, 353535, 30002, 35001200, 3549, 15),
(202289, 353535, 30002, 35001200, 3550, 16),
(202290, 353535, 30002, 35001200, 3551, 17),
(202291, 353535, 30002, 35001200, 3552, 18),
(202292, 353535, 30002, 35001200, 3553, 19),
(202293, 353535, 30002, 35001200, 3554, 20),
(202294, 353535, 30002, 35001200, 3555, 21),
(202295, 353535, 30002, 35001200, 3556, 22),
(202296, 353535, 30002, 35001200, 3557, 23),
(202297, 353535, 30002, 35001200, 3558, 24),
(202298, 353535, 30002, 35001200, 3559, 10),
(202299, 353535, 30002, 35001200, 3560, 20),
(202300, 353535, 30002, 35001200, 3561, 21),
(202301, 353535, 30002, 35001200, 3534, 22),
(202302, 353535, 30002, 35001200, 3535, 23),
(202303, 353535, 30002, 35001200, 3536, 24),
(202304, 353535, 30002, 35001200, 3537, 12),
(202305, 353535, 30002, 35001200, 3538, 10),
(202306, 353535, 30002, 35001200, 3539, 20),
(202307, 353535, 30002, 35001200, 3534, 30),
(202308, 353535, 30002, 35001200, 3535, 5),
(202309, 353535, 30002, 35001200, 3536, 5),
(202310, 353535, 30002, 35001200, 3537, 6),
(202311, 353535, 30002, 35001200, 3538, 7),
(202312, 353535, 30002, 35001200, 3539, 8),
(202313, 353535, 30002, 35001200, 3540, 9),
(202314, 353535, 30002, 35001200, 3541, 10),
(202315, 353535, 30002, 35001200, 3542, 11),
(202316, 353535, 30002, 35001200, 3543, 12),
(202317, 353535, 30002, 35001200, 3544, 13),
(202318, 353535, 30002, 35001200, 3545, 14),
(202319, 353535, 30002, 35001200, 3546, 15),
(202320, 353535, 30002, 35001200, 3547, 16),
(202321, 353535, 30002, 35001200, 3548, 17),
(202322, 353535, 30002, 35001200, 3549, 18),
(202323, 353535, 30002, 35001200, 3550, 19),
(202324, 353535, 30002, 35001200, 3551, 20),
(202325, 353535, 30002, 35001200, 3552, 21),
(202326, 353535, 30002, 35001200, 3553, 22),
(202327, 353535, 30002, 35002900, 3554, 10),
(202328, 353535, 30002, 35002900, 3555, 11),
(202329, 353535, 30002, 35001300, 3556, 12),
(202330, 353535, 30002, 35001300, 3557, 13),
(202331, 353535, 30002, 35001300, 3558, 14),
(202332, 353535, 30002, 35001300, 3559, 15),
(202333, 353535, 30002, 35002900, 3560, 16),
(202334, 353535, 30002, 35002900, 3561, 17),
(202335, 353535, 30002, 35002900, 3562, 18),
(202336, 353535, 30002, 35002900, 3563, 19),
(202337, 353535, 30002, 35002900, 3564, 20),
(202338, 353535, 30002, 35002900, 3565, 21);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kargo_dagitim`
--

DROP TABLE IF EXISTS `kargo_dagitim`;
CREATE TABLE IF NOT EXISTS `kargo_dagitim` (
  `plaka` varchar(55) COLLATE utf8_turkish_ci NOT NULL,
  `dagitimID` int NOT NULL,
  KEY `kargo_dagitim_arac` (`dagitimID`),
  KEY `dagitim_kargo` (`plaka`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `kargo_dagitim`
--

INSERT INTO `kargo_dagitim` (`plaka`, `dagitimID`) VALUES
('35KKK8520', 20210005),
('35KKK8520', 20210009),
('35KKK8520', 202100012);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kargo_tur`
--

DROP TABLE IF EXISTS `kargo_tur`;
CREATE TABLE IF NOT EXISTS `kargo_tur` (
  `kargoTurID` int NOT NULL,
  `kargoTurAd` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`kargoTurID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `kargo_tur`
--

INSERT INTO `kargo_tur` (`kargoTurID`, `kargoTurAd`) VALUES
(353531, 'Gelen Kargo'),
(353535, 'Giden Kargo');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kullanicilar`
--

DROP TABLE IF EXISTS `kullanicilar`;
CREATE TABLE IF NOT EXISTS `kullanicilar` (
  `kullaniciID` int NOT NULL AUTO_INCREMENT,
  `kullaniciAdi` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `parola` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`kullaniciID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `kullanicilar`
--

INSERT INTO `kullanicilar` (`kullaniciID`, `kullaniciAdi`, `parola`) VALUES
(1, 'admin', '1234');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `musteri`
--

DROP TABLE IF EXISTS `musteri`;
CREATE TABLE IF NOT EXISTS `musteri` (
  `musID` int NOT NULL,
  `musAd` varchar(55) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `musSoyad` varchar(55) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `musTel` varchar(55) COLLATE utf8_turkish_ci NOT NULL,
  `musMail` varchar(255) COLLATE utf8_turkish_ci DEFAULT NULL,
  PRIMARY KEY (`musID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `musteri`
--

INSERT INTO `musteri` (`musID`, `musAd`, `musSoyad`, `musTel`, `musMail`) VALUES
(3000, 'Derya', 'Gül', '5234579861', 'derya.gül@hotmail.com'),
(3001, 'Cengiz', 'Yıldırım', '5123456789', 'cengiz.yıldırım@hotmail.com'),
(3501, 'Halime', 'Polat', '5123456987', 'halime.polat@hotmail.com'),
(3502, 'Emir', 'Özdemir', '5234569871', 'emir.özdemir@hotmail.com'),
(3503, 'Sevilay', 'Yıldırım', '5345698712', 'sevilay.yıldırım@hotmail.com'),
(3504, 'Mustafa Kemal', 'Güneş', '5456987123', 'mustafa kemal.güneş@hotmail.com'),
(3505, 'Gülhan', 'Gümüş', '5569871234', 'gülhan.gümüş@hotmail.com'),
(3506, 'Necati', 'Özkan', '5698712345', 'necati.özkan@hotmail.com'),
(3507, 'Nuran', 'Kara', '5798712345', 'nuran.kara@hotmail.com'),
(3508, 'Erdal', 'Günay', '5898712345', 'erdal.günay@hotmail.com'),
(3509, 'Necdet', 'Çelik', '5123457986', 'necdet.çelik@hotmail.com'),
(3510, 'Tülay', 'Güzel', '5234579861', 'tülay.güzel@hotmail.com'),
(3511, 'Meltem', 'Erdoğan', '5123456789', 'meltem.erdoğan@hotmail.com'),
(3512, 'Yılmaz', 'Kılıç', '5234567891', 'yılmaz.kılıç@hotmail.com'),
(3513, 'Rabia', 'Güney', '5345678912', 'rabia.güney@hotmail.com'),
(3514, 'Sadık', 'Yıldız', '5456789123', 'sadık.yıldız@hotmail.com'),
(3515, 'Deniz', 'Çetinkaya', '5567891234', 'deniz.çetinkaya@hotmail.com'),
(3516, 'Gülsün', 'Özçelik', '5678912345', 'gülsün.özçelik@hotmail.com'),
(3517, 'İlhan', 'Bozkurt', '5789123456', 'ilhan.bozkurt@hotmail.com'),
(3518, 'Gülşahin', 'Gül', '5891234567', 'gülşahin.gül@hotmail.com'),
(3519, 'Serap', 'Eren', '5123456781', 'serap.eren@hotmail.com'),
(3520, 'Tuğba', 'Yıldırım', '5234567819', 'tuğba.yıldırım@hotmail.com'),
(3521, 'Erdoğan', 'Çalışkan', '5345678191', 'erdoğan.çalışkan@hotmail.com'),
(3522, 'Yıldız', 'Gültekin', '5456781912', 'yıldız.gültekin@hotmail.com'),
(3523, 'Ahmet', 'Özkan', '5567819123', 'ahmet.özkan@hotmail.com'),
(3524, 'Mehmet', 'Gündüz', '5678191234', 'mehmet.gündüz@hotmail.com'),
(3525, 'Fatma', 'Doğan', '5789191235', 'fatma.doğan@hotmail.com'),
(3526, 'Ayşe', 'Güner', '5891912345', 'ayşe.güner@hotmail.com'),
(3527, 'İbrahim', 'Öztürk', '5123456879', 'ibrahim.öztürk@hotmail.com'),
(3528, 'Zeynep', 'Çelik', '5234568791', 'zeynep.çelik@hotmail.com'),
(3529, 'Ali', 'Güneş', '5345687912', 'ali.güneş@hotmail.com'),
(3530, 'Emine', 'Çakır', '5456879123', 'emine.çakır@hotmail.com'),
(3531, 'Mustafa', 'Gül', '5568791234', 'mustafa.gül@hotmail.com'),
(3532, 'Sibel', 'Özdemir', '5687912345', 'sibel.özdemir@hotmail.com'),
(3533, 'Osman', 'Yıldız', '5789123458', 'osman.yıldız@hotmail.com'),
(3534, 'Nuray', 'Çetinkaya', '5891234587', 'nuray.çetinkaya@hotmail.com'),
(3535, 'Yusuf', 'Çelik', '5123456978', 'yusuf.çelik@hotmail.com'),
(3536, 'Hülya', 'Gümüş', '5234569781', 'hülya.gümüş@hotmail.com'),
(3537, 'Ömer', 'Günay', '5345697812', 'ömer.günay@hotmail.com'),
(3538, 'Elif', 'Çalışkan', '5456978123', 'elif.çalışkan@hotmail.com'),
(3539, 'Salih', 'Özkan', '5569781234', 'salih.özkan@hotmail.com'),
(3540, 'Hatice', 'Gül', '5697812345', 'hatice.gül@hotmail.com'),
(3541, 'Mahmut', 'Yıldırım', '5798123456', 'mahmut.yıldırım@hotmail.com'),
(3542, 'Esra', 'Çakır', '5898123457', 'esra.çakır@hotmail.com'),
(3543, 'Murat', 'Güler', '5123457689', 'murat.güler@hotmail.com'),
(3544, 'Meryem', 'Güneş', '5234576891', 'meryem.güneş@hotmail.com'),
(3545, 'Cem', 'Öztürk', '5345768912', 'cem.öztürk@hotmail.com'),
(3546, 'Can', 'Çetin', '5457689123', 'can.çetin@hotmail.com'),
(3547, 'Gül', 'Güzel', '5568912346', 'gül.güzel@hotmail.com'),
(3548, 'Hakan', 'Gültekin', '5678912364', 'hakan.gültekin@hotmail.com'),
(3549, 'Serkan', 'Kaya', '5789123456', 'serkan.kaya@hotmail.com'),
(3550, 'Derya', 'Demir', '5891234567', 'derya.demir@hotmail.com'),
(3551, 'Cengiz', 'Erdoğan', '5123457789', 'cengiz.erdoğan@hotmail.com'),
(3552, 'İsmail', 'Köse', '5234577891', 'ismail.köse@hotmail.com'),
(3553, 'Kadir', 'Akar', '5345778912', 'kadir.akar@hotmail.com'),
(3554, 'Nurcan', 'Özçelik', '5457789123', 'nurcan.özçelik@hotmail.com'),
(3555, 'Aslı', 'Çelik', '5577891234', 'aslı.çelik@hotmail.com'),
(3556, 'Turgay', 'Gül', '5678912345', 'turgay.gül@hotmail.com'),
(3557, 'Leyla', 'Gündüz', '5778912345', 'leyla.gündüz@hotmail.com'),
(3558, 'Samet', 'Yıldırım', '5878912345', 'samet.yıldırım@hotmail.com'),
(3559, 'Merve', 'Çalışkan', '5123458769', 'merve.çalışkan@hotmail.com'),
(3560, 'Bülent', 'Özdemir', '5234587691', 'bülent.özdemir@hotmail.com'),
(3561, 'Asuman', 'Güner', '5345876912', 'asuman.güner@hotmail.com'),
(3562, 'Özlem', 'Güneş', '5458769123', 'özlem.güneş@hotmail.com'),
(3563, 'Ramazan', 'Çakır', '5587612345', 'ramazan.çakır@hotmail.com'),
(3564, 'Gülsüm', 'Kara', '5687123456', 'gülsüm.kara@hotmail.com'),
(3565, 'Özgür', 'Gültekin', '5712345689', 'özgür.gültekin@hotmail.com'),
(3566, 'Ayten', 'Güler', '5812345679', 'ayten.güler@hotmail.com'),
(3567, 'İlkay', 'Öztürk', '5123459768', 'ilkay.öztürk@hotmail.com'),
(3568, 'Ferhat', 'Yıldız', '5234597681', 'ferhat.yıldız@hotmail.com'),
(3569, 'Gülşen', 'Çetinkaya', '5345976812', 'gülşen.çetinkaya@hotmail.com'),
(3570, 'Özcan', 'Çelik', '5459768123', 'özcan.çelik@hotmail.com'),
(3571, 'Cemile', 'Gümüş', '5559681234', 'cemile.gümüş@hotmail.com'),
(3572, 'Emre', 'Günay', '5659681234', 'emre.günay@hotmail.com'),
(3573, 'Süleyman', 'Çalışkan', '5712345986', 'süleyman.çalışkan@hotmail.com'),
(3574, 'Gülten', 'Özkan', '5812345986', 'gülten.özkan@hotmail.com'),
(3575, 'Fatih', 'Gül', '5123456897', 'fatih.gül@hotmail.com'),
(3576, 'Nihal', 'Yıldırım', '5234568791', 'nihal.yıldırım@hotmail.com'),
(3577, 'Halil', 'Çakır', '5345689712', 'halil.çakır@hotmail.com'),
(3578, 'Zeynel', 'Güler', '5456897123', 'zeynel.güler@hotmail.com'),
(3579, 'Erkan', 'Güneş', '5568971234', 'erkan.güneş@hotmail.com'),
(3580, 'Gülşah', 'Öztürk', '5689712345', 'gülşah.öztürk@hotmail.com'),
(3581, 'Taner', 'Çetin', '5789123456', 'taner.çetin@hotmail.com'),
(3582, 'Arzu', 'Öztürk', '5891234567', 'arzu.öztürk@hotmail.com'),
(3583, 'Sevil', 'Kaya', '5123457896', 'sevil.kaya@hotmail.com'),
(3584, 'Öznur', 'Demir', '5234578961', 'öznur.demir@hotmail.com'),
(3585, 'Cihan', 'Yılmaz', '5345789612', 'cihan.yılmaz@hotmail.com'),
(3586, 'Hakkı', 'Çetin', '5457896123', 'hakkı.çetin@hotmail.com'),
(3587, 'Yasemin', 'Güler', '5567891234', 'yasemin.güler@hotmail.com'),
(3588, 'Mert', 'Köse', '5678912345', 'mert.köse@hotmail.com'),
(3589, 'Sezen', 'Akar', '5778912345', 'sezen.akar@hotmail.com'),
(3590, 'Hilal', 'Koç', '5878912345', 'hilal.koç@hotmail.com'),
(3591, 'Halime', 'Gündoğan', '5123458976', 'halime.gündoğan@hotmail.com'),
(3592, 'Emir', 'Bayraktar', '5234589761', 'emir.bayraktar@hotmail.com'),
(3593, 'Sevilay', 'Polat', '5345897612', 'sevilay.polat@hotmail.com'),
(3594, 'Mustafa Kemal', 'Özdemir', '5458976123', 'mustafa kemal.özdemir@hotmail.com'),
(3595, 'Gülhan', 'Yıldırım', '5589612345', 'gülhan.yıldırım@hotmail.com'),
(3596, 'Necati', 'Güneş', '5689612345', 'necati.güneş@hotmail.com'),
(3597, 'Nuran', 'Gümüş', '5712345689', 'nuran.gümüş@hotmail.com'),
(3598, 'Erdal', 'Özkan', '5812345679', 'erdal.özkan@hotmail.com'),
(3599, 'Necdet', 'Kara', '5123456987', 'necdet.kara@hotmail.com'),
(3600, 'Tülay', 'Günay', '5234569871', 'tülay.günay@hotmail.com'),
(3601, 'Meltem', 'Çelik', '5345698712', 'meltem.çelik@hotmail.com'),
(3602, 'Yılmaz', 'Güzel', '5456987123', 'yılmaz.güzel@hotmail.com'),
(3603, 'Rabia', 'Erdoğan', '5569871234', 'rabia.erdoğan@hotmail.com'),
(3604, 'Sadık', 'Kılıç', '5698712345', 'sadık.kılıç@hotmail.com'),
(3605, 'Deniz', 'Güney', '5798712345', 'deniz.güney@hotmail.com'),
(3606, 'Gülsün', 'Yıldız', '5898712345', 'gülsün.yıldız@hotmail.com'),
(3607, 'İlhan', 'Çetinkaya', '5123457986', 'ilhan.çetinkaya@hotmail.com'),
(3608, 'Gülşahin', 'Özçelik', '5234579861', 'gülşahin.özçelik@hotmail.com'),
(3609, 'Serap', 'Bozkurt', '5123456789', 'serap.bozkurt@hotmail.com'),
(3610, 'Tuğba', 'Gül', '5234567891', 'tuğba.gül@hotmail.com'),
(3611, 'Erdoğan', 'Eren', '5345678912', 'erdoğan.eren@hotmail.com'),
(3612, 'Yıldız', 'Yıldırım', '5456789123', 'yıldız.yıldırım@hotmail.com'),
(3613, 'Ahmet', 'Çalışkan', '5567891234', 'ahmet.çalışkan@hotmail.com'),
(3614, 'Mehmet', 'Gültekin', '5678912345', 'mehmet.gültekin@hotmail.com'),
(3615, 'Fatma', 'Özkan', '5789123456', 'fatma.özkan@hotmail.com'),
(3616, 'Ayşe', 'Gündüz', '5891234567', 'ayşe.gündüz@hotmail.com'),
(3617, 'İbrahim', 'Doğan', '5123456781', 'ibrahim.doğan@hotmail.com'),
(3618, 'Zeynep', 'Güner', '5234567819', 'zeynep.güner@hotmail.com'),
(3619, 'Ali', 'Öztürk', '5345678191', 'ali.öztürk@hotmail.com'),
(3620, 'Emine', 'Çelik', '5456781912', 'emine.çelik@hotmail.com'),
(3621, 'Mustafa', 'Güneş', '5567819123', 'mustafa.güneş@hotmail.com'),
(3622, 'Sibel', 'Çakır', '5678191234', 'sibel.çakır@hotmail.com'),
(3623, 'Osman', 'Gül', '5789191235', 'osman.gül@hotmail.com'),
(3624, 'Nuray', 'Özdemir', '5891912345', 'nuray.özdemir@hotmail.com'),
(3625, 'Yusuf', 'Yıldız', '5123456879', 'yusuf.yıldız@hotmail.com'),
(3626, 'Hülya', 'Çetinkaya', '5234568791', 'hülya.çetinkaya@hotmail.com'),
(3627, 'Ömer', 'Çelik', '5345687912', 'ömer.çelik@hotmail.com'),
(3628, 'Elif', 'Gümüş', '5456879123', 'elif.gümüş@hotmail.com'),
(3629, 'Salih', 'Günay', '5568791234', 'salih.günay@hotmail.com'),
(3630, 'Hatice', 'Çalışkan', '5687912345', 'hatice.çalışkan@hotmail.com'),
(3631, 'Mahmut', 'Özkan', '5789123458', 'mahmut.özkan@hotmail.com'),
(3632, 'Esra', 'Gül', '5891234587', 'esra.gül@hotmail.com'),
(3633, 'Murat', 'Yıldırım', '5123456978', 'murat.yıldırım@hotmail.com'),
(3634, 'Meryem', 'Çakır', '5234569781', 'meryem.çakır@hotmail.com'),
(3635, 'Cem', 'Güler', '5345697812', 'cem.güler@hotmail.com'),
(3636, 'Can', 'Güneş', '5456978123', 'can.güneş@hotmail.com'),
(3637, 'Gül', 'Öztürk', '5569781234', 'gül.öztürk@hotmail.com'),
(3638, 'Hakan', 'Çetin', '5697812345', 'hakan.çetin@hotmail.com'),
(3639, 'Serkan', 'Güzel', '5798123456', 'serkan.güzel@hotmail.com'),
(3640, 'Derya', 'Gültekin', '5898123457', 'derya.gültekin@hotmail.com'),
(3641, 'Cengiz', 'Kaya', '5123457689', 'cengiz.kaya@hotmail.com'),
(3642, 'İsmail', 'Demir', '5234576891', 'ismail.demir@hotmail.com'),
(3643, 'Kadir', 'Erdoğan', '5345768912', 'kadir.erdoğan@hotmail.com'),
(3644, 'Nurcan', 'Köse', '5457689123', 'nurcan.köse@hotmail.com'),
(3645, 'Aslı', 'Akar', '5568912346', 'aslı.akar@hotmail.com'),
(3646, 'Turgay', 'Özçelik', '5678912364', 'turgay.özçelik@hotmail.com'),
(3647, 'Leyla', 'Çelik', '5789123456', 'leyla.çelik@hotmail.com'),
(3648, 'Samet', 'Gül', '5891234567', 'samet.gül@hotmail.com'),
(3649, 'Merve', 'Gündüz', '5123457789', 'merve.gündüz@hotmail.com'),
(3650, 'Bülent', 'Yıldırım', '5234577891', 'bülent.yıldırım@hotmail.com'),
(3651, 'Asuman', 'Çalışkan', '5345778912', 'asuman.çalışkan@hotmail.com'),
(3652, 'Özlem', 'Özdemir', '5457789123', 'özlem.özdemir@hotmail.com'),
(3653, 'Ramazan', 'Güner', '5577891234', 'ramazan.güner@hotmail.com'),
(3654, 'Gülsüm', 'Güneş', '5678912345', 'gülsüm.güneş@hotmail.com'),
(3655, 'Özgür', 'Çakır', '5778912345', 'özgür.çakır@hotmail.com'),
(3656, 'Ayten', 'Kara', '5878912345', 'ayten.kara@hotmail.com'),
(3657, 'İlkay', 'Gültekin', '5123458769', 'ilkay.gültekin@hotmail.com'),
(3658, 'Ferhat', 'Güler', '5234587691', 'ferhat.güler@hotmail.com'),
(3659, 'Gülşen', 'Öztürk', '5345876912', 'gülşen.öztürk@hotmail.com'),
(3660, 'Özcan', 'Yıldız', '5458769123', 'özcan.yıldız@hotmail.com'),
(3661, 'Cemile', 'Çetinkaya', '5587612345', 'cemile.çetinkaya@hotmail.com'),
(3662, 'Emre', 'Çelik', '5687123456', 'emre.çelik@hotmail.com'),
(3663, 'Süleyman', 'Gümüş', '5712345689', 'süleyman.gümüş@hotmail.com'),
(3664, 'Gülten', 'Günay', '5812345679', 'gülten.günay@hotmail.com'),
(3665, 'Fatih', 'Çalışkan', '5123459768', 'fatih.çalışkan@hotmail.com'),
(3666, 'Nihal', 'Özkan', '5234597681', 'nihal.özkan@hotmail.com'),
(3667, 'Halil', 'Gül', '5345976812', 'halil.gül@hotmail.com'),
(3668, 'Zeynel', 'Yıldırım', '5459768123', 'zeynel.yıldırım@hotmail.com'),
(3669, 'Erkan', 'Çakır', '5559681234', 'erkan.çakır@hotmail.com'),
(3670, 'Gülşah', 'Güler', '5659681234', 'gülşah.güler@hotmail.com'),
(3671, 'Taner', 'Güneş', '5712345986', 'taner.güneş@hotmail.com'),
(3672, 'Arzu', 'Öztürk', '5812345986', 'arzu.öztürk@hotmail.com'),
(3673, 'Sevil', 'Çetin', '5123456897', 'sevil.çetin@hotmail.com'),
(3674, 'Öznur', 'Öztürk', '5234568791', 'öznur.öztürk@hotmail.com'),
(3675, 'Cihan', 'Kaya', '5345689712', 'cihan.kaya@hotmail.com'),
(3676, 'Hakkı', 'Demir', '5456897123', 'hakkı.demir@hotmail.com'),
(3677, 'Yasemin', 'Yılmaz', '5568971234', 'yasemin.yılmaz@hotmail.com'),
(3678, 'Mert', 'Çetin', '5689712345', 'mert.çetin@hotmail.com'),
(3679, 'Sezen', 'Güler', '5789123456', 'sezen.güler@hotmail.com'),
(3680, 'Hilal', 'Köse', '5891234567', 'hilal.köse@hotmail.com'),
(3681, 'Halime', 'Akar', '5123457896', 'halime.akar@hotmail.com'),
(3682, 'Emir', 'Koç', '5234578961', 'emir.koç@hotmail.com'),
(3683, 'Sevilay', 'Gündoğan', '5345789612', 'sevilay.gündoğan@hotmail.com'),
(3684, 'Mustafa Kemal', 'Bayraktar', '5457896123', 'mustafa kemal.bayraktar@hotmail.com'),
(3685, 'Gülhan', 'Polat', '5567891234', 'gülhan.polat@hotmail.com'),
(3686, 'Necati', 'Özdemir', '5678912345', 'necati.özdemir@hotmail.com'),
(3687, 'Nuran', 'Yıldırım', '5778912345', 'nuran.yıldırım@hotmail.com'),
(3688, 'Erdal', 'Güneş', '5878912345', 'erdal.güneş@hotmail.com'),
(3689, 'Necdet', 'Gümüş', '5123458976', 'necdet.gümüş@hotmail.com'),
(3690, 'Tülay', 'Özkan', '5234589761', 'tülay.özkan@hotmail.com'),
(3691, 'Meltem', 'Kara', '5345897612', 'meltem.kara@hotmail.com'),
(3692, 'Yılmaz', 'Günay', '5458976123', 'yılmaz.günay@hotmail.com'),
(3693, 'Rabia', 'Çelik', '5589612345', 'rabia.çelik@hotmail.com'),
(3694, 'Sadık', 'Güzel', '5689612345', 'sadık.güzel@hotmail.com'),
(3695, 'Deniz', 'Erdoğan', '5712345689', 'deniz.erdoğan@hotmail.com'),
(3696, 'Gülsün', 'Kılıç', '5812345679', 'gülsün.kılıç@hotmail.com'),
(3697, 'İlhan', 'Güney', '5123456987', 'ilhan.güney@hotmail.com'),
(3698, 'Gülşahin', 'Yıldız', '5234569871', 'gülşahin.yıldız@hotmail.com'),
(3699, 'Serap', 'Çetinkaya', '5345698712', 'serap.çetinkaya@hotmail.com'),
(3700, 'Tuğba', 'Özçelik', '5456987123', 'tuğba.özçelik@hotmail.com'),
(3701, 'Erdoğan', 'Bozkurt', '5569871234', 'erdoğan.bozkurt@hotmail.com'),
(3702, 'Yıldız', 'Gül', '5698712345', 'yıldız.gül@hotmail.com'),
(3703, 'Ahmet', 'Eren', '5798712345', 'ahmet.eren@hotmail.com'),
(3704, 'Mehmet', 'Yıldırım', '5898712345', 'mehmet.yıldırım@hotmail.com'),
(3705, 'Fatma', 'Çalışkan', '5123457986', 'fatma.çalışkan@hotmail.com'),
(3706, 'Ayşe', 'Gültekin', '5234579861', 'ayşe.gültekin@hotmail.com'),
(3707, 'İbrahim', 'Özkan', '5123456789', 'ibrahim.özkan@hotmail.com'),
(3708, 'Zeynep', 'Gündüz', '5234567891', 'zeynep.gündüz@hotmail.com'),
(3709, 'Ali', 'Doğan', '5345678912', 'ali.doğan@hotmail.com'),
(3710, 'Emine', 'Güner', '5456789123', 'emine.güner@hotmail.com'),
(3711, 'Mustafa', 'Öztürk', '5567891234', 'mustafa.öztürk@hotmail.com'),
(3712, 'Sibel', 'Çelik', '5678912345', 'sibel.çelik@hotmail.com'),
(3713, 'Osman', 'Güneş', '5789123456', 'osman.güneş@hotmail.com'),
(3714, 'Nuray', 'Çakır', '5891234567', 'nuray.çakır@hotmail.com'),
(3715, 'Yusuf', 'Gül', '5123456781', 'yusuf.gül@hotmail.com'),
(3716, 'Hülya', 'Özdemir', '5234567819', 'hülya.özdemir@hotmail.com'),
(3717, 'Ömer', 'Yıldız', '5345678191', 'ömer.yıldız@hotmail.com'),
(3718, 'Elif', 'Çetinkaya', '5456781912', 'elif.çetinkaya@hotmail.com'),
(3719, 'Salih', 'Çelik', '5567819123', 'salih.çelik@hotmail.com'),
(3720, 'Hatice', 'Gümüş', '5678191234', 'hatice.gümüş@hotmail.com'),
(3721, 'Mahmut', 'Günay', '5789191235', 'mahmut.günay@hotmail.com'),
(3722, 'Esra', 'Çalışkan', '5891912345', 'esra.çalışkan@hotmail.com'),
(3723, 'Murat', 'Özkan', '5123456879', 'murat.özkan@hotmail.com'),
(3724, 'Meryem', 'Gül', '5234568791', 'meryem.gül@hotmail.com'),
(3725, 'Cem', 'Yıldırım', '5345687912', 'cem.yıldırım@hotmail.com'),
(3726, 'Can', 'Çakır', '5456879123', 'can.çakır@hotmail.com'),
(3727, 'Gül', 'Güler', '5568791234', 'gül.güler@hotmail.com'),
(3728, 'Hakan', 'Güneş', '5687912345', 'hakan.güneş@hotmail.com'),
(3729, 'Serkan', 'Öztürk', '5789123458', 'serkan.öztürk@hotmail.com'),
(3730, 'Derya', 'Çetin', '5891234587', 'derya.çetin@hotmail.com'),
(3731, 'Cengiz', 'Güzel', '5123456978', 'cengiz.güzel@hotmail.com'),
(3732, 'İsmail', 'Gültekin', '5234569781', 'ismail.gültekin@hotmail.com'),
(3733, 'Kadir', 'Kaya', '5345697812', 'kadir.kaya@hotmail.com'),
(3734, 'Nurcan', 'Demir', '5456978123', 'nurcan.demir@hotmail.com'),
(3735, 'Aslı', 'Erdoğan', '5569781234', 'aslı.erdoğan@hotmail.com'),
(3736, 'Turgay', 'Köse', '5697812345', 'turgay.köse@hotmail.com'),
(3737, 'Leyla', 'Akar', '5798123456', 'leyla.akar@hotmail.com'),
(3738, 'Samet', 'Özçelik', '5898123457', 'samet.özçelik@hotmail.com'),
(3739, 'Merve', 'Çelik', '5123457689', 'merve.çelik@hotmail.com'),
(3740, 'Bülent', 'Gül', '5234576891', 'bülent.gül@hotmail.com'),
(3741, 'Asuman', 'Gündüz', '5345768912', 'asuman.gündüz@hotmail.com'),
(3742, 'Özlem', 'Yıldırım', '5457689123', 'özlem.yıldırım@hotmail.com'),
(3743, 'Ramazan', 'Çalışkan', '5568912346', 'ramazan.çalışkan@hotmail.com'),
(3744, 'Gülsüm', 'Özdemir', '5678912364', 'gülsüm.özdemir@hotmail.com'),
(3745, 'Özgür', 'Güner', '5789123456', 'özgür.güner@hotmail.com'),
(3746, 'Ayten', 'Güneş', '5891234567', 'ayten.güneş@hotmail.com'),
(3747, 'İlkay', 'Çakır', '5123457789', 'ilkay.çakır@hotmail.com'),
(3748, 'Ferhat', 'Kara', '5234577891', 'ferhat.kara@hotmail.com'),
(3749, 'Gülşen', 'Gültekin', '5345778912', 'gülşen.gültekin@hotmail.com'),
(3750, 'Özcan', 'Güler', '5457789123', 'özcan.güler@hotmail.com'),
(3751, 'Cemile', 'Öztürk', '5577891234', 'cemile.öztürk@hotmail.com'),
(3752, 'Emre', 'Yıldız', '5678912345', 'emre.yıldız@hotmail.com'),
(3753, 'Süleyman', 'Çetinkaya', '5778912345', 'süleyman.çetinkaya@hotmail.com'),
(3754, 'Gülten', 'Çelik', '5878912345', 'gülten.çelik@hotmail.com'),
(3755, 'Fatih', 'Gümüş', '5123458769', 'fatih.gümüş@hotmail.com'),
(3756, 'Nihal', 'Günay', '5234587691', 'nihal.günay@hotmail.com'),
(3757, 'Halil', 'Çalışkan', '5345876912', 'halil.çalışkan@hotmail.com'),
(3758, 'Zeynel', 'Özkan', '5458769123', 'zeynel.özkan@hotmail.com'),
(3759, 'Erkan', 'Gül', '5587612345', 'erkan.gül@hotmail.com'),
(3760, 'Gülşah', 'Yıldırım', '5687123456', 'gülşah.yıldırım@hotmail.com'),
(3761, 'Taner', 'Çakır', '5712345689', 'taner.çakır@hotmail.com'),
(3762, 'Arzu', 'Güler', '5812345679', 'arzu.güler@hotmail.com'),
(3763, 'Sevil', 'Güneş', '5123459768', 'sevil.güneş@hotmail.com'),
(3764, 'Öznur', 'Öztürk', '5234597681', 'öznur.öztürk@hotmail.com'),
(3765, 'Cihan', 'Çetin', '5345976812', 'cihan.çetin@hotmail.com'),
(3766, 'Hakkı', 'Öztürk', '5459768123', 'hakkı.öztürk@hotmail.com'),
(3767, 'Yasemin', 'Kaya', '5559681234', 'yasemin.kaya@hotmail.com'),
(3768, 'Mert', 'Demir', '5659681234', 'mert.demir@hotmail.com'),
(3769, 'Sezen', 'Yılmaz', '5712345986', 'sezen.yılmaz@hotmail.com'),
(3770, 'Hilal', 'Çetin', '5812345986', 'hilal.çetin@hotmail.com'),
(3771, 'Halime', 'Güler', '5123456897', 'halime.güler@hotmail.com'),
(3772, 'Emir', 'Köse', '5234568791', 'emir.köse@hotmail.com'),
(3773, 'Sevilay', 'Akar', '5345689712', 'sevilay.akar@hotmail.com'),
(3774, 'Mustafa Kemal', 'Koç', '5456897123', 'mustafa kemal.koç@hotmail.com'),
(3775, 'Gülhan', 'Gündoğan', '5568971234', 'gülhan.gündoğan@hotmail.com'),
(3776, 'Necati', 'Bayraktar', '5689712345', 'necati.bayraktar@hotmail.com'),
(3777, 'Nuran', 'Polat', '5789123456', 'nuran.polat@hotmail.com'),
(3778, 'Erdal', 'Özdemir', '5891234567', 'erdal.özdemir@hotmail.com'),
(3779, 'Necdet', 'Yıldırım', '5123457896', 'necdet.yıldırım@hotmail.com'),
(3780, 'Tülay', 'Güneş', '5234578961', 'tülay.güneş@hotmail.com'),
(3781, 'Meltem', 'Gümüş', '5345789612', 'meltem.gümüş@hotmail.com'),
(3782, 'Yılmaz', 'Özkan', '5457896123', 'yılmaz.özkan@hotmail.com'),
(3783, 'Rabia', 'Kara', '5567891234', 'rabia.kara@hotmail.com'),
(3784, 'Sadık', 'Günay', '5678912345', 'sadık.günay@hotmail.com'),
(3785, 'Deniz', 'Çelik', '5778912345', 'deniz.çelik@hotmail.com'),
(3786, 'Gülsün', 'Güzel', '5878912345', 'gülsün.güzel@hotmail.com'),
(3787, 'İlhan', 'Erdoğan', '5123458976', 'ilhan.erdoğan@hotmail.com'),
(3788, 'Gülşahin', 'Kılıç', '5234589761', 'gülşahin.kılıç@hotmail.com'),
(3789, 'Serap', 'Güney', '5345897612', 'serap.güney@hotmail.com'),
(3790, 'Tuğba', 'Yıldız', '5458976123', 'tuğba.yıldız@hotmail.com'),
(3791, 'Erdoğan', 'Çetinkaya', '5589612345', 'erdoğan.çetinkaya@hotmail.com'),
(3792, 'Yıldız', 'Özçelik', '5689612345', 'yıldız.özçelik@hotmail.com'),
(3793, 'Ahmet', 'Bozkurt', '5712345689', 'ahmet.bozkurt@hotmail.com'),
(3794, 'Mehmet', 'Gül', '5812345679', 'mehmet.gül@hotmail.com'),
(3795, 'Fatma', 'Eren', '5123456987', 'fatma.eren@hotmail.com'),
(3796, 'Ayşe', 'Yıldırım', '5234569871', 'ayşe.yıldırım@hotmail.com'),
(3797, 'İbrahim', 'Çalışkan', '5345698712', 'ibrahim.çalışkan@hotmail.com'),
(3798, 'Zeynep', 'Gültekin', '5456987123', 'zeynep.gültekin@hotmail.com'),
(3799, 'Ali', 'Özkan', '5569871234', 'ali.özkan@hotmail.com'),
(3800, 'Emine', 'Gündüz', '5698712345', 'emine.gündüz@hotmail.com'),
(3801, 'Mustafa', 'Doğan', '5798712345', 'mustafa.doğan@hotmail.com'),
(3802, 'Sibel', 'Güner', '5898712345', 'sibel.güner@hotmail.com'),
(3803, 'Osman', 'Öztürk', '5123457986', 'osman.öztürk@hotmail.com'),
(3804, 'Nuray', 'Çelik', '5234579861', 'nuray.çelik@hotmail.com'),
(3805, 'Yusuf', 'Güneş', '5123456789', 'yusuf.güneş@hotmail.com'),
(3806, 'Hülya', 'Çakır', '5234567891', 'hülya.çakır@hotmail.com'),
(3807, 'Ömer', 'Gül', '5345678912', 'ömer.gül@hotmail.com'),
(3808, 'Elif', 'Özdemir', '5456789123', 'elif.özdemir@hotmail.com'),
(3809, 'Salih', 'Yıldız', '5567891234', 'salih.yıldız@hotmail.com'),
(3810, 'Hatice', 'Çetinkaya', '5678912345', 'hatice.çetinkaya@hotmail.com'),
(3811, 'Mahmut', 'Çelik', '5789123456', 'mahmut.çelik@hotmail.com'),
(3812, 'Esra', 'Gümüş', '5891234567', 'esra.gümüş@hotmail.com'),
(3813, 'Murat', 'Günay', '5123456781', 'murat.günay@hotmail.com'),
(3814, 'Meryem', 'Çalışkan', '5234567819', 'meryem.çalışkan@hotmail.com'),
(3815, 'Cem', 'Özkan', '5345678191', 'cem.özkan@hotmail.com'),
(3816, 'Can', 'Gül', '5456781912', 'can.gül@hotmail.com'),
(3817, 'Gül', 'Yıldırım', '5567819123', 'gül.yıldırım@hotmail.com'),
(3818, 'Hakan', 'Çakır', '5678191234', 'hakan.çakır@hotmail.com'),
(3819, 'Serkan', 'Güler', '5789191235', 'serkan.güler@hotmail.com'),
(3820, 'Derya', 'Güneş', '5891912345', 'derya.güneş@hotmail.com'),
(3821, 'Cengiz', 'Öztürk', '5123456879', 'cengiz.öztürk@hotmail.com'),
(3822, 'İsmail', 'Çetin', '5234568791', 'ismail.çetin@hotmail.com'),
(3823, 'Kadir', 'Güzel', '5345687912', 'kadir.güzel@hotmail.com'),
(3824, 'Nurcan', 'Gültekin', '5456879123', 'nurcan.gültekin@hotmail.com'),
(3825, 'Aslı', 'Kaya', '5568791234', 'aslı.kaya@hotmail.com'),
(3826, 'Turgay', 'Demir', '5687912345', 'turgay.demir@hotmail.com'),
(3827, 'Leyla', 'Erdoğan', '5789123458', 'leyla.erdoğan@hotmail.com'),
(3828, 'Samet', 'Köse', '5891234587', 'samet.köse@hotmail.com'),
(3829, 'Merve', 'Akar', '5123456978', 'merve.akar@hotmail.com'),
(3830, 'Bülent', 'Özçelik', '5234569781', 'bülent.özçelik@hotmail.com'),
(3831, 'Asuman', 'Çelik', '5345697812', 'asuman.çelik@hotmail.com'),
(3832, 'Özlem', 'Gül', '5456978123', 'özlem.gül@hotmail.com'),
(3833, 'Ramazan', 'Gündüz', '5569781234', 'ramazan.gündüz@hotmail.com'),
(3834, 'Gülsüm', 'Yıldırım', '5697812345', 'gülsüm.yıldırım@hotmail.com'),
(3835, 'Özgür', 'Çalışkan', '5798123456', 'özgür.çalışkan@hotmail.com'),
(3836, 'Ayten', 'Özdemir', '5898123457', 'ayten.özdemir@hotmail.com'),
(3837, 'İlkay', 'Güner', '5123457689', 'ilkay.güner@hotmail.com'),
(3838, 'Ferhat', 'Güneş', '5234576891', 'ferhat.güneş@hotmail.com'),
(3839, 'Gülşen', 'Çakır', '5345768912', 'gülşen.çakır@hotmail.com'),
(3840, 'Özcan', 'Kara', '5457689123', 'özcan.kara@hotmail.com'),
(3841, 'Cemile', 'Gültekin', '5568912346', 'cemile.gültekin@hotmail.com'),
(3842, 'Emre', 'Güler', '5678912364', 'emre.güler@hotmail.com'),
(3843, 'Süleyman', 'Öztürk', '5789123456', 'süleyman.öztürk@hotmail.com'),
(3844, 'Gülten', 'Yıldız', '5891234567', 'gülten.yıldız@hotmail.com'),
(3845, 'Fatih', 'Çetinkaya', '5123457789', 'fatih.çetinkaya@hotmail.com'),
(3846, 'Nihal', 'Çelik', '5234577891', 'nihal.çelik@hotmail.com'),
(3847, 'Halil', 'Gümüş', '5345778912', 'halil.gümüş@hotmail.com'),
(3848, 'Zeynel', 'Günay', '5457789123', 'zeynel.günay@hotmail.com'),
(3849, 'Erkan', 'Çalışkan', '5577891234', 'erkan.çalışkan@hotmail.com'),
(3850, 'Gülşah', 'Özkan', '5678912345', 'gülşah.özkan@hotmail.com'),
(3851, 'Taner', 'Gül', '5778912345', 'taner.gül@hotmail.com'),
(3852, 'Arzu', 'Yıldırım', '5878912345', 'arzu.yıldırım@hotmail.com'),
(3853, 'Sevil', 'Çakır', '5123458769', 'sevil.çakır@hotmail.com'),
(3854, 'Öznur', 'Güler', '5234587691', 'öznur.güler@hotmail.com'),
(3855, 'Cihan', 'Güneş', '5345876912', 'cihan.güneş@hotmail.com'),
(3856, 'Hakkı', 'Öztürk', '5458769123', 'hakkı.öztürk@hotmail.com'),
(3857, 'Yasemin', 'Çetin', '5587612345', 'yasemin.çetin@hotmail.com'),
(3858, 'Mert', 'Öztürk', '5687123456', 'mert.öztürk@hotmail.com'),
(3859, 'Sezen', 'Kaya', '5712345689', 'sezen.kaya@hotmail.com'),
(3860, 'Hilal', 'Demir', '5812345679', 'hilal.demir@hotmail.com'),
(3861, 'Halime', 'Yılmaz', '5123459768', 'halime.yılmaz@hotmail.com'),
(3862, 'Emir', 'Çetin', '5234597681', 'emir.çetin@hotmail.com'),
(3863, 'Sevilay', 'Güler', '5345976812', 'sevilay.güler@hotmail.com'),
(3864, 'Mustafa Kemal', 'Köse', '5459768123', 'mustafa kemal.köse@hotmail.com'),
(3865, 'Gülhan', 'Akar', '5559681234', 'gülhan.akar@hotmail.com'),
(3866, 'Necati', 'Koç', '5659681234', 'necati.koç@hotmail.com'),
(3867, 'Nuran', 'Gündoğan', '5712345986', 'nuran.gündoğan@hotmail.com'),
(3868, 'Erdal', 'Bayraktar', '5812345986', 'erdal.bayraktar@hotmail.com'),
(3869, 'Necdet', 'Polat', '5123456897', 'necdet.polat@hotmail.com'),
(3870, 'Tülay', 'Özdemir', '5234568791', 'tülay.özdemir@hotmail.com'),
(3871, 'Meltem', 'Yıldırım', '5345689712', 'meltem.yıldırım@hotmail.com'),
(3872, 'Yılmaz', 'Güneş', '5456897123', 'yılmaz.güneş@hotmail.com'),
(3873, 'Rabia', 'Gümüş', '5568971234', 'rabia.gümüş@hotmail.com'),
(3874, 'Sadık', 'Özkan', '5689712345', 'sadık.özkan@hotmail.com'),
(3875, 'Deniz', 'Kara', '5789123456', 'deniz.kara@hotmail.com'),
(3876, 'Gülsün', 'Günay', '5891234567', 'gülsün.günay@hotmail.com'),
(3877, 'İlhan', 'Çelik', '5123457896', 'ilhan.çelik@hotmail.com'),
(3878, 'Gülşahin', 'Güzel', '5234578961', 'gülşahin.güzel@hotmail.com'),
(3879, 'Serap', 'Erdoğan', '5345789612', 'serap.erdoğan@hotmail.com'),
(3880, 'Tuğba', 'Kılıç', '5457896123', 'tuğba.kılıç@hotmail.com'),
(3881, 'Erdoğan', 'Güney', '5567891234', 'erdoğan.güney@hotmail.com'),
(3882, 'Yıldız', 'Yıldız', '5678912345', 'yıldız.yıldız@hotmail.com'),
(3883, 'Ahmet', 'Çetinkaya', '5778912345', 'ahmet.çetinkaya@hotmail.com'),
(3884, 'Mehmet', 'Özçelik', '5878912345', 'mehmet.özçelik@hotmail.com'),
(3885, 'Fatma', 'Bozkurt', '5123458976', 'fatma.bozkurt@hotmail.com'),
(3886, 'Ayşe', 'Gül', '5234589761', 'ayşe.gül@hotmail.com'),
(3887, 'İbrahim', 'Eren', '5345897612', 'ibrahim.eren@hotmail.com'),
(3888, 'Zeynep', 'Yıldırım', '5458976123', 'zeynep.yıldırım@hotmail.com'),
(3889, 'Ali', 'Çalışkan', '5589612345', 'ali.çalışkan@hotmail.com'),
(3890, 'Emine', 'Gültekin', '5689612345', 'emine.gültekin@hotmail.com'),
(3891, 'Mustafa', 'Özkan', '5712345689', 'mustafa.özkan@hotmail.com'),
(3892, 'Sibel', 'Gündüz', '5812345679', 'sibel.gündüz@hotmail.com'),
(3893, 'Osman', 'Doğan', '5123456987', 'osman.doğan@hotmail.com'),
(3894, 'Nuray', 'Güner', '5234569871', 'nuray.güner@hotmail.com'),
(3895, 'Yusuf', 'Öztürk', '5345698712', 'yusuf.öztürk@hotmail.com'),
(3896, 'Hülya', 'Çelik', '5456987123', 'hülya.çelik@hotmail.com'),
(3897, 'Ömer', 'Güneş', '5569871234', 'ömer.güneş@hotmail.com'),
(3898, 'Elif', 'Çakır', '5698712345', 'elif.çakır@hotmail.com'),
(3899, 'Salih', 'Gül', '5798712345', 'salih.gül@hotmail.com'),
(3900, 'Hatice', 'Özdemir', '5898712345', 'hatice.özdemir@hotmail.com'),
(3901, 'Mahmut', 'Yıldız', '5123457986', 'mahmut.yıldız@hotmail.com'),
(3902, 'Esra', 'Çetinkaya', '5234579861', 'esra.çetinkaya@hotmail.com'),
(3903, 'Murat', 'Çelik', '5123456789', 'murat.çelik@hotmail.com'),
(3904, 'Meryem', 'Gümüş', '5234567891', 'meryem.gümüş@hotmail.com'),
(3905, 'Cem', 'Günay', '5345678912', 'cem.günay@hotmail.com'),
(3906, 'Can', 'Çalışkan', '5456789123', 'can.çalışkan@hotmail.com'),
(3907, 'Gül', 'Özkan', '5567891234', 'gül.özkan@hotmail.com'),
(3908, 'Hakan', 'Gül', '5678912345', 'hakan.gül@hotmail.com'),
(3909, 'Serkan', 'Yıldırım', '5789123456', 'serkan.yıldırım@hotmail.com'),
(3910, 'Derya', 'Çakır', '5891234567', 'derya.çakır@hotmail.com'),
(3911, 'Cengiz', 'Güler', '5123456781', 'cengiz.güler@hotmail.com'),
(3912, 'İsmail', 'Güneş', '5234567819', 'ismail.güneş@hotmail.com'),
(3913, 'Kadir', 'Öztürk', '5345678191', 'kadir.öztürk@hotmail.com'),
(3914, 'Nurcan', 'Çetin', '5456781912', 'nurcan.çetin@hotmail.com'),
(3915, 'Aslı', 'Güzel', '5567819123', 'aslı.güzel@hotmail.com'),
(3916, 'Turgay', 'Gültekin', '5678191234', 'turgay.gültekin@hotmail.com'),
(3917, 'Leyla', 'Kaya', '5789191235', 'leyla.kaya@hotmail.com'),
(3918, 'Samet', 'Demir', '5891912345', 'samet.demir@hotmail.com'),
(3919, 'Merve', 'Erdoğan', '5123456879', 'merve.erdoğan@hotmail.com'),
(3920, 'Bülent', 'Köse', '5234568791', 'bülent.köse@hotmail.com'),
(3921, 'Asuman', 'Akar', '5345687912', 'asuman.akar@hotmail.com'),
(3922, 'Özlem', 'Özçelik', '5456879123', 'özlem.özçelik@hotmail.com'),
(3923, 'Ramazan', 'Çelik', '5568791234', 'ramazan.çelik@hotmail.com'),
(3924, 'Gülsüm', 'Gül', '5687912345', 'gülsüm.gül@hotmail.com'),
(3925, 'Özgür', 'Gündüz', '5789123458', 'özgür.gündüz@hotmail.com'),
(3926, 'Ayten', 'Yıldırım', '5891234587', 'ayten.yıldırım@hotmail.com'),
(3927, 'İlkay', 'Çalışkan', '5123456978', 'ilkay.çalışkan@hotmail.com'),
(3928, 'Ferhat', 'Özdemir', '5234569781', 'ferhat.özdemir@hotmail.com'),
(3929, 'Gülşen', 'Güner', '5345697812', 'gülşen.güner@hotmail.com'),
(3930, 'Özcan', 'Güneş', '5456978123', 'özcan.güneş@hotmail.com'),
(3931, 'Cemile', 'Çakır', '5569781234', 'cemile.çakır@hotmail.com'),
(3932, 'Emre', 'Kara', '5697812345', 'emre.kara@hotmail.com'),
(3933, 'Süleyman', 'Gültekin', '5798123456', 'süleyman.gültekin@hotmail.com'),
(3934, 'Gülten', 'Güler', '5898123457', 'gülten.güler@hotmail.com'),
(3935, 'Fatih', 'Öztürk', '5123457689', 'fatih.öztürk@hotmail.com'),
(3936, 'Nihal', 'Yıldız', '5234576891', 'nihal.yıldız@hotmail.com'),
(3937, 'Halil', 'Çetinkaya', '5345768912', 'halil.çetinkaya@hotmail.com'),
(3938, 'Zeynel', 'Çelik', '5457689123', 'zeynel.çelik@hotmail.com'),
(3939, 'Erkan', 'Gümüş', '5568912346', 'erkan.gümüş@hotmail.com'),
(3940, 'Gülşah', 'Günay', '5678912364', 'gülşah.günay@hotmail.com'),
(3941, 'Taner', 'Çalışkan', '5789123456', 'taner.çalışkan@hotmail.com'),
(3942, 'Arzu', 'Özkan', '5891234567', 'arzu.özkan@hotmail.com'),
(3943, 'Sevil', 'Gül', '5123457789', 'sevil.gül@hotmail.com'),
(3944, 'Öznur', 'Yıldırım', '5234577891', 'öznur.yıldırım@hotmail.com'),
(3945, 'Cihan', 'Çakır', '5345778912', 'cihan.çakır@hotmail.com'),
(3946, 'Hakkı', 'Güler', '5457789123', 'hakkı.güler@hotmail.com'),
(3947, 'Yasemin', 'Güneş', '5577891234', 'yasemin.güneş@hotmail.com'),
(3948, 'Mert', 'Öztürk', '5678912345', 'mert.öztürk@hotmail.com'),
(3949, 'Sezen', 'Çetin', '5778912345', 'sezen.çetin@hotmail.com'),
(3950, 'Hilal', 'Öztürk', '5878912345', 'hilal.öztürk@hotmail.com'),
(3951, 'Halime', 'Kaya', '5123458769', 'halime.kaya@hotmail.com'),
(3952, 'Emir', 'Demir', '5234587691', 'emir.demir@hotmail.com'),
(3953, 'Sevilay', 'Yılmaz', '5345876912', 'sevilay.yılmaz@hotmail.com'),
(3954, 'Mustafa Kemal', 'Çetin', '5458769123', 'mustafa kemal.çetin@hotmail.com'),
(3955, 'Gülhan', 'Güler', '5587612345', 'gülhan.güler@hotmail.com'),
(3956, 'Necati', 'Köse', '5687123456', 'necati.köse@hotmail.com'),
(3957, 'Nuran', 'Akar', '5712345689', 'nuran.akar@hotmail.com'),
(3958, 'Erdal', 'Koç', '5812345679', 'erdal.koç@hotmail.com'),
(3959, 'Necdet', 'Gündoğan', '5123459768', 'necdet.gündoğan@hotmail.com'),
(3960, 'Tülay', 'Bayraktar', '5234597681', 'tülay.bayraktar@hotmail.com'),
(3961, 'Meltem', 'Polat', '5345976812', 'meltem.polat@hotmail.com'),
(3962, 'Yılmaz', 'Özdemir', '5459768123', 'yılmaz.özdemir@hotmail.com'),
(3963, 'Rabia', 'Yıldırım', '5559681234', 'rabia.yıldırım@hotmail.com'),
(3964, 'Sadık', 'Güneş', '5659681234', 'sadık.güneş@hotmail.com'),
(3965, 'Deniz', 'Gümüş', '5712345986', 'deniz.gümüş@hotmail.com'),
(3966, 'Gülsün', 'Özkan', '5812345986', 'gülsün.özkan@hotmail.com'),
(3967, 'İlhan', 'Kara', '5123456897', 'ilhan.kara@hotmail.com'),
(3968, 'Gülşahin', 'Günay', '5234568791', 'gülşahin.günay@hotmail.com'),
(3969, 'Serap', 'Çelik', '5345689712', 'serap.çelik@hotmail.com'),
(3970, 'Tuğba', 'Güzel', '5456897123', 'tuğba.güzel@hotmail.com'),
(3971, 'Erdoğan', 'Erdoğan', '5568971234', 'erdoğan.erdoğan@hotmail.com'),
(3972, 'Yıldız', 'Kılıç', '5689712345', 'yıldız.kılıç@hotmail.com'),
(3973, 'Ahmet', 'Güney', '5789123456', 'ahmet.güney@hotmail.com'),
(3974, 'Mehmet', 'Yıldız', '5891234567', 'mehmet.yıldız@hotmail.com'),
(3975, 'Fatma', 'Çetinkaya', '5123457896', 'fatma.çetinkaya@hotmail.com'),
(3976, 'Ayşe', 'Özçelik', '5234578961', 'ayşe.özçelik@hotmail.com'),
(3977, 'İbrahim', 'Bozkurt', '5345789612', 'ibrahim.bozkurt@hotmail.com'),
(3978, 'Zeynep', 'Gül', '5457896123', 'zeynep.gül@hotmail.com'),
(3979, 'Ali', 'Eren', '5567891234', 'ali.eren@hotmail.com'),
(3980, 'Emine', 'Yıldırım', '5678912345', 'emine.yıldırım@hotmail.com'),
(3981, 'Mustafa', 'Çalışkan', '5778912345', 'mustafa.çalışkan@hotmail.com'),
(3982, 'Sibel', 'Gültekin', '5878912345', 'sibel.gültekin@hotmail.com'),
(3983, 'Osman', 'Özkan', '5123458976', 'osman.özkan@hotmail.com'),
(3984, 'Nuray', 'Gündüz', '5234589761', 'nuray.gündüz@hotmail.com'),
(3985, 'Yusuf', 'Doğan', '5345897612', 'yusuf.doğan@hotmail.com'),
(3986, 'Hülya', 'Güner', '5458976123', 'hülya.güner@hotmail.com'),
(3987, 'Ömer', 'Öztürk', '5589612345', 'ömer.öztürk@hotmail.com'),
(3988, 'Elif', 'Çelik', '5689612345', 'elif.çelik@hotmail.com'),
(3989, 'Salih', 'Güneş', '5712345689', 'salih.güneş@hotmail.com'),
(3990, 'Hatice', 'Çakır', '5812345679', 'hatice.çakır@hotmail.com'),
(3991, 'Mahmut', 'Gül', '5123456987', 'mahmut.gül@hotmail.com'),
(3992, 'Esra', 'Özdemir', '5234569871', 'esra.özdemir@hotmail.com'),
(3993, 'Murat', 'Yıldız', '5345698712', 'murat.yıldız@hotmail.com'),
(3994, 'Meryem', 'Çetinkaya', '5456987123', 'meryem.çetinkaya@hotmail.com'),
(3995, 'Cem', 'Çelik', '5569871234', 'cem.çelik@hotmail.com'),
(3996, 'Can', 'Gümüş', '5698712345', 'can.gümüş@hotmail.com'),
(3997, 'Gül', 'Günay', '5798712345', 'gül.günay@hotmail.com'),
(3998, 'Hakan', 'Çalışkan', '5898712345', 'hakan.çalışkan@hotmail.com'),
(3999, 'Serkan', 'Özkan', '5123457986', 'serkan.özkan@hotmail.com');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `personel`
--

DROP TABLE IF EXISTS `personel`;
CREATE TABLE IF NOT EXISTS `personel` (
  `perID` int NOT NULL,
  `perAd` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `perSoyad` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `performansPuani` int NOT NULL,
  `personelMaas` int NOT NULL,
  `perTel` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `perMail` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `subeID` int NOT NULL,
  `gorevID` int NOT NULL,
  PRIMARY KEY (`perID`),
  KEY `gorev_personel` (`gorevID`),
  KEY `sube_personel` (`subeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `personel`
--

INSERT INTO `personel` (`perID`, `perAd`, `perSoyad`, `performansPuani`, `personelMaas`, `perTel`, `perMail`, `subeID`, `gorevID`) VALUES
(10101014, 'Sevgi', 'Pork', 6, 8500, '555554', '', 3500400, 10001),
(10101015, 'Cem', 'Açikgöz', 9, 6700, '555556', '', 3500400, 10002),
(10101016, 'Mustafa Kemal', 'Öztürk', 5, 6070, '555557', 'mail@mail.com', 3500400, 10002),
(10101017, 'Cengiz', 'Yildirim', 4, 5800, '555558', 'mail@mail.com', 3500400, 10003),
(10101020, 'Nihal', 'Çakir', 5, 8500, '555561', 'mail@mail.com', 35001200, 10001),
(10101022, 'Tülay', 'Yildiz', 6, 6070, '555563', 'mail@mail.com', 35001200, 10002),
(10101023, 'Esra', 'Akgün', 2, 5800, '555564', 'mail@mail.com', 35001200, 10003),
(10101024, 'Halime', 'Kiliç', 2, 5500, '555565', 'mail@mail.com', 35001200, 10004),
(10101025, 'Zeynep', 'Gündogan', 7, 5500, '555566', 'mail@mail.com', 35001200, 10005),
(10101028, 'Yilmaz', 'Çelik', 4, 6070, '555569', 'mail@mail.com', 35001300, 10002),
(10101029, 'Meryem', 'Çakir', 3, 5800, '555570', 'mail@mail.com', 35001300, 10003),
(10101030, 'Sevilay', 'Kiziltan', 6, 5500, '555571', 'mail@mail.com', 35001300, 10004),
(10101031, 'Bülent', 'Polat', 5, 5500, '555572', 'mail@mail.com', 35001300, 10005),
(10101032, 'Öznur', 'Demir', 4, 8500, '555573', 'mail@mail.com', 35002100, 10001),
(10101033, 'Nurcan', 'Aras', 7, 6700, '555574', 'mail@mail.com', 35002100, 10002),
(10101034, 'Rabia', 'Gümüs', 6, 6070, '555575', 'mail@mail.com', 35002100, 10002),
(10101037, 'Cengiz', 'Özdemir', 2, 5500, '555578', 'mail@mail.com', 35002100, 10005),
(10101039, 'Ramazan', 'Köse', 5, 6700, '555580', 'mail@mail.com', 35002200, 10002),
(10101040, 'Urcan', 'Öztürk', 10, 6070, '555581', 'mail@mail.com', 35002200, 10002),
(10101041, 'Nurcan', 'Özkan', 6, 5800, '555582', 'mail@mail.com', 35002200, 10003),
(10101042, 'Rabia', 'Özyagci', 2, 5500, '555583', 'mail@mail.com', 35002200, 10004),
(10101043, 'Cem', 'Erdogan', 3, 5500, '555584', 'mail@mail.com', 35002200, 10005),
(10101044, 'Reha', 'Salim', 4, 5501, '555585', 'mail@mail.com', 35002900, 10001),
(10101045, 'Mahmut', 'Muhtar', 5, 5502, '555586', 'mail@mail.com', 35002900, 10002),
(10101046, 'Nadir', 'Kadirov', 6, 5503, '555587', 'mail@mail.com', 35002900, 10002),
(10101047, 'Kerem', 'Cuya', 7, 5504, '555588', 'mail@mail.com', 35002900, 10003),
(10101048, 'Sinan', 'Kalkan', 8, 5505, '555589', 'mail@mail.com', 35002900, 10004),
(10101049, 'Pusat', 'Kılıç', 9, 5506, '555590', 'mail@mail.com', 35002900, 10005),
(10101050, 'Selin', 'Palu', 4, 6070, '555581', 'mail@mail.com', 35002900, 10001),
(10101051, 'Yildizseda', 'ÖZTÜRK', 2, 6070, '555581', 'mail@mail.com', 35002900, 10001);

--
-- Tetikleyiciler `personel`
--
DROP TRIGGER IF EXISTS `kara_liste_ek`;
DELIMITER $$
CREATE TRIGGER `kara_liste_ek` AFTER DELETE ON `personel` FOR EACH ROW INSERT INTO kara_liste (perAd, perSoyad, performansPuani, eklenme_tarihi)
    VALUES (OLD.perAd, OLD.perSoyad, OLD.performansPuani, CURRENT_TIMESTAMP)
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `personel_kayit`;
DELIMITER $$
CREATE TRIGGER `personel_kayit` BEFORE INSERT ON `personel` FOR EACH ROW SET new.perAd=
concat(upper(substring(new.perAd,1,1)),
lower(substring(new.perAd,2)))
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `personel_soyadi_kayit`;
DELIMITER $$
CREATE TRIGGER `personel_soyadi_kayit` BEFORE INSERT ON `personel` FOR EACH ROW SET new.perSoyad=upper(new.perSoyad)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `sirket`
--

DROP TABLE IF EXISTS `sirket`;
CREATE TABLE IF NOT EXISTS `sirket` (
  `sirketID` int NOT NULL,
  `sirketAd` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  PRIMARY KEY (`sirketID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `sirket`
--

INSERT INTO `sirket` (`sirketID`, `sirketAd`) VALUES
(1111, 'OPS Kargo');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `sube`
--

DROP TABLE IF EXISTS `sube`;
CREATE TABLE IF NOT EXISTS `sube` (
  `subeID` int NOT NULL,
  `subeAd` varchar(255) CHARACTER SET utf8 COLLATE utf8_turkish_ci NOT NULL,
  `subeKapasite` int NOT NULL,
  `kira` int NOT NULL,
  `ilceID` int NOT NULL,
  `sirketID` int NOT NULL,
  PRIMARY KEY (`subeID`),
  KEY `sube_ilce` (`ilceID`),
  KEY `sirketgels` (`sirketID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `sube`
--

INSERT INTO `sube` (`subeID`, `subeAd`, `subeKapasite`, `kira`, `ilceID`, `sirketID`) VALUES
(1, 'Deneme', 500, 4124124, 350013, 1111),
(3500400, 'Bayraklı Şubesi', 500, 12000, 350004, 1111),
(35001200, 'Buca Şubesi', 500, 11000, 350008, 1111),
(35001300, 'Buca Adatepe Şubesi', 500, 11000, 350008, 1111),
(35002100, 'Bornova Şubesi', 500, 15000, 350007, 1111),
(35002200, 'Gaziemir Şubesi', 500, 20000, 350013, 1111),
(35002900, 'Karşıyaka Şubesi', 500, 20000, 350017, 1111);

--
-- Tetikleyiciler `sube`
--
DROP TRIGGER IF EXISTS `sube_kayit`;
DELIMITER $$
CREATE TRIGGER `sube_kayit` BEFORE INSERT ON `sube` FOR EACH ROW SET new.subeAd=
concat(upper(substring(new.subeAd,1,1)),
lower(substring(new.subeAd,2)))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `sube_gelir`
--

DROP TABLE IF EXISTS `sube_gelir`;
CREATE TABLE IF NOT EXISTS `sube_gelir` (
  `subeID` int NOT NULL,
  `gelir_ocak` int NOT NULL,
  `gelir_subat` int NOT NULL,
  `gelir_mart` int NOT NULL,
  `gelir_nisan` int NOT NULL,
  `gelir_mayis` int NOT NULL,
  `gelir_haziran` int NOT NULL,
  `gelir_temmuz` int NOT NULL,
  `gelir_agustos` int NOT NULL,
  `gelir_eylul` int NOT NULL,
  `gelir_ekim` int NOT NULL,
  `gelir_kasim` int NOT NULL,
  `gelir_aralik` int NOT NULL,
  `gelir_yillik` int NOT NULL,
  KEY `subeGeliri` (`subeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `sube_gelir`
--

INSERT INTO `sube_gelir` (`subeID`, `gelir_ocak`, `gelir_subat`, `gelir_mart`, `gelir_nisan`, `gelir_mayis`, `gelir_haziran`, `gelir_temmuz`, `gelir_agustos`, `gelir_eylul`, `gelir_ekim`, `gelir_kasim`, `gelir_aralik`, `gelir_yillik`) VALUES
(3500400, 7200, 8329, 8165, 8071, 8269, 9766, 8697, 8514, 7476, 6831, 9176, 9192, 99686),
(35002100, 6214, 7256, 9949, 5835, 7333, 3694, 8183, 8732, 9491, 8260, 7915, 5877, 88739),
(35001200, 4532, 4231, 7879, 6527, 6860, 4142, 5603, 8706, 6549, 8955, 8180, 9086, 81250),
(35001300, 4135, 4792, 7831, 5231, 9214, 3313, 3600, 6946, 7749, 4302, 3245, 6703, 67961),
(35002200, 6860, 3600, 5835, 6831, 9192, 4142, 9949, 6946, 8071, 8165, 7476, 9192, 86259),
(35002900, 7200, 3694, 4231, 7879, 6527, 6860, 6946, 8697, 6831, 9176, 6549, 8180, 82770);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `sube_gider`
--

DROP TABLE IF EXISTS `sube_gider`;
CREATE TABLE IF NOT EXISTS `sube_gider` (
  `subeID` int NOT NULL,
  `gider_ocak` int NOT NULL,
  `gider_subat` int NOT NULL,
  `gider_mart` int NOT NULL,
  `gider_nisan` int NOT NULL,
  `gider_mayis` int NOT NULL,
  `gider_haziran` int NOT NULL,
  `gider_temmuz` int NOT NULL,
  `gider_agustos` int NOT NULL,
  `gider_eylul` int NOT NULL,
  `gider_ekim` int NOT NULL,
  `gider_kasim` int NOT NULL,
  `gider_aralik` int NOT NULL,
  `gider_yillik` int NOT NULL,
  KEY `giderSube` (`subeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `sube_gider`
--

INSERT INTO `sube_gider` (`subeID`, `gider_ocak`, `gider_subat`, `gider_mart`, `gider_nisan`, `gider_mayis`, `gider_haziran`, `gider_temmuz`, `gider_agustos`, `gider_eylul`, `gider_ekim`, `gider_kasim`, `gider_aralik`, `gider_yillik`) VALUES
(3500400, 4380, 4751, 4098, 4562, 4943, 3709, 3816, 4385, 4085, 3829, 4976, 4278, 51812),
(35002100, 4468, 4381, 4753, 3126, 4979, 4993, 3492, 4215, 3352, 4309, 4394, 3386, 49848),
(35001200, 4488, 4712, 2896, 3978, 4747, 3060, 3017, 3736, 4389, 4421, 4199, 3052, 46695),
(35001300, 13047, 13750, 14106, 14463, 13341, 14671, 13275, 14809, 13540, 13306, 13532, 14347, 166187),
(35002200, 4712, 4385, 4380, 4381, 4382, 4383, 4384, 4385, 4386, 4387, 13532, 4421, 62118),
(35002900, 4098, 4976, 4389, 4390, 4391, 4392, 4393, 4394, 4395, 4396, 4397, 4398, 53009);

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `antlasmalar`
--
ALTER TABLE `antlasmalar`
  ADD CONSTRAINT `personel_ant` FOREIGN KEY (`perID`) REFERENCES `personel` (`perID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `arac`
--
ALTER TABLE `arac`
  ADD CONSTRAINT `sube_arac` FOREIGN KEY (`subeID`) REFERENCES `sube` (`subeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `arac_bakim`
--
ALTER TABLE `arac_bakim`
  ADD CONSTRAINT `bakimaracc` FOREIGN KEY (`plaka`) REFERENCES `arac` (`plaka`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `dagitim`
--
ALTER TABLE `dagitim`
  ADD CONSTRAINT `dagitim_sube_sube` FOREIGN KEY (`subeID`) REFERENCES `sube` (`subeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `ilce`
--
ALTER TABLE `ilce`
  ADD CONSTRAINT `ilce_il` FOREIGN KEY (`ilID`) REFERENCES `il` (`ilID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `kargo`
--
ALTER TABLE `kargo`
  ADD CONSTRAINT `kargo_durum` FOREIGN KEY (`durumID`) REFERENCES `durum` (`durumID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `kargo_musteri` FOREIGN KEY (`musID`) REFERENCES `musteri` (`musID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `kargo_sube` FOREIGN KEY (`subeID`) REFERENCES `sube` (`subeID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `kargo_turu` FOREIGN KEY (`kargoTurID`) REFERENCES `kargo_tur` (`kargoTurID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `kargo_dagitim`
--
ALTER TABLE `kargo_dagitim`
  ADD CONSTRAINT `dagitim_kargo` FOREIGN KEY (`plaka`) REFERENCES `arac` (`plaka`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `kargo_dagitim_arac` FOREIGN KEY (`dagitimID`) REFERENCES `dagitim` (`dagitimID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `personel`
--
ALTER TABLE `personel`
  ADD CONSTRAINT `gorev_personel` FOREIGN KEY (`gorevID`) REFERENCES `gorev` (`gorevID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sube_personel` FOREIGN KEY (`subeID`) REFERENCES `sube` (`subeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `sube`
--
ALTER TABLE `sube`
  ADD CONSTRAINT `sirketgels` FOREIGN KEY (`sirketID`) REFERENCES `sirket` (`sirketID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sube_ilce` FOREIGN KEY (`ilceID`) REFERENCES `ilce` (`ilceID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `sube_gelir`
--
ALTER TABLE `sube_gelir`
  ADD CONSTRAINT `subeGeliri` FOREIGN KEY (`subeID`) REFERENCES `sube` (`subeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `sube_gider`
--
ALTER TABLE `sube_gider`
  ADD CONSTRAINT `giderSube` FOREIGN KEY (`subeID`) REFERENCES `sube` (`subeID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
