#!/bin/bash
# Launch and log setup_and_test.sh

# Constants
LOG=log.txt

# 1. log date
date > $LOG

# 2. launch script
bash -x ./setup_and_test.sh 2>&1 | tee -a log.txt

# 3. log date
date >> $LOG
