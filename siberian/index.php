<?php
#die("In maintenance down");
try {
if(!empty($_SERVER["HTTP_HOST"]) AND $_SERVER["HTTP_HOST"] == "fcdinamo.edisca.com") {
    die();
}
error_reporting(0);
set_time_limit(540);
ini_set('max_execution_time', 540);
umask(0);

// Define path to application directory
setlocale(LC_MONETARY, 'fr_FR');

defined('BASE_PATH')
    || define('BASE_PATH', realpath(dirname(__FILE__)));

defined('APPLICATION_PATH')
    || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/app'));

$t = "production";
if (isset($_GET['dev'])) {
#    $t = "development";
}
// Define application environment
defined('APPLICATION_ENV')
    || define('APPLICATION_ENV', (getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : $t));

defined('CONNECTED_TO_THE_NEW_TIGER')
    || define('CONNECTED_TO_THE_NEW_TIGER', true);

// Ensure lib/ is on include_path
set_include_path(implode(PATH_SEPARATOR, array(
    get_include_path(),
    realpath(APPLICATION_PATH . '/modules'),
    realpath(APPLICATION_PATH . '/../lib'),
)));

/** Zend_Application */
require_once 'Zend/Application.php';

// Create application
$application = new Zend_Application(
    APPLICATION_ENV,
    APPLICATION_PATH . '/configs/app.ini'
);

if (isset($_GET['dev'])) {
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
}

// Run
$application->bootstrap()->run();
} catch(Exception $e) {
if (isset($_GET['dev'])) {
    echo $e->getMessage();
}
}
