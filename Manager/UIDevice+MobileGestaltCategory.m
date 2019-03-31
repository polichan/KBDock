
#import "UIDevice+MobileGestaltCategory.h"
#import "../KBDockMacro.h"
// #import "libMobileGestalt.h"

@implementation UIDevice (MobileGestalt)

// Mobile Gestalt EquipmentInfo
extern CFTypeRef MGCopyAnswer(CFStringRef);

- (NSString *)UDID {
    NSString *retVal = nil;
    CFTypeRef tmp = MGCopyAnswer(CFSTR("UniqueDeviceID"));
    if (tmp) {
      // 利用 __bridge 桥接 CFTypeRef
        retVal = (__bridge NSString *)tmp;
        CFRelease(tmp);
    }
    return retVal;
}

@end

/*

All Keys:

DieId
SerialNumber
UniqueChipID
WifiAddress
CPUArchitecture
BluetoothAddress
EthernetMacAddress
FirmwareVersion
MLBSerialNumber
ModelNumber
RegionInfo
RegionCode
DeviceClass
ProductType
DeviceName
UserAssignedDeviceName
HWModelStr
SigningFuse
SoftwareBehavior
SupportedKeyboards
BuildVersion
ProductVersion
ReleaseType
InternalBuild
CarrierInstallCapability
IsUIBuild
InternationalMobileEquipmentIdentity
MobileEquipmentIdentifier
DeviceColor
HasBaseband
SupportedDeviceFamilies
SoftwareBundleVersion
SDIOManufacturerTuple
SDIOProductInfo
UniqueDeviceID
InverseDeviceID
ChipID
PartitionType
ProximitySensorCalibration
CompassCalibration
WirelessBoardSnum
BasebandBoardSnum
HardwarePlatform
RequiredBatteryLevelForSoftwareUpdate
IsThereEnoughBatteryLevelForSoftwareUpdate
BasebandRegionSKU
encrypted-data-partition
BasebandKeyHashInformation
SysCfg
DiagData
BasebandFirmwareManifestData
SIMTrayStatus
CarrierBundleInfoArray
AirplaneMode
IsProductTypeValid
BoardId
AllDeviceCapabilities
wi-fi
SBAllowSensitiveUI
green-tea
not-green-tea
AllowYouTube
AllowYouTubePlugin
SBCanForceDebuggingInfo
AppleInternalInstallCapability
HasAllFeaturesCapability
ScreenDimensions
IsSimulator
BasebandSerialNumber
BasebandChipId
BasebandCertId
BasebandSkeyId
BasebandFirmwareVersion
cellular-data
contains-cellular-radio
RegionalBehaviorGoogleMail
RegionalBehaviorVolumeLimit
RegionalBehaviorShutterClick
RegionalBehaviorNTSC
RegionalBehaviorNoWiFi
RegionalBehaviorChinaBrick
RegionalBehaviorNoVOIP
RegionalBehaviorGB18030
RegionalBehaviorAll
ApNonce
*/
