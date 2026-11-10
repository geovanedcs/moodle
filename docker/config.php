<?php
// Moodle configuration for Coolify. Secrets are supplied as environment variables.
// Never commit real credentials to this file.
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

$CFG->wwwroot = rtrim(getenv('MOODLE_URL') ?: '', '/');
$CFG->dataroot = '/var/moodledata';
$CFG->directorypermissions = 02770;
$CFG->sslproxy = true;

require_once(__DIR__ . '/lib/setup.php');
