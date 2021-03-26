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
	./$(PROJECT) -i "test/test1.in"

one: $(PROJECT)
	./$(PROJECT) -1 "test/test4.in"

two: $(PROJECT)
	./$(PROJECT) -2 "test/test5.in"

help: $(PROJECT)
	./$(PROJECT) -h

version: $(PROJECT)
	./$(PROJECT) -v

clean:
	rm $(PROJECT) $(SRC)*.o $(SRC)*.hi

pack:
	zip -r flp-fun-$(LOGIN).zip $(SRC) $(DOC) $(TEST) Makefile

zip:
	zip -r flp-fun-$(LOGIN).zip $(SRC) $(DOC) $(TEST) Makefile

# Binary
$(PROJECT): $(SRC)Main.$(SUFFIX) $(SRC)Params.$(SUFFIX) $(SRC)Grammar.$(SUFFIX) $(SRC)Reduction.$(SUFFIX) $(SRC)Conversion.$(SUFFIX)
	$(GHC) -o $@ $^

# Binary
#$(PROJECT): $(SRC)Main.o $(SRC)Params.o $(SRC)Grammar.o #$(SRC)Reduction.o
#	$(GHC) $^ -o $@

# Object files
#$(SRC)Params.o: $(SRC)Params.$(SUFFIX)
#	$(GHC) -c $< -o $@

#$(SRC)Main.o: $(SRC)Main.$(SUFFIX)
#	$(GHC) -c $< -o $@

#$(SRC)Grammar.o: $(SRC)Grammar.$(SUFFIX)
#	$(GHC) -c $< -o $@

#Reduction.o: $(SRC)Reduction.$(SUFFIX)
#	$(GHC) $(FLAGS) -c $< -o $@
