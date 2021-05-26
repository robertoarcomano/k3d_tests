#!/bin/bash
# Launch and log test_busybox.sh

# Constants
LOG=log.txt

# 1. log date
date | tee $LOG

# 2. launch script
bash -x ./test_busybox.sh 2>&1 | tee -a $LOG

# 3. log date
date | tee -a $LOG
