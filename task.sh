# For your convenience 
alias PlistBuddy=/usr/libexec/PlistBuddy

INFO_PLIST="./CatsAndModules_IrynaNazar/Info.plist"
PARAM=$1
WORKSPACE=CatsAndModules_IrynaNazar.xcodeproj
SCHEME=CatsAndModules_IrynaNazar
CONFIG=Debug
DEST="generic/platform=iOS"
VERSION="v1.0.0"
ARCHIVE_PATH="./ARCHIVES/${VERSION}.xcarchive"
EXPORT_PATH="./Exported"
PLIST="exportOptions.plist"



cp exportOptionsTemplate.plist $PLIST

PlistBuddy -c "set :destination export" $PLIST
PlistBuddy -c "set :method development" $PLIST
PlistBuddy -c "set :signingStyle automatic" $PLIST
PlistBuddy -c "set :teamID GDT3GT22C8" $PLIST
PlistBuddy -c "set :signingCertificate Apple Development: iranazar1999@icloud.com (25P99XS8MB)" $PLIST
PlistBuddy -c "delete :provisioningProfiles:%BUNDLE_ID%" $PLIST
PlistBuddy -c "add :provisioningProfiles:ira.nazar.CatsAndModules-IrynaNazar string 2fea7968-7e02-4e17-babd-a9133c9704ff" $PLIST
#


# IMPLEMENT:
# Read script input parameter and add it to your Info.plist. Values can either be CATS or DOGS
if [ "$PARAM" == "CATS" ]; then
PlistBuddy -c "set :App Type CATS" $INFO_PLIST
EXPORT_PATH="${EXPORTED_PATH}_CATS"
elif [ "$PARAM" == "DOGS" ]; then
PlistBuddy -c "set :App Type" DOGS" $INFO_PLIST
EXPORT_PATH="${EXPORTED_PATH}_DOGS"
else
exit 1
fi


# IMPLEMENT:
# Clean build folder
xcodebuild clean -project "${WORKSPACE}" -scheme "${SCHEME}" -configuration "${CONFIG}"


# IMPLEMENT:
# Create archive

xcodebuild archive \
-archivePath "${ARCHIVE_PATH}" \
-project "${WORKSPACE}" \
-scheme "${SCHEME}" \
-configuration "${CONFIG}" \
-destination "${DEST}"

# IMPLEMENT:
# Export archive

xcodebuild -exportArchive \
-archivePath "${ARCHIVE_PATH}" \
-exportPath "${EXPORT_PATH}" \
-exportOptionsPlist "${PLIST}"


rm -f "$PLIST"

echo "script completed"
