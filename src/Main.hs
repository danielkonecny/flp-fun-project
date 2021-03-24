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


{-
type Nonterminal = Char
type Terminal = Char
data SymbolType = Nonterminal | Terminal deriving (Show, Eq, Enum)
data Symbol = Symbol {
        symbol :: Char,
        symbolType :: SymbolType
    }   
-}


{-
data Symbol = Nonterminal Char | Terminal Char deriving (Show, Eq)

data Rule = Rule {
        left :: Symbol,
        right :: [Symbol]
    }

data Grammar = Grammar {
        nonterminals :: [Symbol],
        terminals :: [Symbol],
        start :: Symbol,
        rules :: [Rule]
    }
-}


main = do
    (command:args) <- getArgs
    let (Just action) = lookup command dispatch
    action args
