<?php

// tablo içini doldurmak için

$db = new mysqli("localhost","root","","kds");
// kira
$musterisorgu = $db->prepare("SELECT arac.aracTipi as cc, MIN(arac.aracHacmi) as dere
FROM arac
GROUP BY arac.aracTipi 
ORDER BY dere ASC LIMIT 1");
$musterisorgu->execute();
$musterisonuc = $musterisorgu->get_result();
$musteri_sayisi = $musterisonuc->fetch_assoc();
$musterisorgu->close();
// musteri
$satissorgu = $db->prepare("SELECT arac.aracTipi as pp, MAX(arac.aracHacmi) as ara
FROM arac
GROUP BY arac.aracTipi 
ORDER BY ara DESC LIMIT 1");
$satissorgu->execute();
$satissonuc = $satissorgu->get_result();
$satis_sayisi = $satissonuc->fetch_assoc();
$satissorgu->close();
// helen kira
$subesorgu = $db->prepare("SELECT SUM(arac_bakim.bakimTutar) as bakim FROM arac_bakim");
$subesorgu->execute();
$subesonuc = $subesorgu->get_result();
$sube_sayisi = $subesonuc->fetch_assoc();
$subesorgu->close();

// giden kira
$bankasorgu = $db->prepare("SELECT arac.aracTipi as aractip, COUNT(arac.plaka) as arac_sayisi
FROM arac
GROUP BY arac.aracTipi 
ORDER BY arac_sayisi DESC LIMIT 1");
$bankasorgu->execute();
$bankasonuc = $bankasorgu->get_result();
$banka_sayisi = $bankasonuc->fetch_assoc();
$bankasorgu->close();

$db->close();


?>



<!DOCTYPE html>
<html lang="tr">
<style>
#personel {
border-collapse: collapse;
width: 100%;
}
 
#personel td, #personel th {
border: 1px solid #ddd;
padding: 8px;
}
 
#personel tr:nth-child(even){background-color: #f2f2f2;}
 
#personel tr:hover {
background-color: #2ecc71;
color:#fff;
}
 
#personel th {
padding-top: 12px;
padding-bottom: 12px;
text-align: left;
background-color: #2c3e50;
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
                        <div class="number"><?php echo $banka_sayisi ["aractip"]?></div>
                        <div class="card-name">En Çok Tercih Edilen Araç Modeli</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-truck"></i>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $satis_sayisi ["pp"]?></div>
                        <div class="card-name">En Büyük Hacme Sahip Araç</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-bus"></i>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $musteri_sayisi ["cc"]?></div>
                        <div class="card-name">En Küçük Hacme Sahip Araç</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-car"></i>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $sube_sayisi ["bakim"]?></div>
                        <div class="card-name">Araç Bakım Gideri</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-lira-sign"></i>
                    </div>
                </div>
            </div>
            <div class="charts">
                <div class="chart">
                <table id="personel" >
            
                        <thead>
                            <tr class="">
                            
                            <th scope="col">Plaka</th>
                            <th scope="col">Araç Tipi</th>
                            <th scope="col">Araç Hacmi</th>
                            <th scope="col">Bakım Masrafı</th>
                            <th scope="col">Şube Adı</th>
                            
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                            <?php
                            $baglanti=mysqli_connect("localhost","root","","kds");
                                $baglanti->set_charset("utf8");
                                $baglanti->query('SET NAMES utf8');

                                $sorgu = $baglanti->query("SELECT arac.plaka as pl, arac.aracTipi as tipi, arac.aracHacmi as hacim,arac_bakim.bakimTutar as masraf,sube.subeAd as arsube
                                FROM arac,sube, arac_bakim
                                WHERE sube.subeID=arac.subeID AND arac_bakim.plaka=arac.plaka
                                GROUP BY arac.plaka
                                ORDER BY arac_bakim.bakimTutar DESC
                                ");  

                            while($sonuc = $sorgu->fetch_assoc()) { 
                            $ad=  $sonuc['pl'];
                            $siparis_sayisi = $sonuc['pl'];
                            echo"<tr>";
                            echo"<td>".$sonuc{"pl"}."</td>";
                            echo"<td>".$sonuc{"tipi"}."</td>";
                            echo"<td>".$sonuc{"hacim"}."</td>";
                            echo"<td>".$sonuc{"masraf"}."</td>";
                            echo"<td>".$sonuc{"arsube"}."</td>";
                            echo"</tr>";
                            }
                            error_reporting (0);
                            
                            ?>

                            
                            </tr>
                        
                            
                        </tbody>
                </table>

                    
                    




                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.5.1/dist/chart.min.js"></script>
    <script src="chart1.js"></script>
    <script src="chart2.js"></script>
</body>

</html>