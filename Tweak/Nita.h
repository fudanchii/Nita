#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import "libpddokdo.h"

HBPreferences* preferences;

BOOL dpkgInvalid = NO;

extern BOOL enabled;

// Options
BOOL showEmojiSwitch = NO;
BOOL showTemperatureSwitch = NO;

// Data Refreshing
BOOL refreshWeatherDataControlCenterSwitch = YES;
BOOL refreshWeatherDataNotificationCenterSwitch = NO;
BOOL refreshWeatherDataDisplayWakeSwitch = YES;

@interface _UIStatusBarStringView : UILabel
@property(nonatomic, copy)NSString* originalText;
- (void)enEmojis;
- (void)frEmojis;
@end

@interface SBIconController : UIViewController
@end