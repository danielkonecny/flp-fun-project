{-
 Project: 		BKG-2-CNF
 Decription:	Convert Context-free Grammar to Chomsky Normal Form.
 File: 			Main.hs
 Version: 		1.0
 Course: 		FLP - Functional and Logic Programming
 Organisation:	Brno University of Technology - Faculty of Information Technology
 Author: 		Daniel Konecny (xkonec75)
 Date: 			24. 03. 2021
-}

import System.Environment

import Params


main = do
    (command:args) <- getArgs
    let (Just action) = lookup command dispatch
    action args
