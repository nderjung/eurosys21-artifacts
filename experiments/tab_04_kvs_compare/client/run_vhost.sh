sudo modprobe ixgbe
sudo modprobe uio_pci_generic
sudo ip a flush enp1s0f0
sudo python3 ../aux/dpdk/usertools/dpdk-devbind.py --bind=uio_pci_generic enp1s0f0
sudo ../aux/dpdk2/build/app/dpdk-testpmd -l 2,3 -n 4 --vdev 'eth_vhost0,iface=vhost-net,queues=1' -- -i --txd=1024 --rxd=1024 --nb-cores=1 


# we run in the vhost
# port stop all
# set fwd mac
# port start all
# start
