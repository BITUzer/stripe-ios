#!/bin/sh

echo "Checking test manual installation app..."

PROJECTDIR="$(cd $(dirname $0)/../../..; pwd)"
TESTDIR="$(cd $(dirname $0); pwd)"
BUILDDIR="$(cd $(dirname $0); pwd)/build"

rm -rf $BUILDDIR
mkdir $BUILDDIR

xcodebuild build -workspace "${PROJECTDIR}/Stripe.xcworkspace" -scheme StripeiOSStaticFramework -configuration Release OBJROOT=$BUILDDIR SYMROOT=$BUILDDIR -sdk iphonesimulator | xcpretty -c

rm -rf $TESTDIR/ManualInstallationTest/Frameworks
mkdir $TESTDIR/ManualInstallationTest/Frameworks
mv $BUILDDIR/Release-iphonesimulator/Stripe.framework $TESTDIR/ManualInstallationTest/Frameworks
mv $BUILDDIR/Release-iphonesimulator/Stripe.bundle $TESTDIR/ManualInstallationTest/Frameworks/Stripe.framework

set -o pipefail && xcodebuild test -project "${TESTDIR}/ManualInstallationTest.xcodeproj" -scheme ManualInstallationTest -sdk iphonesimulator | xcpretty -c
