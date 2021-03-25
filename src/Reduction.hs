{-
 Project:       BKG-2-CNF
 Decription:    Convert Context-free Grammar to Chomsky Normal Form.
 File:          Reduction.hs
 Version:       0.1
 Course:        FLP - Functional and Logic Programming
 Organisation:  Brno University of Technology - Faculty of Information Technology
 Author:        Daniel Konecny (xkonec75)
 Date:          24. 03. 2021
-}

module Reduction (
    reduceGrammar
    ) where


import Grammar


-- Rules + all nonterminals + nonterminals already in N_A + newly obtained nonterminals for N_A -> newly obtained nonterminals for N_A
checkRules :: [Rule] -> [Char] -> [Char] -> [Char] -> [Char]
checkRules [] _ _ _ = []
checkRules (x:xs) nonterminals easyNonterminals newEasy =
    if left x `elem` easyNonterminals
        && length (right x) == 1
        && ((right x) !! 0) `elem` nonterminals
        && ((right x) !! 0) `notElem` easyNonterminals
        && ((right x) !! 0) `notElem` newEasy
        then ((right x) !! 0) : checkRules xs nonterminals easyNonterminals (((right x) !! 0) : newEasy)
        else checkRules xs nonterminals easyNonterminals newEasy


getEasyNonterminals :: Grammar -> [Char] -> [Char] -> [Char]
getEasyNonterminals grammar easyNonterminals [] = []
getEasyNonterminals grammar easyNonterminals newEasy =
    concat [newEasy,
            getEasyNonterminals
                grammar
                (concat [easyNonterminals, newEasy])
                (checkRules (rules grammar)
                            (nonterminals grammar)
                            (concat [easyNonterminals, newEasy])
                            [])
            ]


newRules :: Grammar -> Grammar
newRules grammar = Grammar {
            nonterminals = (nonterminals grammar),
            terminals = (terminals grammar),
            start = (start grammar),
            rules = []
        }


reduceGrammar :: Grammar -> IO ()
reduceGrammar grammar = print (getEasyNonterminals grammar [] ([(nonterminals grammar) !! 0]))
