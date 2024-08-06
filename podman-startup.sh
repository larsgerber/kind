#!/bin/bash

let statusCount=0

/opt/homebrew/bin/podman ps

while [ $? -ne 0 ]; do
	let "statusCount++"
	if [ $statusCount -gt 12 ]; then
		echo Timeout waiting for Podman
		exit 1
	fi
	sleep 10
	/opt/homebrew/bin/podman ps
done

/opt/homebrew/bin/podman restart kind-control-plane
