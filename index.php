<?php
 
$dataPoints1 = array();
//Best practice is to create a separate file for handling connection to database
try{
     // Creating a new connection.
    // Replace your-hostname, your-db, your-username, your-password according to your database
    $link =   $link= new \PDO(   'mysql:host=localhost;dbname=kds;charset=utf8mb4',
    'root', //'root',
    '', //'',
    array(
        \PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        \PDO::ATTR_PERSISTENT => false
    )
);
	
    $handle = $link->prepare('SELECT sube.subeAd as x, sube_gider.gider_yillik as y FROM sube,sube_gider WHERE sube.subeID=sube_gider.subeID GROUP BY sube.subeID'); 
    $handle->execute(); 
    $result = $handle->fetchAll(\PDO::FETCH_OBJ);
    
    foreach($result as $row){
        array_push($dataPoints1, array("y"=> $row->y, "label"=> $row->x));
    }
	$link = null;
}
catch(\PDOException $ex){
    print($ex->getMessage());
}


$dataPoints2 = array();
//Best practice is to create a separate file for handling connection to database
try{
     // Creating a new connection.
    // Replace your-hostname, your-db, your-username, your-password according to your database
    $link =   $link= new \PDO(   'mysql:host=localhost;dbname=kds;charset=utf8mb4',
    'root', //'root',
    '', //'',
    array(
        \PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        \PDO::ATTR_PERSISTENT => false
    )
);
	
    $handle = $link->prepare('SELECT sube.subeAd as x, sube_gelir.gelir_yillik as y FROM sube,sube_gelir WHERE sube.subeID=sube_gelir.subeID GROUP BY sube.subeID'); 
    $handle->execute(); 
    $result = $handle->fetchAll(\PDO::FETCH_OBJ);
		
    foreach($result as $row){
        array_push($dataPoints2, array("y"=> $row->y, "label"=> $row->x));
    }
	$link = null;
}
catch(\PDOException $ex){
    print($ex->getMessage());
}

