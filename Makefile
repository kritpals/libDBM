#CC=$(COCONUT_OPENWRT_DIR)/staging_dir/toolchain-arm_gcc-4.5.1+l_uClibc-0.9.32_eabi/bin/arm-openwrt-linux-gcc
CC=gcc
LIBDBMSOURCE=libDBM.c
LIBDBMHEADER=libDBM.h
LIBDBMFLAGS=-c -D_XOPEN_SOURCE_EXTENDED=1 -D_GNU_SOURCE=1 -D__EXTENSIONS__=1 -D_HPUX_SOURCE=1 -D_POSIX_MAPPED_FILES=1 -D_POSIX_SYNCHRONIZED_IO=1 -DPIC=1 -D_THREAD_SAFE=1 -D_REENTRANT=1 -DNDEBUG -Wall -pedantic -fPIC -fsigned-char -O3 -fomit-frame-pointer -fforce-addr
LIBDBMOBJECT=$(LIBDBMSOURCE:.c=.o)
LIBDBMEXECUTABLE=libDBM.so.1
LIBDBMEXECUTABLEA=libDBM.a
LIBDBMNAME=libDBM.so.1.0
LIBDBMSHARED=libDBM.so
#DONUT_DIR=/home/devesh/MT/RT288x_SDK/source
#DONUT_BUILDROOT_DIR=/opt/buildroot-gcc342
#TOPDIR=../
#include $(TOPDIR)Rules.mak

all:
	$(CC) $(LIBDBMFLAGS) $(LIBDBMSOURCE) -o $(LIBDBMOBJECT)
	$(CC) -shared -Wl,-soname,$(LIBDBMEXECUTABLE) -o $(LIBDBMNAME) $(LIBDBMOBJECT)
	ar rcs $(LIBDBMEXECUTABLEA) $(LIBDBMOBJECTS) 
	ln -sf $(LIBDBMNAME) $(LIBDBMSHARED)
	ln -sf $(LIBDBMNAME) $(LIBDBMSHARED).1
	#cp $(LIBDBMEXECUTABLE) /tftpboot/
	$(CC) test.c -o /tftpboot/test -L. -I. -lDBM
	#cp -a libDBM.so* $(COCONUT_OPENWRT_DIR)/staging_dir/target-arm_uClibc-0.9.32_eabi/usr/lib
	#cp -a $(LIBDBMSHARED)* $(COCONUT_OPENWRT_DIR)/staging_dir/target-arm_uClibc-0.9.32_eabi/usr/lib
	#cp $(LIBDBMHEADER) $(COCONUT_OPENWRT_DIR)/staging_dir/target-arm_uClibc-0.9.32_eabi/usr/include


shared: 
	$(CC) -shared -Wall -fPIC -c $(LIBDBMSOURCE) -o $(LIBDBMOBJECT)
	$(CC) -shared -W1,-soname,$(LIBDBMEXECUTABLE) -o $(LIBDBMNAME) $(LIBDBMOBJECT)
	#$(INSTALL) -d $(TOPDIR)lib
	#$(RM) $(TOPDIR)lib/$(LIBDBMNAME) $(TOPDIR)lib/$(LIBDBMSHARED).1
	#$(INSTALL) -m 644 $(LIBDBMNAME) $(TOPDIR)lib
	#$(LN) -sf $(LIBDBMNAME) $(TOPDIR)lib/$(LIBDBMSHARED)
	#$(LN) -sf $(LIBDBMNAME) $(TOPDIR)lib/$(LIBDBMSHARED).1
	#cp -a $(LIBDBMSHARED)* $(DONUT_BUILDROOT_DIR)/lib


clean:
	rm -rf $(LIBDBMEXECUTABLE) $(LIBDBMEXECUTABLEA) *.o


