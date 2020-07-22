@echo off

if "%1" neq "all" goto :EOF

setlocal

%HOMEDRIVE%

set GOROOT_BOOTSTRAP=%GOROOT%
set TARGET_DIR=%LOCALAPPDATA%\vim-dev_go2go

if not exist %TARGET_DIR% mkdir %TARGET_DIR%

if not exist %TARGET_DIR%\.git (
  git clone --depth 1 --branch dev.go2go --single-branch https://github.com/golang/go.git %TARGET_DIR%
)

cd %TARGET_DIR%\src

git pull
call make.bat

cd ..

set GOROOT=%cd%
set GOBIN=%GOROOT%\bin
set GO111MODULE=on
set PATH=%GOBIN%;%PATH%

cd src\cmd\go2go

go build
go clean -modcache

move go2go.exe %GOBIN%

cd %GOBIN%

go get golang.org/x/tools/gopls@dev.go2go golang.org/x/tools@dev.go2go
go clean -modcache
