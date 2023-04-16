#!/bin/sh -e
if [ ! -f collapseos/README ]; then
	git submodule init
	git submodule update
fi
cd collapseos
if [ ! -f tools/blkpack ]; then
	git stash push --all
	cd tools
	make blkpack
	cd ../cvm
	make stage
	cd ..
fi
cd ..
collapseos/tools/blkpack < collapseos/blk.fs > blkfs
collapseos/cvm/stage blkfs <xcomp.fs >collapseos.bin
collapseos/cvm/stage blkfs <xcomp-con.fs >collapseos-con.bin
uxnasm collapseos.tal collapseos.rom
uxnasm collapseos-con.tal collapseos-con.rom
uxnasm cos-lite.tal cos-lite.rom
uxnasm cos-lite-con.tal cos-lite-con.rom
cat collapseos.bin >>cos-lite.rom
cat collapseos-con.bin >>cos-lite-con.rom
