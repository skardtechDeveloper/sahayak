#!/bin/bash

# Sahayak AI Assistant Deployment Script
# Author: Sahayak Team
# Description: Deploys Flutter app to Firebase, Play Store, and App Store

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Sahayak Deployment...${NC}"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found. Please install Flutter first.${NC}"
    exit 1
fi

# Check Firebase CLI
if ! command -v firebase &> /dev/null; then
    echo -e "${YELLOW}⚠️ Firebase CLI not found. Installing...${NC}"
    npm install -g firebase-tools
fi

# Function to clean build
clean_build() {
    echo -e "${GREEN}🧹 Cleaning build...${NC}"
    flutter clean
    rm -rf build/
}

# Function to build for Android
build_android() {
    echo -e "${GREEN}🤖 Building Android APK...${NC}"
    
    # Generate keystore if not exists
    if [ ! -f "android/app/key.jks" ]; then
        echo -e "${YELLOW}🔐 Generating keystore...${NC}"
        keytool -genkey -v -keystore android/app/key.jks \
            -keyalg RSA -keysize 2048 -validity 10000 \
            -alias sahayak \
            -storepass sahayak123 -keypass sahayak123 \
            -dname "CN=Sahayak AI, OU=Development, O=Sahayak, L=Kathmandu, ST=Bagmati, C=NP"
    fi
    
    # Build APK
    flutter build apk --release \
        --target-platform android-arm,android-arm64 \
        --split-per-abi
    
    # Build App Bundle
    flutter build appbundle --release
    
    echo -e "${GREEN}✅ Android build completed!${NC}"
}

# Function to build for iOS
build_ios() {
    echo -e "${GREEN}🍎 Building iOS...${NC}"
    
    # Update pod files
    cd ios
    pod install --repo-update
    cd ..
    
    # Build iOS
    flutter build ios --release --no-codesign
    
    echo -e "${GREEN}✅ iOS build completed!${NC}"
}

# Function to deploy to Firebase
deploy_firebase() {
    echo -e "${GREEN}🔥 Deploying to Firebase...${NC}"
    
    # Build web version
    echo -e "${YELLOW}🌐 Building web version...${NC}"
    flutter build web --release
    
    # Deploy to Firebase Hosting
    firebase deploy --only hosting
    
    # Deploy Firestore rules
    firebase deploy --only firestore:rules
    
    # Deploy Storage rules
    firebase deploy --only storage:rules
    
    # Deploy Functions
    echo -e "${YELLOW}⚡ Deploying Cloud Functions...${NC}"
    cd functions
    npm install
    npm run build
    cd ..
    firebase deploy --only functions
    
    echo -e "${GREEN}✅ Firebase deployment completed!${NC}"
}

# Function to deploy to Play Store
deploy_play_store() {
    echo -e "${GREEN}📱 Deploying to Google Play Store...${NC}"
    
    # Check if bundle exists
    if [ ! -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        echo -e "${RED}❌ App bundle not found. Building first...${NC}"
        build_android
    fi
    
    # Upload to Play Store (requires setup)
    echo -e "${YELLOW}📤 Uploading to Play Console...${NC}"
    # Using fastlane (install via: gem install fastlane)
    if command -v fastlane &> /dev/null; then
        cd android
        fastlane supply --aab ../build/app/outputs/bundle/release/app-release.aab \
            --track production \
            --json_key ../play-store-key.json
        cd ..
    else
        echo -e "${YELLOW}⚠️ Fastlane not installed. Manual upload required.${NC}"
        echo -e "📦 App bundle: build/app/outputs/bundle/release/app-release.aab"
    fi
    
    echo -e "${GREEN}✅ Play Store deployment initiated!${NC}"
}

# Function to run tests
run_tests() {
    echo -e "${GREEN}🧪 Running tests...${NC}"
    
    # Run unit tests
    flutter test
    
    # Run integration tests
    flutter drive --target=test_driver/app.dart
    
    echo -e "${GREEN}✅ Tests completed!${NC}"
}

# Function to update version
update_version() {
    echo -e "${GREEN}🔄 Updating version...${NC}"
    
    read -p "Enter new version (e.g., 1.0.1): " NEW_VERSION
    read -p "Enter build number: " BUILD_NUMBER
    
    # Update pubspec.yaml
    sed -i '' "s/version: .*/version: $NEW_VERSION+$BUILD_NUMBER/" pubspec.yaml
    
    # Update Android
    sed -i '' "s/versionName \".*\"/versionName \"$NEW_VERSION\"/" android/app/build.gradle
    sed -i '' "s/versionCode .*/versionCode $BUILD_NUMBER/" android/app/build.gradle
    
    # Update iOS
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION" ios/Runner/Info.plist
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" ios/Runner/Info.plist
    
    echo -e "${GREEN}✅ Version updated to $NEW_VERSION ($BUILD_NUMBER)${NC}"
}

# Main menu
show_menu() {
    echo -e "\n${GREEN}📋 Deployment Menu:${NC}"
    echo "1.  Clean build"
    echo "2.  Build Android"
    echo "3.  Build iOS"
    echo "4.  Deploy to Firebase"
    echo "5.  Deploy to Play Store"
    echo "6.  Run tests"
    echo "7.  Update version"
    echo "8.  Full deployment (All steps)"
    echo "9.  Exit"
    echo -n "Select option: "
}

# Handle selection
handle_selection() {
    case $1 in
        1) clean_build ;;
        2) build_android ;;
        3) build_ios ;;
        4) deploy_firebase ;;
        5) deploy_play_store ;;
        6) run_tests ;;
        7) update_version ;;
        8)
            clean_build
            run_tests
            build_android
            build_ios
            deploy_firebase
            deploy_play_store
            ;;
        9) exit 0 ;;
        *) echo -e "${RED}❌ Invalid option${NC}" ;;
    esac
}

# Run menu
if [ $# -eq 0 ]; then
    while true; do
        show_menu
        read -r OPTION
        handle_selection "$OPTION"
    done
else
    handle_selection "$1"
fi

echo -e "\n${GREEN}🎉 Deployment process completed!${NC}"
echo -e "${YELLOW}📊 Next steps:${NC}"
echo "1. Submit iOS app to App Store Connect"
echo "2. Update Firebase security rules if needed"
echo "3. Monitor app performance in Firebase Console"
echo "4. Set up error reporting with Crashlytics"
echo "5. Configure analytics events"