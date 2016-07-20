<html>
<head>
  <title>Humble Stats</title>
  <meta http-equiv="refresh" content="300; URL=.">
  <style>
    .stats {
      text-align: center;
    }
  </style>
</head>
<body>
<?php
  $files = array();
  $dir = new DirectoryIterator(dirname(__FILE__));
  foreach ($dir as $fileinfo) {
    if (!$fileinfo->isDot() && strrpos($fileinfo->getFilename(), ".png", -4)) {
      $files[$fileinfo->getMTime()][] = $fileinfo->getFilename();
    }
  }
  krsort($files);
  $files = call_user_func_array('array_merge', $files);
  foreach ($files as $filename) {
?>
    <div class="stats">
      <img src="<?php echo $filename ?>" />
    </div>
<?php
  }
?>
</body>
</html>
