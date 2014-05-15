/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#import "BPXLUUIDHandler.h"
#import "UIDevice+Hardware.h"
#import "UIDevice+MKAdditions.h"

#define kDeviceIdUserDefaultsIdentifier @"DeviceIdUserDefaultsIdentifier"
#define kDeviceIdDejavuIdentifier @"DeviceIdDejavuIdentifier"

@implementation UIDevice (Hardware)
#pragma mark deviceID & fingerPrint

-(NSArray *)devicesID{
    NSString *systemVersionString = [[UIDevice currentDevice] systemVersion];
    NSInteger systemVersion = [[[systemVersionString componentsSeparatedByString:@"."] objectAtIndex:0] floatValue];
    if (systemVersion < 6) {
        return @[@{@"name":@"uuid",
                   @"value":[BPXLUUIDHandler UUID]}];
    }else{
        return @[@{@"name": @"vendor_id",
                   @"value": [[[UIDevice currentDevice] identifierForVendor]UUIDString]},
                 @{@"name":@"uuid",
                   @"value":[BPXLUUIDHandler UUID]}];
    }
}

-(NSString *)deviceID{
    return [BPXLUUIDHandler UUID];
}


- (NSDictionary *)fingerPrint{
    UIDevice *device = [UIDevice currentDevice];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[self devicesID] forKey:@"vendor_ids"];

    if (![MLUtil isNullOrEmpty:device.hwmodel]) {
        [dictionary setObject:device.hwmodel forKey:@"model"];
    }
    [dictionary setObject:@"iOS" forKey:@"os"];
    if (![MLUtil isNullOrEmpty:device.systemVersion]) {
        [dictionary setObject:device.systemVersion forKey:@"system_version"];
    }
    
    [dictionary setObject:[NSString stringWithFormat:@"%.0fx%.0f",[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height] forKey:@"resolution"];
    
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:device.totalMemory] forKey:@"ram"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:device.totalDiskSpace] forKey:@"disk_space"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:device.freeDiskSpace] forKey:@"free_disk_space"];

    NSMutableDictionary *moreData= [NSMutableDictionary new];

    [moreData setObject:[NSNumber numberWithBool:device.cameraAvailable] forKey:@"feature_camera"];
    [moreData setObject:[NSNumber numberWithBool:device.cameraFlashAvailable] forKey:@"feature_flash"];
    [moreData setObject:[NSNumber numberWithBool:device.frontCameraAvailable] forKey:@"feature_front_camera"];

    [moreData setObject:[NSNumber numberWithBool:device.videoCameraAvailable] forKey:@"video_camera_available"];
    [moreData setObject:[NSNumber numberWithUnsignedInteger:device.cpuCount] forKey:@"cpu_count"];
    [moreData setObject:[NSNumber numberWithBool:device.retinaDisplayCapable] forKey:@"retina_display_capable"];
    
    [moreData setObject:(device.userInterfaceIdiom?@"Pad":@"Phone") forKey:@"device_idiom"];
    [moreData setObject:[NSNumber numberWithBool:device.canSendSMS] forKey:@"can_send_sms"];
    if ([[NSLocale preferredLanguages] count]) {
        [moreData setObject:[NSLocale preferredLanguages][0] forKey:@"device_languaje"];
    }
    if (![MLUtil isNullOrEmpty:device.model]) {
        [moreData setObject:device.model forKey:@"device_model"]; 
    }
    [moreData setObject:[NSNumber numberWithBool:device.canMakePhoneCalls] forKey:@"can_make_phone_calls"];
    if (![MLUtil isNullOrEmpty:device.platform]) {
        [moreData setObject:device.platform forKey:@"platform"];
    }
    [moreData setObject:[NSNumber numberWithInteger:device.deviceFamily] forKey:@"device_family"];
    if (![MLUtil isNullOrEmpty:device.name]) {
        [moreData setObject:device.name forKey:@"device_name"];
    }
    BOOL simulator = NO;
#if TARGET_IPHONE_SIMULATOR
    simulator = YES;
#endif
    [moreData setObject:[NSNumber numberWithBool:simulator] forKey:@"simulator"];

    [dictionary setObject:moreData forKey:@"vendor_specific_attributes"];
    return dictionary;
}


