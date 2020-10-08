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
- (void)getEmojis;
@end

@interface _UIStatusBarCellularSignalView : UIView
@end

/*
Weather Codes:

Nita - currentCode = 0, currentCondition = Wirbelsturm
Nita - currentCode = 1, currentCondition = Tropensturm
Nita - currentCode = 2, currentCondition = Orkan
Nita - currentCode = 3, currentCondition = Heftiges Gewitter
Nita - currentCode = 4, currentCondition = Gewitter
Nita - currentCode = 5, currentCondition = Schneeregen
Nita - currentCode = 6, currentCondition = Eisregen
Nita - currentCode = 7, currentCondition = Schnee- und Eisregen
Nita - currentCode = 8, currentCondition = Gefrierender Nieselregen
Nita - currentCode = 9, currentCondition = Nieselregen
Nita - currentCode = 10, currentCondition = Gefrierender Regen
Nita - currentCode = 11, currentCondition = Schauer
Nita - currentCode = 12, currentCondition = Regen
Nita - currentCode = 13, currentCondition = Schneegestöber
Nita - currentCode = 14, currentCondition = Schneeschauer
Nita - currentCode = 15, currentCondition = Schneetreiben
Nita - currentCode = 16, currentCondition = Schnee
Nita - currentCode = 17, currentCondition = Hagel
Nita - currentCode = 18, currentCondition = Graupel
Nita - currentCode = 19, currentCondition = Staub
Nita - currentCode = 20, currentCondition = Nebel
Nita - currentCode = 21, currentCondition = Dunst
Nita - currentCode = 22, currentCondition = Rauch
Nita - currentCode = 23, currentCondition = Leichter Wind
Nita - currentCode = 24, currentCondition = Windig
Nita - currentCode = 25, currentCondition = Kalt
Nita - currentCode = 26, currentCondition = Bewölkt
Nita - currentCode = 27, currentCondition = Meist bewölkt
Nita - currentCode = 28, currentCondition = Meist bewölkt
Nita - currentCode = 29, currentCondition = Teilweise bewölkt
Nita - currentCode = 30, currentCondition = Teilweise bewölkt
Nita - currentCode = 31, currentCondition = Wolkenlos
Nita - currentCode = 32, currentCondition = Sonnig
Nita - currentCode = 33, currentCondition = Meist wolkenlos
Nita - currentCode = 34, currentCondition = Meist sonnig
Nita - currentCode = 35, currentCondition = Regengemisch
Nita - currentCode = 36, currentCondition = Heiß
Nita - currentCode = 37, currentCondition = Örtliche Gewitter
Nita - currentCode = 38, currentCondition = Vereinzelte Gewitter
Nita - currentCode = 39, currentCondition = Vereinzelte Schauer
Nita - currentCode = 40, currentCondition = Starker Regen
Nita - currentCode = 41, currentCondition = Vereinzelte Schneeschauer
Nita - currentCode = 42, currentCondition = Starker Schneefall
Nita - currentCode = 43, currentCondition = Schneesturm


*/