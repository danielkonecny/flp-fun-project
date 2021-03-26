{-
 Project:       BKG-2-CNF
 Decription:    Convert Context-free Grammar to Chomsky Normal Form.
 File:          Conversion.hs
 Version:       1.0
 Course:        FLP - Functional and Logic Programming
 Organisation:  Brno University of Technology - Faculty of Information Technology
 Author:        Daniel Konecny (xkonec75)
 Date:          26. 03. 2021
-}

module Conversion (
    convertGrammar
    ) where


import Data.List

import Grammar


-- Compute rules according to stage 1 of the provided algorithm.
keepOnlyTerminals :: [Rule] -> [String] -> [Rule]
keepOnlyTerminals [] _ = []
keepOnlyTerminals (x:xs) terminals =
    if length (right x) == 1 && ((right x) !! 0) `elem` terminals
        then x : keepOnlyTerminals xs terminals
        else keepOnlyTerminals xs terminals


-- Compute rules according to stage 2 of the provided algorithm.
keepOnlyTwoNonterminals :: [Rule] -> [String] -> [Rule]
keepOnlyTwoNonterminals [] _ = []
keepOnlyTwoNonterminals (x:xs) nonterminals =
    if length (right x) == 2
        && ((right x) !! 0) `elem` nonterminals
        && ((right x) !! 1) `elem` nonterminals
        then x : keepOnlyTwoNonterminals xs nonterminals
        else keepOnlyTwoNonterminals xs nonterminals

renameTerminal :: [String] -> [String] -> [String]
renameTerminal [] _ = []
renameTerminal right@(x:xs) terminals =
    if x `elem` terminals
        then (x ++ "'") : renameTerminal xs terminals
        else x : renameTerminal xs terminals


-- Compute rules according to stage 3 of the provided algorithm.
transferSecondRight :: [String] -> String
transferSecondRight right = "<" ++ (right >>= id) ++ ">"

divideRule :: String -> [String] -> [String] -> [Rule]
divideRule left right terminals =
    if length right > 2
        then Rule {left = left,
                   right = renameTerminal
                        [(head right), transferSecondRight (tail right)]
                        terminals} :
            divideRule (transferSecondRight (tail right)) (tail right) terminals
        else [Rule {left = left, right = renameTerminal right terminals}]

divideLongRules :: [Rule] -> [String] -> [String] -> [Rule]
divideLongRules [] _ _ = []
divideLongRules rules@(x:xs) nonterminals terminals =
    if length (right x) > 2
        then divideRule (left x) (right x) terminals ++ divideLongRules xs nonterminals terminals
        else divideLongRules xs nonterminals terminals


-- Compute rules according to stage 4 of the provided algorithm.
renameTwoTerminals :: [Rule] -> [String] -> [Rule]
renameTwoTerminals [] _ = []
renameTwoTerminals rules@(x:xs) terminals = 
    if length (right x) == 2
        && (((right x) !! 0) `elem` terminals || ((right x) !! 1) `elem` terminals)
        then Rule {left = (left x), right = renameTerminal (right x) terminals} :
            renameTwoTerminals xs terminals
        else renameTwoTerminals xs terminals


-- Process the stages 1 through 4 of the algorithm 4.7.
getNewRules :: Grammar -> [Rule]
getNewRules grammar = nub (
        keepOnlyTerminals (rules grammar) (terminals grammar) ++
        keepOnlyTwoNonterminals (rules grammar) (nonterminals grammar) ++
        divideLongRules (rules grammar) (nonterminals grammar) (terminals grammar) ++
        renameTwoTerminals (rules grammar) (terminals grammar)
    )


-- Add all newly created nonterminals to the set of nonterminals.
getNewTerminalRule :: [String] -> [String] -> [Rule]
getNewTerminalRule right terminals =
    if '\'' `elem` (right !! 0)
        then if '\'' `elem` (right !! 1)
            then [
                Rule {left = right !! 0, right = [[(right !! 0) !! 0]]},
                Rule {left = right !! 1, right = [[(right !! 1) !! 0]]}
            ]
            else [Rule {left = right !! 0, right = [[(right !! 0) !! 0]]}]
        else if '\'' `elem` (right !! 1)
            then [Rule {left = right !! 1, right = [[(right !! 1) !! 0]]}]
            else []

addRenamedTerminals :: [Rule] -> [String] -> [Rule]
addRenamedTerminals [] _ = []
addRenamedTerminals rules@(x:xs) terminals =
    if length (right x) == 2
        then getNewTerminalRule (right x) terminals ++ addRenamedTerminals xs terminals
        else addRenamedTerminals xs terminals

addNonTerminals :: [Rule] -> [String]  -> [String]
addNonTerminals [] _ = []
addNonTerminals rules@(x:xs) nonterminals =
    if length (right x) == 2
        then if ((right x) !! 0) `elem` nonterminals
            then if ((right x) !! 1) `elem` nonterminals
                then addNonTerminals xs nonterminals
                else [(right x) !! 1] ++ addNonTerminals xs nonterminals
            else if ((right x) !! 1) `elem` nonterminals
                then [(right x) !! 0] ++ addNonTerminals xs nonterminals
                else [(right x) !! 0] ++ [(right x) !! 1] ++ addNonTerminals xs nonterminals
        else addNonTerminals xs nonterminals


-- Process the conversion.
convertGrammar :: Grammar -> Grammar
convertGrammar grammar =
    Grammar {
        nonterminals =
            (nonterminals grammar) ++
            nub (addNonTerminals (getNewRules grammar) (nonterminals grammar)),
        terminals = (terminals grammar),
        start = (start grammar),
        rules =
            getNewRules grammar ++
            nub (addRenamedTerminals (getNewRules grammar) (terminals grammar))
    }
