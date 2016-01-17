#!/bin/bash
MDB="$1"
MUSER="$2"
MPASS="$3"
MHOST="$4"
MPORT="$5"

# Detect paths
MYSQL=$(which mysql)
AWK=$(which awk)
GREP=$(which grep)

echo $MUSER
echo $MPASS
echo $MDB

if [ $# -ne 5 ]
then
	echo "Usage: $0 {MySQL-User-Name} {MySQL-User-Password} {MySQL-Database-Name} {MySQL-Database-Host} {MySQL-Database-Host}"
	echo "Drops all tables from a MySQL"
	exit 1
fi

TABLES=$($MYSQL -u$MUSER -p$MPASS -h$MHOST -P$MPORT $MDB -e 'show tables' | $AWK '{ print $1}' | $GREP -v '^Tables' )

for t in $TABLES
do
	echo "Deleting $t table from $MDB database..."
	$MYSQL -u$MUSER -p$MPASS -h$MHOST -P$MPORT $MDB -e "drop table $t"
done