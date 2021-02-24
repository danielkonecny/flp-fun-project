# Project: 		BKG-2-CNF
# Decription:	Convert Context-free Grammar to Chomsky Normal Form.
# File: 		Makefile
# Version: 		0.2
# Course: 		FLP - Functional and Logic Programming
# Organisation:	Brno University of Technology - Faculty of Information Technology
# Author: 		Daniel Konecny (xkonec75)
# Date: 		24. 02. 2021

# Macros
GHC = ghc
SUFFIX = hs
PROJECT = bkg-2-cnf
LOGIN = xkonec75
SRC = src/
DOC = doc/
TEST = test/

all: $(PROJECT)

run: $(PROJECT)
	./$(PROJECT)

test: $(PROJECT)
	./$(PROJECT)

info: $(PROJECT)
	./$(PROJECT) -i

one: $(PROJECT)
	./$(PROJECT) -1

two: $(PROJECT)
	./$(PROJECT) -2

help: $(PROJECT)
	./$(PROJECT) -h

version: $(PROJECT)
	./$(PROJECT) -v

clean:
	rm $(PROJECT)

clear:
	rm $(PROJECT)

pack:
	zip -r flp-fun-$(LOGIN).zip $(SRC) $(DOC) $(TEST) Makefile

zip:
	zip -r flp-fun-$(LOGIN).zip $(SRC) $(DOC) $(TEST) Makefile

# Binary
$(PROJECT): $(SRC)Main.$(SUFFIX)
	$(GHC) -o $@ $^

## Binary
#$(PROJECT): $(PROJECT).o
#	$(GHC) $(FLAGS) $^ -o $@

## Object files
#$(PROJECT).o: $(PROJECT).$(SUFFIX) $(PROJECT).h
#	$(GHC) $(FLAGS) -c $< -o $@
#
#Knapsack.o: Knapsack.$(SUFFIX) Knapsack.h
#	$(GHC) $(FLAGS) -c $< -o $@
