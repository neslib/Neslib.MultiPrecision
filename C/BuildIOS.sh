PLATFORM="iPhoneOS"

DEVELOPER_DIR=`xcode-select -print-path`
if [ ! -d $DEVELOPER_DIR ]; then
  echo "Please set up Xcode correctly. '$DEVELOPER_DIR' is not a valid developer tools folder."
  exit 1
fi

SDK_ROOT=$DEVELOPER_DIR/Platforms/$PLATFORM.platform/Developer/SDKs/$PLATFORM.sdk
if [ ! -d $SDK_ROOT ]; then
  echo "The iOS SDK was not found in $SDK_ROOT."
  exit 1
fi

rm *.o
clang -c -DHP_ARM -O3 -arch arm64 -Wno-absolute-value -isysroot $SDK_ROOT -I . c_dd.cpp c_qd.cpp
ar rcs ../mp_ios64.a *.o
ranlib ../mp_ios64.a

rm *.o
clang -c -DHP_ARM -DHP_ACCURATE -O3 -arch arm64 -Wno-absolute-value -isysroot $SDK_ROOT -I . c_dd.cpp c_qd.cpp
ar rcs ../mp-accurate_ios64.a *.o
ranlib ../mp-accurate_ios64.a