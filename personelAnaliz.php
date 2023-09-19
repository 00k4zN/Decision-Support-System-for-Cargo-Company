<?php

// tablo içini doldurmak için

$db = new mysqli("localhost", "root", "", "kds");
// kira
$musterisorgu = $db->prepare("SELECT SUM(personel.personelMaas) p_maas FROM personel");
$musterisorgu->execute();
$musterisonuc = $musterisorgu->get_result();
$musteri_sayisi = $musterisonuc->fetch_assoc();
$musterisorgu->close();
// musteri
$satissorgu = $db->prepare(" SELECT round(AVG(personel.performansPuani),1) puan FROM personel");
$satissorgu->execute();
$satissonuc = $satissorgu->get_result();
$satis_sayisi = $satissonuc->fetch_assoc();
$satissorgu->close();
// helen kira
$subesorgu = $db->prepare("SELECT COUNT(antlasmalar.antlasmaID) sayi FROM antlasmalar");
$subesorgu->execute();
$subesonuc = $subesorgu->get_result();
$sube_sayisi = $subesonuc->fetch_assoc();
$subesorgu->close();

// giden kira
$bankasorgu = $db->prepare("SELECT CONCAT(personel.perAd,' ',personel.perSoyad) as pid, COUNT(antlasmalar.antlasmaID) as agreement_count
FROM antlasmalar
JOIN personel ON antlasmalar.perID = personel.perID
GROUP BY personel.perID
ORDER BY agreement_count DESC LIMIT 1;");
$bankasorgu->execute();
$bankasonuc = $bankasorgu->get_result();
$banka_sayisi = $bankasonuc->fetch_assoc();
$bankasorgu->close();

$klsorgu = $db->prepare("SELECT CONCAT(kara_liste.perAd,' ',kara_liste.perSoyad) as kl, kara_liste.performansPuani as klp FROM kara_liste");
$klsorgu->execute();
$klsonuc = $klsorgu->get_result();
$kl_sayisi = $klsonuc->fetch_assoc();
$klsorgu->close();
?>


<?php

$baglanti = mysqli_connect("localhost", "root", "", "kds");
$baglanti->set_charset("utf8");
$baglanti->query('SET NAMES utf8');

$sorgu = $baglanti->query("SELECT personel.perID as perID, concat(personel.perAd,' ',personel.perSoyad) as ad, gorev.gorevAd as gorevv, sube.subeAd as s_ad, personel.performansPuani as puan
    FROM sube,personel,gorev
    WHERE sube.subeID=personel.subeID AND gorev.gorevID=personel.gorevID
    GROUP BY personel.perID
    ORDER BY personel.performansPuani ASC
    ");

$datas = array();
while ($sonuc = $sorgu->fetch_assoc()) {
    $datas[] = $sonuc;
}
error_reporting(0);

$karaListeSorgu = $baglanti->query("SELECT concat(kara_liste.perAd,' ',kara_liste.perSoyad) as adsoyad, kara_liste.performansPuani as perfpuan, kara_liste.eklenme_tarihi as tarih FROM `kara_liste` ORDER BY kara_liste.eklenme_tarihi DESC");
$karaListeData = array();
while($sonuc = $karaListeSorgu->fetch_assoc()){
    $karaListeData[] = $sonuc;
}

?>


</tr>

<!DOCTYPE html>
<html lang="tr">
<style>
    #personel {
        border-collapse: collapse;
        width: 100%;

    }

    #personel td,
    #personel th {
        border: 1px solid #ddd;
        padding: 8px;
    }

    #personel tr:nth-child(even) {
        background-color: #f2f2f2;
    }

    #personel tr:hover {
        background-color: #2ecc71;
        color: #fff;
    }

    #personel th {
        padding-top: 12px;
        padding-bottom: 12px;
        text-align: left;
        background-color: #2c3e50;
        color: white;
    }

    #btnDanger {
        background-color: red;
        color: white;
    }
</style>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous" />
    <link rel="stylesheet" href="styles.css">
    <title>Admin panel</title>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
    <script>
        function personelSil(personelId) {
            $.ajax({
                type: "POST",
                url: "./verisil.php",
                data: {perID: personelId},
                success: function(){
                    location.reload();
                }
            });
        }
    </script>
</head>

<body>
    <div class="container">
        <div class="topbar">
            <div class="logo">
                <h2>OPS Kargo</h2>
            </div>
        </div>
        <div class="sidebar">
            <ul>
                <li>
                    <a href="index.php">
                        <i class="fas fa-th-large"></i>
                        <div>Yönetici Paneli</div>
                    </a>
                </li>
                <li>
                    <a href="subeler.php">
                        <i class="fas fa-home"></i>
                        <div>Şubeler</div>
                    </a>
                </li>
                <li>
                    <a href="personelAnaliz.php">
                        <i class="fas fa-users"></i>
                        <div>Personel</div>
                    </a>
                </li>
                <li>
                    <a href="aracAnaliz.php">
                        <i class="fas fa-truck"></i>
                        <div>Araç</div>
                    </a>
                </li>
                <li>
                    <a href="deneme.php">
                        <i class="fas fa-plus"></i>
                        <div>Ekle</div>
                    </a>
                </li>
            </ul>
        </div>
        <div class="main">
            <div class="cards">
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $musteri_sayisi["p_maas"]; ?></div>
                        <div class="card-name">Toplam Personel Maaşları</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-lira-sign"></i>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $satis_sayisi["puan"]; ?></div>
                        <div class="card-name">Ortalama Personel Puanı</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-user"></i>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $sube_sayisi["sayi"]; ?></div>
                        <div class="card-name">Anlaşma Sayısı</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-pen"></i>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $banka_sayisi["pid"]; ?></div>
                        <div class="card-name">En Çok Anlaşma Yapan Müdür</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-star"></i>
                    </div>
                </div>
            </div>
            <div class="charts">
                <!-- <form action="verisil.php" method="post"> -->

                <table id="personel">

                    <thead>
                        <tr class="">
                            <th scope="col">Personel id</th>
                            <th scope="col">Ad Soyad</th>
                            <th scope="col">Görev</th>
                            <th scope="col">Şube Adı</th>
                            <th scope="col">performans Puanı</th>
                            <th scope="col">Takibe Al</th>

                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($datas as $key => $value) { ?>

                            <tr>
                                <td><?php echo $value["perID"] ?></td>
                                <td><?php echo $value["ad"] ?></td>
                                <td><?php echo $value["gorevv"] ?></td>
                                <td><?php echo $value["s_ad"] ?></td>
                                <td><?php echo $value["puan"] ?></td>
                                <td><button class="btnDanger" id="btnPersonelSil" onclick="personelSil(<?php echo $value['perID'] ?>)">Takibe Al</button></td>
                            </tr>
                        <?php } ?>

                    </tbody>

                </table>



                <!-- </form> -->





                <div class="chart doughnut-chart">
                    <h2>Takip Listesi</h2>
                    <div>
                        <table id="personel">

                            <thead>
                                <tr class="">
                                    <th scope="col">Ad Soyad</th>
                                    <th scope="col">Performans Puanı</th>
                                    <th scope="col">Eklenme Zamanı</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($karaListeData as $key => $value) { ?>
                                    <tr>
                                        <td><?php echo $value["adsoyad"] ?></td>
                                        <td><?php echo $value["perfpuan"] ?></td>
                                        <td><?php echo $value["tarih"] ?></td>
                                    </tr>
                                <?php } ?>

                            </tbody>

                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.5.1/dist/chart.min.js"></script>
    <script src="chart1.js"></script>
    <script src="chart2.js"></script>

</body>

</html>