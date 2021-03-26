{-
 Project:       BKG-2-CNF
 Decription:    Convert Context-free Grammar to Chomsky Normal Form.
 File:          Conversion.hs
 Version:       0.1
 Course:        FLP - Functional and Logic Programming
 Organisation:  Brno University of Technology - Faculty of Information Technology
 Author:        Daniel Konecny (xkonec75)
 Date:          26. 03. 2021
-}

module Conversion (
    convertGrammar
    ) where


import Grammar





convertGrammar :: Grammar -> Grammar
convertGrammar grammar = Grammar {
            nonterminals = (nonterminals grammar),
            terminals = (terminals grammar),
            start = (start grammar),
            rules = (rules grammar)
        }
