#!/bin/bash
# Launch and log test_loadbalancing.sh

# Constants
LOG=log.txt

# 1. log date
date | tee $LOG

# 2. launch script
./test_loadbalancing.sh 2>&1 | tee -a $LOG

# 3. log date
date | tee -a $LOG
