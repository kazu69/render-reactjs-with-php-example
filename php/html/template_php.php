<?php
require_once dirname(__FILE__) . '/../vendor/autoload.php';

function get_markup($component, $prop) {
  $default_prop = json_encode($prop);
  $v8 = new V8Js();
  $js[] = "var global = global || this, self = self || this, window = window || this;";
  $js[] = file_get_contents('js/bundle.min.js', true);
  $js[] = "print(ReactDomServer.renderToString(React.createElement(${component}, ${default_prop})));";
  $code = implode(";\n", $js);
  ob_start();
  $v8->executeString($code);
  return ob_get_clean();
}

$component = 'Counter';
$prop = ['count' => 3];
$markup = get_markup($component, $prop);
?>

<!doctype html>
<html>
  <head>
    <title>React page</title>
  </head>
  <body>
    <div id="app"><?php echo $markup;?></div>
    <script src="js/bundle.min.js"></script>

    <script>
        document.onreadystatechange = function () {
          if (document.readyState == 'complete') {
            ReactDom.render(
              React.createElement(Counter, {count: 3}),
              document.getElementById('app')
            );
          }
        }
    </script>
  </body>
</html>