$dataPoints3 = array();
//Best practice is to create a separate file for handling connection to database
try{
     // Creating a new connection.
    // Replace your-hostname, your-db, your-username, your-password according to your database
    $link =   $link= new \PDO(   'mysql:host=localhost;dbname=kds;charset=utf8mb4', //'mysql:host=localhost;dbname=canvasjs_db;charset=utf8mb4',
    'root', //'root',
    '', //'',
    array(
        \PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        \PDO::ATTR_PERSISTENT => false
    )
);
	
$handle = $link->prepare('SELECT sube.subeAd AS x, ROUND(((sube_gelir.gelir_yillik - sube_gider.gider_yillik) / sube_gelir.gelir_yillik) * 100, 2) AS y
FROM sube, sube_gider, sube_gelir
WHERE sube.subeID = sube_gider.subeID AND sube.subeID = sube_gelir.subeID
GROUP BY sube.subeID
'); 
    $handle->execute(); 
    $result = $handle->fetchAll(\PDO::FETCH_OBJ);
		
    foreach($result as $row){
        array_push($dataPoints3, array("y"=> $row->y, "label"=> $row->x));
    }
	$link = null;
}
catch(\PDOException $ex){
    print($ex->getMessage());
}



// tablo içini doldurmak için

$db = new mysqli("localhost","root","","kds");
// musteri
$musterisorgu = $db->prepare("SELECT COUNT(sube.subeID)  s_id FROM sube");
$musterisorgu->execute();
$musterisonuc = $musterisorgu->get_result();
$musteri_sayisi = $musterisonuc->fetch_assoc();
$musterisorgu->close();
// peronel
$satissorgu = $db->prepare("SELECT COUNT(personel.perID) p_id FROM personel");
$satissorgu->execute();
$satissonuc = $satissorgu->get_result();
$satis_sayisi = $satissonuc->fetch_assoc();
$satissorgu->close();
// kar toplam
$subesorgu = $db->prepare("SELECT (SUM(sube_gelir.gelir_yillik))-(SUM(sube_gider.gider_yillik)) kar FROM sube_gelir,sube_gider");
$subesorgu->execute();
$subesonuc = $subesorgu->get_result();
$sube_sayisi = $subesonuc->fetch_assoc();
$subesorgu->close();

// araba
$bankasorgu = $db->prepare("SELECT COUNT(arac.plaka) a_id FROM arac");
$bankasorgu->execute();
$bankasonuc = $bankasorgu->get_result();
$banka_sayisi = $bankasonuc->fetch_assoc();
$bankasorgu->close();

$db->close();





// $db = new mysqli("localhost","root","","kds");





// $aracsorgu = $db->prepare("SELECT COUNT(arac.plaka) FROM arac");
// $aracsorgu->execute();
// $aracsonuc = $aracsorgu->get_result();
// $arac_sayisi = $aracsonuc->fetch_assoc();
// $aracsorgu->close();

// $karsorgu = $db->prepare("SELECT (SUM(sube_gelir.gelir_yillik))-(SUM(sube_gider.gider_yillik)) AS durum FROM sube_gelir,sube_gider");
// $karsorgu->execute();
// $karsonuc = $karsorgu->get_result();
// $kar_sayisi = $karsonuc->fetch_assoc();
// $karsorgu->close();

// $db->close();





?>
<!DOCTYPE html>
<html lang="tr">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous" />
    <link rel="stylesheet" href="styles.css">
    <title>OPS Kargo</title>
    <!-- grafik kodları -->
    <script>
        window.onload = function() {

      var chart1 = new CanvasJS.Chart("chartContainer1", {
	animationEnabled: true,
	title: {
		text: "Şubelere Göre Yıllık Net Kar Oranları"
	},
	data: [{
		type: "pie",
		startAngle: 240,
		yValueFormatString: "",
		indexLabel: "{label} {y}",
		dataPoints: <?php echo json_encode($dataPoints3, JSON_NUMERIC_CHECK); ?>
	}]
});
chart1.render();
    

       
        var chart2 = new CanvasJS.Chart("chartContainer2", {
        animationEnabled: true,
        theme: "light2",
        title:{
            text: "Şubelere Göre Gelir Gider Dağılımı"
        },
        axisX:{
            valueFormatString: "DD MMM",
            crosshair: {
                enabled: true,
                snapToDataPoint: true
            }
        },
        axisY: {
            title: "Lira (₺)",
            includeZero: true,
            crosshair: {
                enabled: true
            }
        },
        toolTip:{
            shared:true
        },  
        legend:{
            cursor:"pointer",
            verticalAlign: "bottom",
            horizontalAlign: "left",
            dockInsidePlotArea: true,
            itemclick: toogleDataSeries
        },
        data: [{
            type: "line",
            showInLegend: true,
            name: "Gider",
            markerType: "square",
            xValueFormatString: "DD MMM, YYYY",
            color: "#F08080",
            dataPoints:  <?php echo json_encode($dataPoints1, JSON_NUMERIC_CHECK); ?>
        },
        {
            type: "line",
            showInLegend: true,
            name: "Gelir",
            lineDashType: "dash",
            dataPoints: <?php echo json_encode($dataPoints2, JSON_NUMERIC_CHECK); ?>
        }]
    });
    chart2.render();

    function toogleDataSeries(e){
        if (typeof(e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
            e.dataSeries.visible = false;
        } else{
            e.dataSeries.visible = true;
        }
        chart2.render();
    }
                
            
            
            
        
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
                <li class="log_out">
          <a href="logout.php">
            <i class='bx bx-log-out'></i>
            <span class="links_name">Çıkış</span>
          </a>
        </li>
            </ul>
        </div>
        <div class="main">
            <div class="cards">
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $musteri_sayisi["s_id"]; ?></div>
                        <div class="card-name">Şube Sayısı</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-home"></i>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $satis_sayisi["p_id"]; ?></div>
                        <div class="card-name">Personel Sayısı</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $banka_sayisi["a_id"]; ?></div>
                        <div class="card-name">Araç Sayısı</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-truck"></i>
                    </div>
                </div>
                <div class="card">
                    <div class="card-content">
                        <div class="number"><?php echo $sube_sayisi["kar"]; ?></div>
                        <div class="card-name">Toplam Gelir</div>
                    </div>
                    <div class="icon-box">
                        <i class="fas fa-lira-sign"></i>
                    </div>
                </div>
            </div>
            <div class="charts">
                <div class="chart"> 
                   
                    <div class="m-1" id="chartContainer2" style="height:400px; width: 100%;"></div>
                </div>



                <div class="chart doughnut-chart">
                    
                    <div>
                        <div class="m-1" id="chartContainer1" style="height:400px; width: 100%;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.5.1/dist/chart.min.js"></script>
    <script src="chart1.js"></script>
    <script src="chart2.js"></script>
</body>

</html>