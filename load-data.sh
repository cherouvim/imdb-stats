#!/bin/bash

DB_USER=root
DB_PASS=pass
DB_NAME=test_imdb
DB_HOST=127.0.0.1
DB_PORT=3306

pushd /tmp/
wget https://datasets.imdbws.com/title.basics.tsv.gz
wget https://datasets.imdbws.com/title.ratings.tsv.gz
gunzip title.basics.tsv.gz
gunzip title.ratings.tsv.gz

DB_LOAD='
drop database if exists '"${DB_NAME}"';
create database '"${DB_NAME}"';
use '"${DB_NAME}"';
drop table if exists title_ratings;
create table title_ratings (tconst char(10) not null, averageRating decimal(3,1) unsigned not null, numVotes int(11) unsigned not null, primary key (tconst));
load data local infile "/tmp/title.ratings.tsv" into table title_ratings character set utf8 ignore 1 rows;
drop table if exists title_basics;
create table title_basics (tconst char(10) not null, titleType char(16) not null, primaryTitle varchar(255) not null, originalTitle varchar(255) not null, isAdult tinyint unsigned not null, startYear smallint unsigned, endYear smallint unsigned, runtimeMinutes smallint unsigned, genres varchar(512), primary key (tconst), key titleType (titleType));
load data local infile "/tmp/title.basics.tsv" into table title_basics character set utf8 ignore 1 rows;
'

echo ${DB_LOAD} | mysql -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST} -P ${DB_PORT}

rm /tmp/title.basics.tsv
rm /tmp/title.ratings.tsv
popd
