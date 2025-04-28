```
$ make
iccarm --silent --no_wrap_diagnostics -e --cpu=cortex-m4 -r -DUSE_HAL_DRIVER main.c --dependencies=m bin/main.d -o bin/main.o
iccarm --silent --no_wrap_diagnostics -e --cpu=cortex-m4 -r -DUSE_HAL_DRIVER caller.c --dependencies=m bin/caller.d -o bin/caller.o
iccarm --silent --no_wrap_diagnostics -e --cpu=cortex-m4 -r -DUSE_HAL_DRIVER callee.c --dependencies=m bin/callee.d -o bin/callee.o
iasmarm -S -s+ -w+ --cpu=cortex-m4 -r foo.s -y bin/foo.d -Obin
-- Linking bin/firmware.out...
ilinkarm --silent --config generic.icf --map bin bin/main.o bin/caller.o bin/callee.o bin/foo.o -o bin/firmware.out
-- Converting bin/firmware.out to bin/firmware.hex...
ielftool --silent --ihex bin/firmware.out bin/firmware.hex
-- Converting bin/firmware.out to bin/firmware.bin...
ielftool --silent --bin bin/firmware.out bin/firmware.bin
-- All done.
```
