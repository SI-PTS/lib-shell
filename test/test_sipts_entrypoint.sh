export SIPTS_CONTAINER_NAME="test"
export SIPTS_CONTAINER_VERSION="0.0.1"
export SIPTS_CONTAINER_COMMIT="abc123"
export SIPTS_CONTAINER_BUILDTIME="1992-02-14"
export SIPTS_CONTAINER_ENTRYPOINT="echo 'container entrypoint'"
$(dirname $0)/../Docker/sipts_entrypoint.sh
