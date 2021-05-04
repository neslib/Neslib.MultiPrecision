@echo off

REM Set this variable to the location of ndk-build.cmd
REM Tested with NDK version 17c.
set NDK_BUILD=e:\android-ndk-r17c\ndk-build.cmd

REM Name of generated static library
set LIB32=obj\local\armeabi-v7a\libmp-android.a
set LIB64=obj\local\arm64-v8a\libmp-android.a

if not exist %NDK_BUILD% (
  echo Cannot find ndk-build. Check the NDK_BUILD variable.
  exit /b
)

REM Build "normal" version
REM ======================

REM Run ndk-build to build static library
call %NDK_BUILD% -B

if not exist %LIB32% (
  echo Cannot find static library %LIB32%
  exit /b
)

if not exist %LIB64% (
  echo Cannot find static library %LIB64%
  exit /b
)

REM Copy static library to directory with Delphi source code
copy %LIB32% ..\libmp_android32.a
if %ERRORLEVEL% NEQ 0 (
  echo Cannot copy static library. Make sure it is not write protected
)

copy %LIB64% ..\libmp_android64.a
if %ERRORLEVEL% NEQ 0 (
  echo Cannot copy static library. Make sure it is not write protected
)

REM Build "accurate" version
REM ========================

REM Run ndk-build to build static library
set MP_ACCURATE=true
call %NDK_BUILD% -B
set MP_ACCURATE=

if not exist %LIB32% (
  echo Cannot find static library %LIB32%
  exit /b
)

REM Copy static library to directory with Delphi source code
copy %LIB32% ..\libmp-accurate_android32.a
if %ERRORLEVEL% NEQ 0 (
  echo Cannot copy static library. Make sure it is not write protected
)

copy %LIB64% ..\libmp-accurate_android64.a
if %ERRORLEVEL% NEQ 0 (
  echo Cannot copy static library. Make sure it is not write protected
)

del %LIB32%
del %LIB64%