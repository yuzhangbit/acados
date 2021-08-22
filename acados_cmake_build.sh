set -e

# submodule clone
mkdir -p ${HOME}/acados_osqp6

cd /tmp
rm -rf acados && git clone https://github.com/yuzhangbit/acados.git && 
cd /tmp/acados && git checkout tag_osqp_0.6 && git submodule update --recursive --init

# apply patches
cd /tmp/acados 
patch external/osqp/src/util.c -i 0001-fix-profiling-bug.patch
# compiling
cd /tmp/acados && mkdir -p build && cd /tmp/acados/build
cmake ..  -DACADOS_UNIT_TESTS=TRUE   \
          -DACADOS_WITH_QPOASES=TRUE \
          -DACADOS_WITH_HPMPC=TRUE \
          -DACADOS_WITH_QPDUNES=TRUE \
          -DACADOS_WITH_OSQP=TRUE \
          -DACADOS_PYTHON=TRUE \
          -DACADOS_EXAMPLES=TRUE \
          -DACADOS_INSTALL_DIR=${HOME}/acados_osqp6
make -j16
make install
cp -r /tmp/acados/build ${HOME}/acados_osqp6
