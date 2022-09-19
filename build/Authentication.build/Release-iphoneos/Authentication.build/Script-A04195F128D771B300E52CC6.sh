#!/bin/sh
# Type a script or drag a script file from your workspace to insert its path.
mkdir ./arm64
mkdir ./x86_64

find "./" -name '*.framework' -type d | while read -r FRAMEWORK
do
    echo "Preparing framework: $FRAMEWORK"
    FRAMEWORK_EXECUTABLE_NAME=$(/usr/libexec/PlistBuddy -c "Print CFBundleExecutable" "$FRAMEWORK/Info.plist")
    
    echo "Preparing arm64 framework"
    cp -R "$FRAMEWORK" "./arm64/$FRAMEWORK_EXECUTABLE_NAME.framework"
    rm "./arm64/$FRAMEWORK_EXECUTABLE_NAME.framework/$FRAMEWORK_EXECUTABLE_NAME"
    $(/usr/libexec/PlistBuddy -c "Set CFBundleSupportedPlatforms iPhoneOS" "./arm64/$FRAMEWORK_EXECUTABLE_NAME.framework/Info.plist")
    
    echo "Extracting arm64 from $FRAMEWORK_EXECUTABLE_NAME"
    lipo -extract "arm64" "$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME" -o "./arm64/$FRAMEWORK_EXECUTABLE_NAME.framework/$FRAMEWORK_EXECUTABLE_NAME"
    
    echo "Preparing x86_64 framework"
    cp -R "$FRAMEWORK" "./x86_64/$FRAMEWORK_EXECUTABLE_NAME.framework"
    rm "./x86_64/$FRAMEWORK_EXECUTABLE_NAME.framework"
    $(/usr/libexec/PlistBuddy -c "Set CFBundleSupportedPlatforms iPhoneSimulator" "./x86_64/$FRAMEWORK_EXECUTABLE_NAME.framework/Info.plist")
    
    echo "Extracting x86_64 from $FRAMEWORK_EXECUTABLE_NAME"
    lipo -extract "x86_64" "$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME" -o "./x86_64/$FRAMEWORK_EXECUTABLE_NAME.framework/$FRAMEWORK_EXECUTABLE_NAME"
    
    xcodebuild -create-xcframework -framework "./arm64/$FRAMEWORK_EXECUTABLE_NAME.framework" -framework "./x86_64/$FRAMEWORK_EXECUTABLE_NAME.framework" -output "$FRAMEWORK_EXECUTABLE_NAME.xcframework" || exit -1
done

rm -r ./arm64
rm -r ./x86_64

