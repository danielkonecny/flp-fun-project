{-
 Project:       BKG-2-CNF
 Decription:    Convert Context-free Grammar to Chomsky Normal Form.
 File:          Reduction.hs
 Version:       1.0
 Course:        FLP - Functional and Logic Programming
 Organisation:  Brno University of Technology - Faculty of Information Technology
 Author:        Daniel Konecny (xkonec75)
 Date:          26. 03. 2021
-}

module Reduction (
    reduceGrammar
    ) where


import Grammar


{-
@param      Rules
@param      All nonterminals 
@param      Nonterminals already in N_A
@param      Newly obtained nonterminals for N_A
@return     Newly obtained nonterminals for N_A
-}
constructNonterminalSet :: [Rule] -> [Char] -> [Char] -> [Char] -> [Char]
constructNonterminalSet [] _ _ _ = []
constructNonterminalSet (x:xs) nonterminals easyNonterminals newEasy =
    if left x `elem` easyNonterminals
        && length (right x) == 1
        && ((right x) !! 0) `elem` nonterminals
        && ((right x) !! 0) `notElem` easyNonterminals
        && ((right x) !! 0) `notElem` newEasy
        then ((right x) !! 0) : constructNonterminalSet xs nonterminals easyNonterminals (((right x) !! 0) : newEasy)
        else constructNonterminalSet xs nonterminals easyNonterminals newEasy


{-
@param      Grammar
@param      Already computed nonterminals in set N_A
@param      New computed nonterminals to be added to set N_A
@return     Finished set N_A
-}
getEasyNonterminals :: Grammar -> [Char] -> [Char] -> [Char]
getEasyNonterminals grammar easyNonterminals [] = []
getEasyNonterminals grammar easyNonterminals newEasy =
    concat [newEasy,
            getEasyNonterminals
                grammar
                (concat [easyNonterminals, newEasy])
                (constructNonterminalSet
                    (rules grammar)
                    (nonterminals grammar)
                    (concat [easyNonterminals, newEasy])
                    []
                )
            ]


newRules :: Grammar -> [Char] -> [Rule] -> [Char] -> [Rule]
newRules _ [] _ _ = []
newRules grammar nonterminals@(x:xs) [] _ = newRules grammar xs (rules grammar) []
newRules grammar nonterminals@(x:xs) rules@(y:ys) [] =
    if length (right y) == 1 && ((right y) !! 0) `elem` nonterminals
        then newRules grammar nonterminals ys []
        else if (left y) `elem` (getEasyNonterminals grammar [] [x])
            then Rule {left = x, right = (right y)} : newRules grammar nonterminals ys []
            else newRules grammar nonterminals ys []


reduceGrammar :: Grammar -> Grammar
reduceGrammar grammar = Grammar {
            nonterminals = (nonterminals grammar),
            terminals = (terminals grammar),
            start = (start grammar),
            rules = (newRules grammar (nonterminals grammar) (rules grammar) [])
        }
