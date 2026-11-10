<?php
// Moodle 4.0.12 / Coolify: environment-based config, no secrets in Git.
unset($CFG);
global $CFG;
$CFG = new stdClass();
$CFG->dbtype = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost = getenv('DB_HOST') ?: 'db';
$CFG->dbname = getenv('DB_NAME') ?: 'moodle';
$CFG->dbuser = getenv('DB_USER') ?: 'moodle';
$CFG->dbpass = getenv('DB_PASSWORD');
$CFG->prefix = 'mdl_';
$CFG->dboptions = [
    'dbpersist' => false,
    'dbport' => 3306,
    'dbsocket' => false,
    'dbcollation' => 'utf8mb4_unicode_ci',
];
$CFG->wwwroot = rtrim((string) (getenv('MOODLE_URL') ?: ''), '/');
$CFG->dataroot = '/var/moodledata';
$CFG->directorypermissions = 02770;
$CFG->admin = 'admin';
$CFG->sslproxy = (strpos($CFG->wwwroot, 'https://') === 0);
require_once(__DIR__ . '/lib/setup.php');
