#if defined(SIMJECT)

#define currentUser NSHomeDirectory().pathComponents[2]
#import <UIKit/UIFunctions.h>
#define path(path) [UISystemRootDirectory() stringByAppendingPathComponent:path]
#define userPath(path) [NSString stringWithFormat:@"/Users/%@/Library/Developer/CoreSimulator/Devices/%@/data/%@", currentUser, [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].pathComponents[7], [path stringByReplacingOccurrencesOfString:@"/var/mobile/" withString:@""]]

#else
#define path(path) (path)
#define userPath(path) (path)
#endif

extern NSString *const PREFERENCE_BUNDLE_PATH;