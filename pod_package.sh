
#获得当前目录的名字，一般是YTXChartSocket这种
PROJECT_NAME=${PWD##*/}

PACKAGE=$PROJECT_NAME"_SOURCE=1 pod package ${PROJECT_NAME}.podspec --exclude-deps --no-mangle --library --spec-sources=https://gitlab.com/Blade-GitLab/Specs.git,https://cdn.cocoapods.org"

eval $PACKAGE

ret=$?

if [ "$ret" -ne "0" ];then
	exit 1
fi

BINARY_DIR=$(ls -l | grep ^d | grep -o "${PROJECT_NAME}-.*")
cp -rp $BINARY_DIR/ios/ $PROJECT_NAME/lib

rm -rf $BINARY_DIR

# 去除.a armv7s i386的架构
cd $PROJECT_NAME/lib

lipo "lib${PROJECT_NAME}.a" -remove armv7s -remove i386 -output "lib${PROJECT_NAME}.a"
# lipo "lib${PROJECT_NAME}.a" -thin armv7 -output "lib${PROJECT_NAME}-armv7.a"
# lipo "lib${PROJECT_NAME}.a" -thin x86_64 -output "lib${PROJECT_NAME}-x86_64.a"

# lipo -create "lib${PROJECT_NAME}-arm64.a" "lib${PROJECT_NAME}-armv7.a" "lib${PROJECT_NAME}-x86_64.a" -output "lib${PROJECT_NAME}${SUBSPEC_NAME}.a"

# rm -rf "lib${PROJECT_NAME}-arm64.a"
# rm -rf "lib${PROJECT_NAME}-armv7.a"
# rm -rf "lib${PROJECT_NAME}-x86_64.a"
# rm -rf "lib${PROJECT_NAME}.a"

lipo -info "lib${PROJECT_NAME}.a"
echo "copy Success"