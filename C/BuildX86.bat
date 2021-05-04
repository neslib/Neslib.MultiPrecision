gcc -m32 -c -o ..\Obj\dd32.obj -I . -Wno-attributes -mfpmath=sse -msse2 -O3 -mincoming-stack-boundary=2 -Xassembler -L c_dd.cpp
gcc -m32 -c -o ..\Obj\dd32-accurate.obj -I . -Wno-attributes -mfpmath=sse -msse2 -DHP_ACCURATE -O3 -mincoming-stack-boundary=2 -Xassembler -L c_dd.cpp

gcc -m32 -c -o ..\Obj\qd32.obj -I . -Wno-attributes -mfpmath=sse -msse2 -O3 -mincoming-stack-boundary=2 -Xassembler -L c_qd.cpp
gcc -m32 -c -o ..\Obj\qd32-accurate.obj -I . -Wno-attributes -mfpmath=sse -msse2 -DHP_ACCURATE -O3 -mincoming-stack-boundary=2 -Xassembler -L c_qd.cpp