/*
 Platforms
 
 iFPGA ->        ??
 
 iPhone1,1 ->    iPhone 1G, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/AT&T, N89
 iPhone3,2 ->    iPhone 4/Other Carrier?, ??
 iPhone3,3 ->    iPhone 4/Verizon, TBD
 iPhone4,1 ->    (iPhone 4S/GSM), TBD
 iPhone4,2 ->    (iPhone 4S/CDMA), TBD
 iPhone4,3 ->    (iPhone 4S/???)
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 
 iPod1,1   ->    iPod touch 1G, N45
 iPod2,1   ->    iPod touch 2G, N72
 iPod2,2   ->    Unknown, ??
 iPod3,1   ->    iPod touch 3G, N18
 iPod4,1   ->    iPod touch 4G, N80
 
 // Thanks NSForge
 iPad1,1   ->    iPad 1G, WiFi and 3G, K48
 iPad2,1   ->    iPad 2G, WiFi, K93
 iPad2,2   ->    iPad 2G, GSM 3G, K94
 iPad2,3   ->    iPad 2G, CDMA 3G, K95
 iPad3,1   ->    (iPad 3G, WiFi)
 iPad3,2   ->    (iPad 3G, GSM)
 iPad3,3   ->    (iPad 3G, CDMA)
 iPad4,1   ->    (iPad 4G, WiFi)
 iPad4,2   ->    (iPad 4G, GSM)
 iPad4,3   ->    (iPad 4G, CDMA)
 
 AppleTV2,1 ->   AppleTV 2, K66
 AppleTV3,1 ->   AppleTV 3, ??
 
 i386, x86_64 -> iPhone Simulator
 */


#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
 */

- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])            return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])            return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])            return UIDevice4SiPhone;
    if ([platform hasPrefix:@"iPhone5"]){
        if ([platform hasSuffix:@"1"] || [platform hasSuffix:@"2"])return UIDevice5iPhone;
        else return UIDevice5CiPhone;
    }
    if ([platform hasPrefix:@"iPhone6"])            return UIDevice5SiPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return UIDevice4GiPod;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2"])              return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])              return UIDevice3GiPad;
    if ([platform hasPrefix:@"iPad4"])              return UIDevice4GiPad;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
        case UIDevice4SiPhone: return IPHONE_4S_NAMESTRING;
        case UIDevice5iPhone: return IPHONE_5_NAMESTRING;
        case UIDevice5CiPhone: return IPHONE_5C_NAMESTRING;
        case UIDevice5SiPhone: return IPHONE_5S_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad : return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad : return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad : return IPAD_3G_NAMESTRING;
        case UIDevice4GiPad : return IPAD_4G_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceAppleTV3 : return APPLETV_3G_NAMESTRING;
        case UIDeviceAppleTV4 : return APPLETV_4G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
            
        case UIDeviceSimulator: return SIMULATOR_NAMESTRING;
        case UIDeviceSimulatoriPhone: return SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceSimulatoriPad: return SIMULATOR_IPAD_NAMESTRING;
        case UIDeviceSimulatorAppleTV: return SIMULATOR_APPLETV_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

- (BOOL) hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale == 2.0f);
}

- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

#pragma mark IP addy
- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}


//- (void)showHardwareData{
//    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:textView];
//    UIDevice *device = [UIDevice currentDevice];
//    
//    NSString *text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",
//                      [NSString stringWithFormat:@"cameraAvailable: %d",device.cameraAvailable],
//                      [NSString stringWithFormat:@"videoCameraAvailable: %d",device.videoCameraAvailable],
//                      [NSString stringWithFormat:@"frontCameraAvailable: %d",device.frontCameraAvailable],
//                      [NSString stringWithFormat:@"cameraFlashAvailable: %d",device.cameraFlashAvailable],
//                      [NSString stringWithFormat:@"canSendSMS: %d",device.canSendSMS],
//                      [NSString stringWithFormat:@"canMakePhoneCalls: %d",device.canMakePhoneCalls],
//                      [NSString stringWithFormat:@"retinaDisplayCapable: %d",device.retinaDisplayCapable],
//                      [NSString stringWithFormat:@"platform: %@",device.platform],
//                      [NSString stringWithFormat:@"hwmodel: %@",device.hwmodel],
//                      [NSString stringWithFormat:@"platformType: %d",device.platformType],
//                      [NSString stringWithFormat:@"platformString: %@",device.platformString],
//                      [NSString stringWithFormat:@"cpuFrequency: %d",device.cpuFrequency],
//                      [NSString stringWithFormat:@"busFrequency: %d",device.busFrequency],
//                      [NSString stringWithFormat:@"cpuCount: %d",device.cpuCount],
//                      [NSString stringWithFormat:@"totalMemory: %d",device.totalMemory],
//                      [NSString stringWithFormat:@"totalDiskSpace: %@",device.totalDiskSpace],
//                      [NSString stringWithFormat:@"macaddress: %@",device.macaddress],
//                      [NSString stringWithFormat:@"deviceFamily: %d",device.deviceFamily],
//                      [[UIDevice currentDevice]name],
//                      [[UIDevice currentDevice]model],
//                      [NSString stringWithFormat:@"%d",[[UIDevice currentDevice]userInterfaceIdiom]],
//                      [[UIDevice currentDevice]identifierForVendor],
//                      [NSLocale preferredLanguages][0],
//                      NSStringFromCGRect([[UIScreen mainScreen] bounds])
//                      ];
//    textView.text = text;
//}

@end