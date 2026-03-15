#!/usr/bin/env bash

for i in $(seq 1 10)
do
    echo RUN NUMBER $i
    echo RUN NUMBER $i
    echo RUN NUMBER $i
    echo RUN NUMBER $i
    echo RUN NUMBER $i
    bash run-script.sh
    echo COMPLETED RUN NUMBER $i
    echo COMPLETED RUN NUMBER $i
    echo COMPLETED RUN NUMBER $i
    echo COMPLETED RUN NUMBER $i
    echo COMPLETED RUN NUMBER $i
    bash extract.sh "run_$i"
done
