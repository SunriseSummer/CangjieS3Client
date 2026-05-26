source ~/Downloads/cangjie-1.0.5/envsetup.sh
export CANGJIE_STDX_PATH=~/Downloads/cangjie-stdx-linux-x64-1.0.5.1/linux_x86_64_cjnative/dynamic/stdx
export LD_LIBRARY_PATH=$CANGJIE_STDX_PATH:$LD_LIBRARY_PATH
cjpm run
