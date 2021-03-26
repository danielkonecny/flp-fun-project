# Project: 		BKG-2-CNF
# Decription:	Convert Context-free Grammar to Chomsky Normal Form.
# File: 		Makefile
# Version: 		1.0
# Course: 		FLP - Functional and Logic Programming
# Organisation:	Brno University of Technology - Faculty of Information Technology
# Author: 		Daniel Konecny (xkonec75)
# Date: 		26. 03. 2021

# Macros
GHC = ghc
SUFFIX = hs
PROJECT = bkg-2-cnf
LOGIN = xkonec75
SRC = src/
DOC = doc/
TEST = test/

all: $(PROJECT)

test: $(PROJECT)
	./$(PROJECT)

info: $(PROJECT)
	./$(PROJECT) -i "test/test1.in"

one: $(PROJECT)
	./$(PROJECT) -1 "test/test1.in"

two: $(PROJECT)
	./$(PROJECT) -2 "test/test1.in"

clean:
	rm $(PROJECT) $(SRC)*.o $(SRC)*.hi

pack:
	zip -r flp-fun-$(LOGIN).zip $(SRC) $(DOC) $(TEST) Makefile

zip:
	zip -r flp-fun-$(LOGIN).zip $(SRC) $(DOC) $(TEST) Makefile

# Binary
$(PROJECT): $(SRC)Main.$(SUFFIX) $(SRC)Params.$(SUFFIX) $(SRC)Grammar.$(SUFFIX) $(SRC)Reduction.$(SUFFIX) $(SRC)Conversion.$(SUFFIX)
	$(GHC) -o $@ $^
