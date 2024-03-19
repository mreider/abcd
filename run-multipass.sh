multipass launch -n ubuntu-vm -c 4 -m 8G -d 20G
mkdir ~/abcd
multipass mount ~/abcd ubuntu-vm:/home/ubuntu/shared
chmod +x ~/abcd/setup-vm.sh
multipass exec ubuntu-vm -- /home/ubuntu/shared/setup-vm.sh
