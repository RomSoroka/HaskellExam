# Lab1
###Run:
1. Install "mysql-haskell" from https://hackage.haskell.org/package/mysql-haskell
2. Setup db:
```
	$mysql -u root -p
	<enter password>
mysql> CREATE DATABASE faculty_sport;
mysql> USE faculty_sport;
mysql> source <path to Lab1>/sql/createTables.sql
```
3. Run the haskell program: 
``` 
	$cd <Lab1 location>
	$ghci -iapp/:src/ -package io-streams -package mysql-haskell -XOverloadedStrings Main
Main*> main
```

###Run Tests:
1. Download HUnit
2. In console:
```
	$ghci -isrc/:tests/ -package io-streams -package mysql-haskell -package HUnit -XOverloadedStrings Tests
	*Tests> main
```

#Lab2
###Run:
In console:
``` 
	cd <Lab2 location>
	ghci Main
	:main data1.txt
	:main data2.txt
```
###Run tests:
1. Download HUnit
2. In console:
```
	cd <Lab2 location>
	ghci -package HUnit Tests
	main

