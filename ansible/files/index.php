<?php

$connection = new MongoClient( "mongodb://localhost:27017" );

$collection = $connection->selectCollection('TwitterStream', 'twitterMessagesDocker');
if (!$collection) {
        echo 'not connected to collection';
        exit;
}
$cursor = $collection->find();
foreach ($cursor as $doc) {
    var_dump($doc);
}