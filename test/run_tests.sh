#!/bin/bash 

#-------------------------------------#
#----- FIT VUT ------ Tomáš Ryšavý ---#
#--- Projekt FLP ------ xrysav27 -----#
#---- BKG-2-CNF ----- 18. 03. 2021 ---#
#-------------------------------------#

# Sript will perform all the test in 
# this folder.
# To make this script working the folder 
# structure must look like this:

# project_folder/
# ├── tests/
# │   ├── run_tests.sh
# │   ├── test1.in
# │   ├── test1.1.out
# │   ├── test1.2.out
# │   ├── test2.in
# │   ├── test2.1.out
# │   ├── test2.2.out
# │   └── •••
# └── bkg-2-cnf

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0;m'

TESTCOUNT=`ls -l ./*.in | wc -l`
TEMPFILE="test.temp"
TESTVARIANTS=(1 2)

PASSEDTESTS=0
FAILEDTESTS=0
for TESTNO in $(seq 1 ${TESTCOUNT}); do
	for VARIANT in ${TESTVARIANTS[@]}; do
		FILE="test${TESTNO}.in"
		FILEOUT="test${TESTNO}.${VARIANT}.out"
	    echo -e "\n${GREEN}### TEST No. ${TESTNO}-${VARIANT} ###${RED}"
	    echo -e "${NC}# Script output: ../bkg-2-cnf -${VARIANT} ${FILE}${RED}"
	    `../bkg-2-cnf -${VARIANT} ${FILE} > ${TEMPFILE}`

	    # LOAD FILES
	    ###########
	    printf -v ESC_TEMP_FILE "%q\n" ${TEMPFILE}
	  	IFS=$'\r\n' GLOBIGNORE='*' command eval  'ESC_TEMP_FILE_ARRAY=($(cat ${ESC_TEMP_FILE}))'

	    printf -v ESC_FILE_OUT "%q\n" ${FILEOUT}
	  	IFS=$'\r\n' GLOBIGNORE='*' command eval  'ESC_FILE_OUT_ARRAY=($(cat ${ESC_FILE_OUT}))'

	    # CHECK NONTERMS
	    IFS=$',' read -a TEMP_FILE_NONTERMS_ARRAY <<< "${ESC_TEMP_FILE_ARRAY[0]}"
	    TEMP_FILE_NONTERMS=(${TEMP_FILE_NONTERMS_ARRAY[@]})	
		IFS=$'\n' TEMP_FILE_NONTERMS=($(sort <<<"${TEMP_FILE_NONTERMS[*]}")); unset IFS

	    IFS=$',' read -a FILE_OUT_NONTERMS_ARRAY <<< "${ESC_FILE_OUT_ARRAY[0]}"
	    FILE_OUT_NONTERMS=(${FILE_OUT_NONTERMS_ARRAY[@]})	
		IFS=$'\n' FILE_OUT_NONTERMS=($(sort <<<"${FILE_OUT_NONTERMS[*]}")); unset IFS

		DIF_NONTERMS=`diff <(echo ${TEMP_FILE_NONTERMS}) <(echo ${FILE_OUT_NONTERMS})`


	    # CHECK TERMS
	    IFS=$',' read -a TEMP_FILE_TERMS_ARRAY <<< "${ESC_TEMP_FILE_ARRAY[1]}"
	    TEMP_FILE_TERMS=(${TEMP_FILE_TERMS_ARRAY[@]})	
		IFS=$'\n' TEMP_FILE_TERMS=($(sort <<<"${TEMP_FILE_TERMS[*]}")); unset IFS

	    IFS=$',' read -a FILE_OUT_TERMS_ARRAY <<< "${ESC_FILE_OUT_ARRAY[1]}"
	    FILE_OUT_TERMS=(${FILE_OUT_TERMS_ARRAY[@]})	
		IFS=$'\n' FILE_OUT_TERMS=($(sort <<<"${FILE_OUT_TERMS[*]}")); unset IFS

		DIF_TERMS=`diff <(echo ${TEMP_FILE_TERMS}) <(echo ${FILE_OUT_TERMS})`


	    # CHECK START
	    DIF_START=`diff <(echo ${ESC_TEMP_FILE_ARRAY[2]}) <(echo ${ESC_FILE_OUT_ARRAY[2]})`



	    # CHECK RULES
	    SORT_ESC_TEMP_FILE_RULES_ARRAY=`sort <(printf "%s\n" ${ESC_TEMP_FILE_ARRAY[@]:3})`
	    SORT_ESC_FILE_OUT_RULES_ARRAY=`sort <(printf "%s\n" ${ESC_FILE_OUT_ARRAY[@]:3})`

	    DIF_RULES=`diff -n <(echo ${SORT_ESC_TEMP_FILE_RULES_ARRAY[@]}) <(echo ${SORT_ESC_FILE_OUT_RULES_ARRAY[@]})`


	    PRINT_IF_AS_EXPECTED=true # true
	    # RESULTS
		if [ -z "$DIF_NONTERMS" ] && [ -z "$DIF_TERMS" ] && [ -z "$DIF_START" ] && [ -z "$DIF_RULES" ]; then

			if [ "$PRINT_IF_AS_EXPECTED" == "true" ]; then
				echo -e "${NC}GRAMMAR"
				echo "-----------------"
		    	printf "%s " "${TEMP_FILE_NONTERMS[@]}"
		    	echo ""
		    	printf "%s " "${TEMP_FILE_TERMS[@]}"
		    	echo ""
		    	printf "%s\n" "${ESC_TEMP_FILE_ARRAY[2]}"
		    	printf "%s\n" "${SORT_ESC_TEMP_FILE_RULES_ARRAY[@]}"
		    	echo ""
		    fi

			echo -e "${NC}Result:$GREEN OK $NC"
			PASSEDTESTS=$((PASSEDTESTS+1))
		else
			echo -e "${NC}EXPECTED"
			echo "-----------------"
	    	printf "%s " "${FILE_OUT_NONTERMS[@]}"
	    	echo ""
	    	printf "%s " "${FILE_OUT_TERMS[@]}"
	    	echo ""
	    	printf "%s\n" "${ESC_FILE_OUT_ARRAY[2]}"
	    	printf "%s\n" "${SORT_ESC_FILE_OUT_RULES_ARRAY[@]}"

			echo ""
			echo "YOUR OUTPUT"
			echo "-----------------"
	    	printf "%s " "${TEMP_FILE_NONTERMS[@]}"
	    	echo ""
	    	printf "%s " "${TEMP_FILE_TERMS[@]}"
	    	echo ""
	    	printf "%s\n" "${ESC_TEMP_FILE_ARRAY[2]}"
	    	printf "%s\n" "${SORT_ESC_TEMP_FILE_RULES_ARRAY[@]}"

			echo ""
			echo "DIFF"
			echo "-----------------"



	    	NONTERMS=""
	    	TERMS=""
	    	START=""
	    	RULES=""
	    	if [ ! -z "$DIF_NONTERMS" ]; then
	    		NONTERMS="NONTERMS "
				echo "$DIF_NONTERMS"
	    	fi
	    	if [ ! -z "$DIF_TERMS" ]; then
	    		TERMS="TERMS "
				echo "$DIF_TERMS"
	    	fi
	    	if [ ! -z "$DIF_START" ]; then
	    		START="START "
				echo "$DIF_START"
	    	fi
	    	if [ ! -z "$DIF_RULES" ]; then
	    		RULES="RULES "
				echo "$DIF_RULES"
	    	fi

			echo ""
			echo -e "Result:$RED DIFF NOT PASSED IN: ${NONTERMS}${TERMS}${START}${RULES}$NC"
			FAILEDTESTS=$((FAILEDTESTS+1))
		fi
	    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
	done
done
echo -e "FINAL RESULTS: $GREEN PASSED: $PASSEDTESTS $RED FAILED: ${FAILEDTESTS}$NC"
`rm test.temp`