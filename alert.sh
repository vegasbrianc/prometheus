echo ""
echo "Starting busybox to trash CPU"
echo ""

# this is where the magic happens
docker run --rm -it busybox sh -c "while true; do :; done"
