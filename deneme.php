
<!DOCTYPE html>
<html lang="tr">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    
    <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous" />
    <link rel="stylesheet" href="styles.css">
    <title>Admin panel</title>
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
            
                <div class="chart" >
                    <div class="content-wrapper">
<div id="calisanlar">
<form method="POST" action="sube_ekle_vt.php">
<table border="3"  style="margin:100px;" >
<style>
  table {
    border-collapse: collapse;
    width: 60%;
    margin: 0 auto;
    transition: all 0.5s ease;
  }
  th, td {
    text-align: left;
    padding: 8px;
  }
  tr:nth-child(even) {
    background-color: #f2f2f2;
  }
  th {
    background-color: #4caf50;
    color: white;
  }
  input[type="text"] {
    width: 100%;
    border: 2px solid #ccc;
    border-radius: 4px;
    font-size: 16px;
    padding: 12px 20px;
    box-sizing: border-box;
    margin-top: 6px;
    margin-bottom: 16px;
  }
  input[type="submit"] {
    background-color: #4caf50;
    color: white;
    padding: 12px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    float: right;
  }
  input[type="submit"]:hover {
    background-color: #45a049;
  }
  /* aşağıdaki satırlar eklenmiştir */
  .expand {
    width: 80%;
  }
  .shrink {
    width: 60%;
  }

 .popup {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-40%, -45%);
    background-color: #f1f1f1;
    border: 2px solid #ccc;
    border-radius: 4px;
    width: 80%;
    max-height: 80%;
    overflow-y: auto;
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
  }
</style>
<table id="formTable" class="shrink popup"> <!-- burada, tablo elementine bir ID eklenmiştir -->
  <tr>
    <th colspan="2">Şube Ekleme Formu</th>
  </tr>
  <tr>
    <td>ŞUBE ID</td>
    <td><input type="text" name="subeID"></td>
  </tr>
  <tr>
    <td>ŞUBE ADI</td>
    <td><input type="text" name="subeAd"></td>
  </tr>
  <tr>
    <td>ŞUBE KAPASİTE</td>
    <td><input type="text" name="subeKapasite"></td>
  </tr>
  <tr>
    <td>ŞUBE KİRA</td>
    <td><input type="text" name="kira"></td>
  </tr>
  <tr>
    <td>ŞUBE İLÇE</td>
    <td><input type="text" name="ilceID"></td>
  </tr>
  <tr>
    <td>ŞUBE ŞİRKET</td>
    <td><input type="text" name="sirketID"></td>
  </tr>
  <tr>
    <td></td>
    <td><input type="submit" value="Kaydet"></td>
  </tr>
</table>

</form>
<script>
  var formTable = document.getElementById("formTable");
  var currentWidth = formTable.offsetWidth;
  formTable.onclick = function() {
    if (formTable.classList.contains("shrink")) {
      formTable.classList.remove("shrink");
      formTable.classList.add("expand");
    } else {
      formTable.classList.remove("expand");
      formTable.classList.add("shrink");
    }
  }
</script>
</div>
</body>

                    







                </div>
                
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.5.1/dist/chart.min.js"></script>
    <script src="chart1.js"></script>
    <script src="chart2.js"></script>
</body>

</html>