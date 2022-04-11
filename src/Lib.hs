{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts   #-}
{-# LANGUAGE DerivingStrategies #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Lib
    ( someFunc
    ) where
import System.IO
import Text.Read
import Database.HDBC.Sqlite3 (connectSqlite3)
import Database.HDBC

type Name = String
type Result = Int
type ID = Int

--create user, if it doesn't exist, return id
createAUser:: Name -> IO (Int)
createAUser name = do
	conn <- connectSqlite3 "dbChervyak"
	selectPreparetion <- prepare conn "SELECT id from users where name = ?"
	res <- execute selectPreparetion [toSql name] 
	results <- fetchAllRowsAL selectPreparetion
	if null results then do
		run conn "INSERT INTO users (name) VALUES (?)" [toSql name]
		commit conn
		disconnect conn
		newUserId <- (createAUser name)
		return newUserId
	else do
		disconnect conn
		return (getIDFromResult results)
		
--type conversion id to int
getIDFromResult:: [[(String, SqlValue)]] -> Int
getIDFromResult mas = fromSql (snd(head(head mas)))
getIDFromResult  _ = -1


someFunc:: IO()
someFunc = do 
	conn <- connectSqlite3 "dbChervyak"
	run conn "CREATE TABLE if not exists users (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, name varchar(15) NOT NULL)" []
	run conn "CREATE TABLE if not exists records (id integer NOT NULL, result int NOT NULL, time int)" []
	commit conn
	disconnect conn
	s <- createAUser "sasha"
	putStrLn (show s)
	--writeResultToTable 30 s
	--writeResultToTable 100 s
	d <- getTop10
	putStrLn (show d)




--write the result to the table of records
writeResultToTable:: Result -> ID -> IO ()
writeResultToTable result id = do
	conn <- connectSqlite3 "dbChervyak"
	run conn "INSERT INTO records (id, result) VALUES (?, ?)" [toSql id, toSql result]
	commit conn
	disconnect conn

--parsing the array returned by the table
getListFromQuery::[[(String, SqlValue)]]->[(String, Int)]
getListFromQuery mas = map (\elem -> (fromSql( snd (head elem) ), fromSql( snd ( head ( tail elem ) ) ) ) ) mas


--get top 10 results from records table
getTop10:: IO [(String, Int)]
getTop10 = do 
	conn <- connectSqlite3 "dbChervyak"
	selectPreparetion <- prepare conn "SELECT name, MAX(result) from records left join users on users.id = records.id group by name limit 10"
	res <- execute selectPreparetion []
	results <- fetchAllRowsAL' selectPreparetion
	--putStrLn (show results)
	disconnect conn
	return (getListFromQuery results)





--новый рекорд если, все люди в таблице records 

--1) создать пользователя (по имени) - 
--таблица1 : имя, id
--таблица2 : id, результат, время игры
--2) получить таблицу рекордов
--3) получить имена с id
--4) записать результат игры
