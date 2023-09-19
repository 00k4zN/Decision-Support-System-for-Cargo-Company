<?php
error_reporting(0);
 $subeID = $_POST['subeID'];
 $subeAd = $_POST['subeAd'];
 $subeKapasite = $_POST['subeKapasite'];
 $kira = $_POST['kira'];
 $ilceID = $_POST['ilceID'];
 $sirketID = $_POST['sirketID'];
 
$baglan=mysqli_connect("localhost","root","","kds"); 
mysqli_set_charset($baglan, "utf8");
 
$sqlekle="INSERT INTO sube( subeID, subeAd, subeKapasite, kira,ilceID,sirketID) 
VALUES ('$subeID','$subeAd','$subeKapasite','$kira','$ilceID','$sirketID')";
 
$sonuc=mysqli_query($baglan,$sqlekle);
 
if ($sonuc==0)
echo "Eklenemedi, kontrol ediniz";
else
header("Location: http://localhost/kargo/deneme.php");

 
?>

