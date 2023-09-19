<?php 
$db = mysqli_connect('localhost', 'root', '', 'kds');
if (isset($_POST)) {
    $subeId = $_POST["subeId"];
    
    $subeBilgi;
    $subeBilgiSorgu = $db->query("call sube_bilgisi($subeId)");
    $subeBilgi = $subeBilgiSorgu->fetch_object();
    echo json_encode($subeBilgi);

}
?>