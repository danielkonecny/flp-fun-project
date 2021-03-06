{-
 Project: 		BKG-2-CNF
 Decription:	Convert Context-free Grammar to Chomsky Normal Form.
 File: 			Makefile
 Version: 		0.1
 Course: 		FLP - Functional and Logic Programming
 Organisation:	Brno University of Technology - Faculty of Information Technology
 Author: 		Daniel Konecny (xkonec75)
 Date: 			24. 02. 2021
-}

import System.Environment
import System.IO
import Data.List


dispatch :: [(String, [String] -> IO ())]
dispatch =  [
                ("-i", info),
                ("-1", one),
                ("-2", two)
            ]



info :: [String] -> IO ()
info [fileName] = do 
    handle <- openFile fileName ReadMode
    contents <- hGetContents handle
    putStr contents
    hClose handle


one :: [String] -> IO ()
one [fileName] = putStrLn $ "One from file " ++ fileName 



two :: [String] -> IO ()
two [fileName] = putStrLn $ "Two from file " ++ fileName


main = do
    (command:args) <- getArgs
    let (Just action) = lookup command dispatch
    action args
