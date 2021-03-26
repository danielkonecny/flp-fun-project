{-
 Project:       BKG-2-CNF
 Decription:    Convert Context-free Grammar to Chomsky Normal Form.
 File:          Params.hs
 Version:       1.0
 Course:        FLP - Functional and Logic Programming
 Organisation:  Brno University of Technology - Faculty of Information Technology
 Author:        Daniel Konecny (xkonec75)
 Date:          26. 03. 2021
-}


module Params (
    dispatch
) where


import System.Environment
import System.IO

import Grammar
import Reduction
import Conversion


dispatch :: [(String, [String] -> IO ())]
dispatch = [
        ("-i", info),
        ("-1", one),
        ("-2", two)
    ]


info :: [String] -> IO ()
info [] = do
    putStrLn "INFO - Stdin"
    grammarFile <- getContents
    printGrammar (loadGrammar grammarFile)
info [fileName] = do
    putStrLn "INFO - File"
    handle <- openFile fileName ReadMode
    grammarFile <- hGetContents handle
    printGrammar (loadGrammar grammarFile)
    hClose handle


one :: [String] -> IO ()
one [] = do
    putStrLn "ONE - Stdin"
    grammarFile <- getContents
    printGrammar (reduceGrammar (loadGrammar grammarFile))
one [fileName] = do
    putStrLn "ONE - File"
    handle <- openFile fileName ReadMode
    grammarFile <- hGetContents handle
    printGrammar (reduceGrammar (loadGrammar grammarFile))
    hClose handle


two :: [String] -> IO ()
two [] = do
    putStrLn "TWO - Stdin"
    grammarFile <- getContents
    printGrammar (convertGrammar (reduceGrammar (loadGrammar grammarFile)))
two [fileName] = do
    putStrLn "TWO - File"
    handle <- openFile fileName ReadMode
    grammarFile <- hGetContents handle
    printGrammar (convertGrammar (reduceGrammar (loadGrammar grammarFile)))
    hClose handle

