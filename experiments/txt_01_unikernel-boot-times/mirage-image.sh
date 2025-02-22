WORKDIR=$(realpath $(dirname $0))
IMAGESDIR=$WORKDIR/images
MIRAGE_IMAGE=${MIRAGE_IMAGE:-unikraft/eurosys21-artifacts-mirage:latest}
CONTAINER_NAME=mirage-build-noop

cleanup() {
  docker stop $CONTAINER_NAME
}

trap cleanup ERR
trap cleanup EXIT

# Ensure mirage unikernel directory has correct permissions
chown -Rf 1000:65533 $WORKDIR/mirage-noop

# Start the build container
docker run -t -d --rm \
  --name $CONTAINER_NAME \
  -v $WORKDIR/mirage-noop:/usr/src/app \
  -w /usr/src/app \
  $MIRAGE_IMAGE

# Configure and build the unikernel
docker exec $CONTAINER_NAME mirage configure -t hvt
docker exec $CONTAINER_NAME make depends
docker exec $CONTAINER_NAME make

mkdir -p $IMAGESDIR
mv $WORKDIR/mirage-noop/noop.hvt $IMAGESDIR/mirage-noop.hvt
