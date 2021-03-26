{-
 Project:       BKG-2-CNF
 Decription:    Convert Context-free Grammar to Chomsky Normal Form.
 File:          Grammar.hs
 Version:       1.0
 Course:        FLP - Functional and Logic Programming
 Organisation:  Brno University of Technology - Faculty of Information Technology
 Author:        Daniel Konecny (xkonec75)
 Date:          26. 03. 2021
-}


module Grammar (
    Rule (Rule),
    left,
    right,
    Grammar (Grammar),
    nonterminals,
    terminals,
    start,
    rules,
    loadGrammar,
    printGrammar
) where


import Data.List

-- Data structure representing a rule in a grammar.
data Rule = Rule {
        left :: String,
        right :: [String]
    } deriving (Eq)

ruleToString :: Rule -> String
ruleToString rule = left rule ++ "->" ++ ((right rule) >>= id) ++ "\n"

rulesToString :: [Rule] -> String
rulesToString [] = ""
rulesToString rules = ruleToString (head rules) ++ rulesToString (tail rules)

-- Data strcture representing a (context-free) grammar.
data Grammar = Grammar {
        nonterminals :: [String],
        terminals :: [String],
        start :: String,
        rules :: [Rule]
    }

instance Show Grammar where
    show (Grammar nonterminals terminals start rules) = id ( 
            intercalate "," nonterminals ++ "\n" ++
            intercalate "," terminals ++ "\n" ++
            start ++ "\n" ++
            rulesToString rules
        )


getSymbols :: String -> [String]
getSymbols [] = [""]
getSymbols (c:cs)
    | c == ','  = "" : rest
    | otherwise = (c : head rest) : tail rest
        where rest = getSymbols cs


getStart :: String -> String
getStart line = line


getRight :: [Char] -> [String]
getRight [] = []
getRight (x:xs) = [[x]] ++ getRight xs


getRules :: [String] -> [Rule]
getRules [] = error "no rules"
getRules [x] = [Rule {left = [head x], right = (getRight (drop 3 x))}]
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
