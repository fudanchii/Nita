#import <UIKit/UIKit.h>
#import "libpddokdo.h"

@interface _UIStatusBarStringView : UIView
@property(nonatomic, copy)NSString* originalText;
@end

%group Nita

%hook _UIStatusBarStringView

- (void)setText:(id)arg1 {

	%orig;

	// there may be a better way to do this but it works
	if (!([[self originalText] containsString:@":"] || [[self originalText] containsString:@"%"] || [[self originalText] containsString:@"3G"] || [[self originalText] containsString:@"4G"] || [[self originalText] containsString:@"LTE"])) {
		[[PDDokdo sharedInstance] refreshWeatherData];
		NSString* conditions = [[PDDokdo sharedInstance] currentConditions];

		%orig(conditions);

		// if ([conditions isEqualToString:@"Sunny"]) %orig(@"☀️");
		// if ([conditions isEqualToString:@"Mostly Cloudy"]) %orig(@"🌥");
		// if ([conditions isEqualToString:@"Cloudy"]) %orig(@"☁️");
		// if ([conditions isEqualToString:@"Raining"]) %orig(@"🌧");

	} else {
		%orig;
	}

}

%end

%end

%ctor {

	%init(Nita);

}