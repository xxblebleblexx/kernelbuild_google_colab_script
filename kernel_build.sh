kernelsource=https://github.com/xxblebleblexx/moonbeam_gale_kernel.git
kernelname=moonbeam_gale_kernel
branch_kernel=moonbeam
defconfig=arch/arm64/configs/gale_defconfig
clang_path=/content/clang/bin

git clone -b $branch_kernel --depth=1 $kernelsource;wait
cd $kernelname

#KSU DRIVER
curl -LSs "https://raw.githubusercontent.com/xxblebleblexx/MultiSU/refs/heads/legacy/kernel/setup.sh" | bash -s legacy

#KSU ACTIVATION
echo "CONFIG_KSU=y" >> $defconfig

#KPROBES HOOK
echo "CONFIG_KPROBES=y" >> $defconfig
echo "CONFIG_KPROBE_EVENTS=y" >> $defconfig
echo "CONFIG_KSU_KPROBES_HOOK=y" >> $defconfig
wait

export PATH=$clang_path:$PATH
clang --version

chmod +x build.sh;sh build.sh