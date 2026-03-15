#!/usr/bin/env bash
for j in $(seq 1 85)
do
    for i in $(seq 1 10)
    do
        cat run_${j}/queue-${i}.txt | awk '{{print $1","$24$30","$31}}' | tr -d 'b' | tr -d 'p' | sed 's/K/000/' | sed 's/M/000000/' > run_${j}/queue-${i}.csv
    done
done
