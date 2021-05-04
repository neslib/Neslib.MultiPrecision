gcc -m64 -c -o ..\Obj\dd64.obj -I . -Wno-attributes -msse2 -O3 -Xassembler -L c_dd.cpp
gcc -m64 -c -o ..\Obj\dd64-accurate.obj -I . -Wno-attributes -msse2 -DHP_ACCURATE -O3 -Xassembler -L c_dd.cpp

gcc -m64 -c -o ..\Obj\qd64.obj -I . -Wno-attributes -msse2 -O3 -Xassembler -L c_qd.cpp
gcc -m64 -c -o ..\Obj\qd64-accurate.obj -I . -Wno-attributes -msse2 -DHP_ACCURATE -O3 -Xassembler -L c_qd.cpp