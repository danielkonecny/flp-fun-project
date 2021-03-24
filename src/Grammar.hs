{-
 Project:       BKG-2-CNF
 Decription:    Convert Context-free Grammar to Chomsky Normal Form.
 File:          Grammar.hs
 Version:       1.0
 Course:        FLP - Functional and Logic Programming
 Organisation:  Brno University of Technology - Faculty of Information Technology
 Author:        Daniel Konecny (xkonec75)
 Date:          24. 03. 2021
-}


module Grammar (
    loadGrammar,
    printGrammar
) where


import Data.List


data Rule = Rule {
        left :: Char,
        right :: [Char]
    }

ruleToString :: Rule -> String
ruleToString rule = concat [[left rule], "->", right rule, "\n"]

rulesToString :: [Rule] -> String
rulesToString [] = ""
rulesToString rules = concat [ruleToString (head rules), rulesToString (tail rules)]


data Grammar = Grammar {
        nonterminals :: [Char],
        terminals :: [Char],
        start :: Char,
        rules :: [Rule]
    }

instance Show Grammar where
    show (Grammar nonterminals terminals start rules) = id (
            intersperse ',' nonterminals ++ "\n" ++
            intersperse ',' terminals ++ "\n" ++
            [start] ++ "\n" ++
            rulesToString rules
        )


getSymbols :: String -> [Char]
getSymbols xs = [x | x <- xs, not (x `elem` ",")]


getStart :: String -> Char
getStart line = head line


getRules :: [String] -> [Rule]
getRules [] = error "no rules"
getRules [x] = [Rule {left = head x, right = drop 3 x}]
getRules (x:xs) = getRules [x] ++ getRules xs


printGrammar :: Grammar -> IO ()
printGrammar grammar = putStr . show $ grammar


loadGrammar :: String -> Grammar
loadGrammar grammar = Grammar {
            nonterminals = getSymbols((lines grammar) !! 0),
            terminals = getSymbols((lines grammar) !! 1),
            start = getStart((lines grammar) !! 2),
            rules = getRules(drop 3 (lines grammar))
        }
