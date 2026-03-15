DURATION=200
IFACE="enp7s0"  # router -> server

# IPs
IPC1="192.168.0.7"
IPE1="192.168.0.220"
IPE2="192.168.0.3"
IPR1="192.168.0.167"
IPR2="192.168.0.52"
IPS1="192.168.0.28"

CLIENT="-i robuste_vernetzte_systeme vboxuser@$IPC1"
EMULATOR="-i robuste_vernetzte_systeme vboxuser@$IPE1"
ROUTER="-i robuste_vernetzte_systeme vboxuser@$IPR1"
SERVER="-i robuste_vernetzte_systeme vboxuser@$IPS1"

ssh-copy-id $CLIENT
ssh-copy-id $EMULATOR
ssh-copy-id $ROUTER
ssh-copy-id $SERVER

ssh $SERVER killall iperf3

for i in $(seq 1 10)
do
    echo ======== BBR $i ========
    ssh $SERVER iperf3 -s -1 -p 4000 -D
    ssh $SERVER iperf3 -s -1 -p 5000 -D
    ssh $ROUTER "rm queue-$i.txt; start_time=\$(date +%s); while true; do tc -p -s -d qdisc show dev $IFACE | tr -d '\n' | ts '%.s' | tee -a queue-$i.txt; echo "" | tee -a queue-$i.txt; current_time=\$(date +%s); elapsed_time=\$((current_time - start_time));  if [ \$elapsed_time -ge $DURATION ]; then break; fi; sleep 0.1; done;" &
    ssh $CLIENT "rm -f $i-ss.txt; start_time=\$(date +%s); while true; do ss --no-header -eipn dst 10.0.3.1 | ts '%.s' | tee -a $i-ss.txt; current_time=\$(date +%s); elapsed_time=\$((current_time - start_time));  if [ \$elapsed_time -ge $DURATION ]; then break; fi; sleep 0.1; done;" &
    ssh $CLIENT "sleep 1; iperf3 -c 10.0.3.1 -t $DURATION -P $i -C bbr -p 4000 -J > bbr-result-$i.json" &
    echo ==== Running BBR $i ====
    ssh $CLIENT "sleep 1; iperf3 -c 10.0.3.1 -t $DURATION -P $((10-i)) -C cubic -p 5000 -i 0.1 -J > cubic-result-$i.json"
    sleep 5
done
