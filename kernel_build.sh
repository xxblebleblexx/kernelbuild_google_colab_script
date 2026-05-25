#CONFIGURATION
kernelsource=https://github.com/xxblebleblexx/moonbeam_gale_kernel.git
kernelname=moonbeam_gale_kernel
branch_kernel=moonbeam
defconfig=arch/arm64/configs/gale_defconfig
clang_path=/content/clang/bin
fast_path=/tmp
hooks=kprobes #only manual hook/kprobes hook

cd $fast_path
git clone -b $branch_kernel --depth=1 $kernelsource;wait
cd $fast_path/$kernelname

#KSU DRIVER
curl -LSs "https://raw.githubusercontent.com/xxblebleblexx/MultiSU/refs/heads/legacy/kernel/setup.sh" | bash -s legacy

#KSU ACTIVATION
echo "CONFIG_KSU=y" >> $defconfig

if ["$hooks" = "kprobes"]; then
#KPROBES HOOK
echo "CONFIG_KPROBES=y" >> $defconfig
echo "CONFIG_KPROBE_EVENTS=y" >> $defconfig
echo "CONFIG_KSU_KPROBES_HOOK=y" >> $defconfig
wait
fi

if ["$hooks" = "manual"]; then
#MANUAL HOOK
echo "CONFIG_KSU_MANUAL_HOOK=y" >> $defconfig
wget https://github.com/xxblebleblexx/manual_hook_fix/blob/main/manualhook_1.6_fixed.patch;wait;patch -p1 < manualhook_1.6_fixed.patch
fi

export PATH=$clang_path:$PATH

chmod +x build.sh;sh build.sh
