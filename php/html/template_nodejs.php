<?php
$address = 'nodejs';
$ip = gethostbyname($address);
$port = '3000';
$compoent = 'counter';
$url = "http://${ip}:${port}/?component=${compoent}";

$context = stream_context_create(
    array(
        'http' => array(
            'method'=> 'POST',
            'header'=> 'Content-type: application/json; charset=UTF-8',
            'content' => json_encode(
                array(
                    'count' => 4
                )
            )
        )
    )
);

$output = file_get_contents($url, false, $context);
?>
<!doctype html>
<html>
  <head>
    <title>React page</title>
  </head>
  <body>

    <div id="app"><?php echo $output; ?></div>

    <script src="js/bundle.min.js"></script>
    <script>
        document.onreadystatechange = function () {
          if (document.readyState == 'complete') {
            ReactDom.render(
              React.createElement(Counter, {count: 4}),
              document.getElementById('app')
            );
          }
        }
    </script>
  </body>
</html>
