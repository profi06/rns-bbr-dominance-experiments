# RNS-bbr-dominance-experiments
Reproduction of the experiment in Figure_2.ipynb of github.com/ashutoshs25/bbr-dominance-experiments

- Generate a ssh key and name it robuste_vernetzte_systeme. Paste the public key into the vm setup scripts.
- Change all ip addresses in all scripts to the correct ones for your setup
- Run host-setup-script.sh on the computer host
- Run laptop-setup-script.sh on the laptop host
- Run vm-setup-script.sh with the argument "client", "emulator", "router", and "server" for the corresponding VM. Additionally, it may be required to enable the sshd service manually on each VM.
    - Variations of the vm-setup-script include notc, which excluded bottleneck and base RTT configuration and 1nbdp, 4nbdp with changed buffer sizes
- Run run-script.sh on the computer host (This takes ~35 minutes)
- Run extract.sh $FOLDERNAME to extract the experiment results from the VMs to $FOLDERNAME
- To automatically run multiple experiment runs and extract their results, you may use repeats.sh
