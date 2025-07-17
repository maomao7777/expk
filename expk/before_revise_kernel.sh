#!/bin/bash
if [ ! -f "./local.mk" ]; then
	echo "Error: local.mk is not found"
	exit 1
fi

grep LINUX_OVERRIDE_SRCDIR ./local.mk > /dev/null
if [ $? -ne 0 ]; then
	tput smso 2>/dev/null
	echo "LINUX_OVERRIDE_SRCDIR=\"./dl/linux/git\"" >> local.mk
	echo "> Append LINUX_OVERRIDE_SRCDIR=\"./dl/linux/git\" to local.mk."
	echo "> Please NOT THAT Do Not Commit/Merge local.mk"
	tput rmso 2>/dev/null
	echo
else
	tput smso 2>/dev/null
	echo "> There is already LINUX_OVERRIDE_SRCDIR in local.mk"
	tput rmso 2>/dev/null
	echo
fi
exit 0
