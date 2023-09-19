<?php

$db = mysqli_connect('localhost', 'root', '', 'kds');
if (isset($_POST)) {
  // Formdan gönderilen verinin alınması
  $id = $_POST['perID'];

  // Butona basıldığında yapılacak işlemler
  $sql = "DELETE FROM personel WHERE perID=$id";
  // Sorguyu çalıştır
  $result = mysqli_query($db, $sql);
  if ($result) {
    // Veri silme işlemi başarılı
    // echo header('location:personelAnaliz.php');
    return 1;
  } else {
    // Veri silme işlemi başarısız
    // echo "Veri silme işlemi başarısız. Hata: " . mysqli_error($db);
    return 2;
  }
}
