#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import "libpddokdo.h"

HBPreferences* preferences;

BOOL dpkgInvalid = NO;

extern BOOL enabled;

// Visibility
BOOL showEmojiSwitch = NO;
BOOL showTemperatureSwitch = NO;

// Miscellaneous
BOOL hideBreadcrumbsSwitch = YES;
BOOL hideCellularSignalSwitch = YES;

// Data Refreshing
BOOL refreshWeatherDataControlCenterSwitch = YES;
BOOL refreshWeatherDataNotificationCenterSwitch = NO;
BOOL refreshWeatherDataDisplayWakeSwitch = YES;

@interface _UIStatusBarStringView : UILabel
@property(nonatomic, copy)NSString* originalText;
- (void)enEmojis;
- (void)frEmojis;
- (void)deEmojis;
@end

@interface _UIStatusBarCellularSignalView : UIView
@end

@interface SBIconController : UIViewController
@end