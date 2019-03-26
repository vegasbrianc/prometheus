echo ""
echo "Starting busybox(es) to trash CPU(s)"
echo ""

image=busybox
numberofcpus=$(grep -c ^processor /proc/cpuinfo)
numberofcpus=4

# this is where the magic happens
for ((i=0;i<$numberofcpus;i++))
do
	docker run --detach $image sh -c "while true; do :; done"
done

# read the any key
echo ""
read -n 1 -s -r -p "Press any key to cancel trashing"
echo ""

# shutdown all busyboxes
docker kill $(docker ps -a -q  --filter ancestor=$image)