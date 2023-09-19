<?php

// tablo içini doldurmak için

$db = new mysqli("localhost", "root", "", "kds");
// kira
$musterisorgu = $db->prepare("SELECT SUM(sube.kira) kira FROM sube");
$musterisorgu->execute();
$musterisonuc = $musterisorgu->get_result();
$musteri_sayisi = $musterisonuc->fetch_assoc();
$musterisorgu->close();
// musteri
$satissorgu = $db->prepare(" SELECT COUNT(musteri.musID) m_id FROM musteri");
$satissorgu->execute();
$satissonuc = $satissorgu->get_result();
$satis_sayisi = $satissonuc->fetch_assoc();
$satissorgu->close();
// helen kira
$subesorgu = $db->prepare("SELECT COUNT(kargo.kargoTurID) gelen FROM kargo
WHERE kargo.kargoTurID LIKE 353531");
$subesorgu->execute();
$subesonuc = $subesorgu->get_result();
$sube_sayisi = $subesonuc->fetch_assoc();
$subesorgu->close();

// giden kira
$bankasorgu = $db->prepare("SELECT COUNT(kargo.kargoTurID) giden FROM kargo
WHERE kargo.kargoTurID LIKE 353535");
$bankasorgu->execute();
$bankasonuc = $bankasorgu->get_result();
$banka_sayisi = $bankasonuc->fetch_assoc();
$bankasorgu->close();

// $db->close();

$subelerSorgu = $db->query("SELECT sube.subeID, sube.subeAd as subeAdi FROM sube");
$subeler = array();
while ($sonuc = $subelerSorgu->fetch_assoc()) {
  $subeler[] = $sonuc;
}

?>


<!DOCTYPE html>
<html lang="tr">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width,initial-scale=1">

  <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous" />
  <link rel="stylesheet" href="styles.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
  <title>Admin panel</title>
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
  </style>
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
            <div class="number"><?php echo $musteri_sayisi["kira"]; ?></div>
            <div class="card-name">Toplam Kira</div>
          </div>
          <div class="icon-box">
            <i class="fas fa-lira-sign"></i>
          </div>
        </div>
        <div class="card">
          <div class="card-content">
            <div class="number"><?php echo $satis_sayisi["m_id"]; ?></div>
            <div class="card-name">Toplam Müşteri</div>
          </div>
          <div class="icon-box">
            <i class="fas fa-users"></i>
          </div>
        </div>
        <div class="card">
          <div class="card-content">
            <div class="number"><?php echo $sube_sayisi["gelen"]; ?></div>
            <div class="card-name">Gelen Kargo</div>
          </div>
          <div class="icon-box">
            <i class="fas fa-truck"></i>
          </div>
        </div>
        <div class="card">
          <div class="card-content">
            <div class="number"><?php echo $banka_sayisi["giden"]; ?></div>
            <div class="card-name">Giden Kargo </div>
          </div>
          <div class="icon-box">
            <i class="fas fa-truck"></i>
          </div>
        </div>
      </div>
      <div class="charts">
        <div class="chart">
          <select name="subeler" id="subeler">
            <option value="0">Lütfen Şube Seçiniz</option>
            <?php foreach ($subeler as $key => $value) { ?>
              <option value="<?php echo $value['subeID'] ?>"><?php echo $value["subeAdi"] ?></option>
            <?php } ?>
          </select>

          <button onclick="grafikGetir()">Bilgileri Getir</button>
        </div>

      </div>

      <div class="charts" id="divGrafikler">
        <div class="chart">
          <div class="cards">
            <div class="card">
              <div class="card-content">
                <div class="card-content" id="subeAd"></div>
                <div id="performansPuani"></div>
                <div id="personel"></div>
                <div id="kira"></div>
                <div id="kapasite"></div>
                <div id="kar_zarar_durumu"></div>
                
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    function grafikGetir() {
      let selectSubeler = document.getElementById("subeler");
      let selectedId = selectSubeler.value;

      let elementSubeAd = document.getElementById("subeAd");
      let elementPerformansPuani = document.getElementById("performansPuani");
      let elementPersonelSayisi = document.getElementById("personel");
      let elementKira = document.getElementById("kira");
      let elementKapasite = document.getElementById("kapasite");
      let elementKarZarar = document.getElementById("kar_zarar_durumu");
      if (selectedId === "0") {
        alert("Lütfen Şube seçiniz");
      } else {
        $.ajax({
          type: "POST",
          url: "./subeBilgiGetir.php",

          data: {
            subeId: selectedId
          },
          success: function(response) {
            let data = JSON.parse(response);
            elementSubeAd.innerHTML = "<strong>Şube Adı:</strong> " + data.subeAd;
            elementPerformansPuani.innerHTML = "<strong>Şube Puanı:</strong> " + data.performansPuani;
            elementPersonelSayisi.innerHTML = "<strong>Personel Sayısı:</strong> " + data.personel;
            elementKira.innerHTML = "<strong>Kira:</strong> " + data.kira;
            elementKapasite.innerHTML = "<strong>Depo Kapasitesi:</strong> " + data.kapasite + " m³";
            elementKarZarar.innerHTML = "<strong>Kar Zarar Durumu:</strong> " + data.kar_zarar_durumu;

          }
        });
        grafikGoster();

      }
    }

    function runOnLoad() {
      resetSelect();
      grafikGizle();
    }

    function resetSelect() {
      let selectSubeler = document.getElementById("subeler");
      selectSubeler.value = 0;
    }

    function grafikGoster() {
      let divGrafik = document.getElementById("divGrafikler");
      divGrafik.style.display = "block";
    }

    function grafikGizle() {
      let divGrafik = document.getElementById("divGrafikler");
      divGrafik.style.display = "none";
    }


    window.onload = runOnLoad();
  </script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@3.5.1/dist/chart.min.js"></script>
  <script src="chart1.js"></script>
  <script src="chart2.js"></script>
</body>

</html>