#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import "libpddokdo.h"

HBPreferences* preferences;

extern BOOL enabled;

// Visibility
BOOL showEmojiSwitch = NO;
BOOL showTemperatureSwitch = NO;

// Miscellaneous
BOOL replaceTimeSwitch = NO;
BOOL hideBreadcrumbsSwitch = YES;
BOOL hideCellularSignalSwitch = YES;

@interface _UIStatusBarStringView : UILabel
@property(nonatomic, copy)NSString* originalText;
- (void)enEmojis;
- (void)frEmojis;
- (void)deEmojis;
@end

@interface _UIStatusBarCellularSignalView : UIView
@end