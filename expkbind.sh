TOPDIR=$(pwd)
BUILDROOT_DIR="${TOPDIR}/.."
EX_DIR="${BUILDROOT_DIR}/expk"
PRODUCT_CFG="$1"
TMP_PRODUCT_CFG_DIR="/tmp/expkcfg"
if [ "${PRODUCT_CFG}" = "" ]
then
    echo "please input expk defconfig"
    exit
fi
### Binding local.mk to buildroot
echo
tput smso 2> /dev/null
echo -e ">>> Binding expk/local.mk to buildroot"
tput rmso 2> /dev/null
ln -sf ${EX_DIR}/local.mk ${BUILDROOT_DIR}/local.mk
echo "Done"


cd ${BUILDROOT_DIR}
make BR2_EXTERNAL=${EX_DIR} ${PRODUCT_CFG}
if [ $? -ne 0 ]; then
	echo
	echo "Error: make product config failed. "
	echo "command: make BR2_EXTERNAL=${EX_DIR} ${PRODUCT_CFG}"
	echo "Have a check on ${EX_DIR}/configs."
	exit 1;
else
	echo ${PRODUCT_CFG} > ${TMP_PRODUCT_CFG_DIR}
fi

