PLATFORM="MacOSX"

DEVELOPER_DIR=`xcode-select -print-path`
if [ ! -d $DEVELOPER_DIR ]; then
  echo "Please set up Xcode correctly. '$DEVELOPER_DIR' is not a valid developer tools folder."
  exit 1
fi

SDK_ROOT=$DEVELOPER_DIR/Platforms/$PLATFORM.platform/Developer/SDKs/$PLATFORM.sdk
if [ ! -d $SDK_ROOT ]; then
  echo "The MacOSX SDK was not found in $SDK_ROOT."
  exit 1
fi

rm *.o
clang -c -fPIC -O3 -Wno-absolute-value -isysroot $SDK_ROOT -I . -Xassembler -L c_dd.cpp c_qd.cpp
ar rcs ../mp_mac64.a *.o
ranlib ../mp_mac64.a

rm *.o
clang -c -fPIC -DHP_ACCURATE -O3 -Wno-absolute-value -isysroot $SDK_ROOT -I . -Xassembler -L c_dd.cpp c_qd.cpp
ar rcs ../mp-accurate_mac64.a *.o
ranlib ../mp-accurate_mac64.a

rm *.o