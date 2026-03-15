#!/usr/bin/env bash
for i in $(seq 1 10)
do
    cat queue-${i}.txt | awk '{{print $1","$27$33","$34}}' | tr -d 'b' | tr -d 'p' | sed 's/K/000/' | sed 's/M/000000/' > queue-${i}.csv
done
