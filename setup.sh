#!/bin/bash

#Checking python version
echo "Checking python version ..."
PYEXE="python"
PV=$($PYEXE -c "import sys; sys.stdout.write(str(sys.version_info.major));")
if [[ "$PV" != "3" ]]; then
	echo 'Calling "python" does not run version 3, testing "python3"'
	PYEXE="python3"
	echo "Testing python3 ..."
	$PYEXE -c "import sys"
	rv=$?
	if [[ $rv != 0 ]]; then
		echo "Error: could not run $PYEXE. Please install Python 3 to continue"
		exit 1
	fi
fi

#Checking dependencies
echo "Checking dependencies ..."
$PYEXE -c "import pyatv, yaspin, inquirer, sponsorblock, youtubesearchpython; print ('Import test successful')"
rv=$?
if [[ $rv == 0 ]]; then
	echo "Dependencies look's OK"
else
	echo "Import test failed, attempting to install dependencies"
	$PYEXE -m venv env
	source env/bin/activate
	# Switching from $PYEXE to python because venv should be active now
	python -m pip install -q -r requirements.txt
	echo "============================================================"
	echo "The environment and packages are installed"
	echo "============================================================"
fi 

#Checking appletv.json
echo "Checking appletv.json ..."
if [[ ! -f "/data/appletv.json" ]]; then 
	source env/bin/activate
	python atv_ps_handler/pair_and_save.py
fi

#Checking appletv.json and ENV after setup
if [[ -d env ]] && [[ -f "/data/appletv.json" ]]; then
	echo "============================================================"
	echo "Everything look's OK!" 
	echo "Use docker run with CMD --run"
	echo "============================================================"
	exit
fi