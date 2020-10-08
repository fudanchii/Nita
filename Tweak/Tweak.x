#import "Nita.h"

BOOL enabled;

%group Nita

%hook _UIStatusBarCellularSignalView

- (void)didMoveToWindow {

	if (hideCellularSignalSwitch)
		[self setHidden:YES];
	else
		%orig;

}

%end

%hook _UIStatusBarStringView

- (void)setText:(id)arg1 {

	%orig;

	[[PDDokdo sharedInstance] refreshWeatherData];

	// don't replace time
	if (!replaceTimeSwitch && !([[self originalText] containsString:@":"] || [[self originalText] containsString:@"%"] || [[self originalText] containsString:@"2G"] || [[self originalText] containsString:@"3G"] || [[self originalText] containsString:@"4G"] || [[self originalText] containsString:@"5G"] || [[self originalText] containsString:@"LTE"] || [[self originalText] isEqualToString:@"E"] || [[self originalText] isEqualToString:@"e"])) {
		
		[self getEmojis];

		// assign the emoji (and optionally the temperature or only text) to the carrier
		if (showEmojiSwitch && !showTemperatureSwitch)
			%orig(weatherString);
		else if (showEmojiSwitch && showTemperatureSwitch)
			%orig([NSString stringWithFormat:@"%@ %@", weatherString, [[PDDokdo sharedInstance] currentTemperature]]); // that's why i use a variable for the condition, so i can easily add the temperature
		else if (!showEmojiSwitch && showTemperatureSwitch)
			%orig([NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentTemperature]]);
		else
			%orig(conditions);
	}

	// replace time
	if (replaceTimeSwitch && !([[self originalText] containsString:@"%"] || [[self originalText] containsString:@"2G"] || [[self originalText] containsString:@"3G"] || [[self originalText] containsString:@"4G"] || [[self originalText] containsString:@"5G"] || [[self originalText] containsString:@"LTE"] || [[self originalText] isEqualToString:@"E"] || [[self originalText] isEqualToString:@"e"])) {
		
		[self getEmojis];

		// assign the emoji (and optionally the temperature or only text) to the carrier
		if (showEmojiSwitch && !showTemperatureSwitch)
			%orig(weatherString);
		else if (showEmojiSwitch && showTemperatureSwitch)
			%orig([NSString stringWithFormat:@"%@ %@", weatherString, [[PDDokdo sharedInstance] currentTemperature]]); // that's why i use a variable for the condition, so i can easily add the temperature
		else if (!showEmojiSwitch && showTemperatureSwitch)
			%orig([NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentTemperature]]);
		else
			%orig(conditions);
	}

}

%new
- (void)getEmojis {

	WALockscreenWidgetViewController* weatherWidget = [[PDDokdo sharedInstance] weatherWidget];
	WAForecastModel* currentModel = [weatherWidget currentForecastModel];
	WACurrentForecast* currentCond = [currentModel currentConditions];
	NSInteger currentCode = [currentCond conditionCode];

	if (currentCode <= 2)
		weatherString = @"🌪";
	else if (currentCode <= 4)
		weatherString = @"⛈";
	else if (currentCode <= 8)
		weatherString = @"🌨";
	else if (currentCode == 9)
		weatherString = @"🌧";
	else if (currentCode == 10)
		weatherString = @"🌨";
	else if (currentCode <= 12)
		weatherString = @"🌧";
	else if (currentCode <= 18)
		weatherString = @"🌨";
	else if (currentCode <= 22)
		weatherString = @"🌫";
	else if (currentCode <= 24)
		weatherString = @"💨";
	else if (currentCode == 25)
		weatherString = @"❄️";
	else if (currentCode == 26)
		weatherString = @"☁️";
	else if (currentCode <= 28)
		weatherString = @"🌥";
	else if (currentCode <= 30)
		weatherString = @"⛅️";
	else if (currentCode <= 32)
		weatherString = @"☀️";
	else if (currentCode <= 34)
		weatherString = @"🌤";
	else if (currentCode == 35)
		weatherString = @"🌧";
	else if (currentCode == 36)
		weatherString = @"🔥";
	else if (currentCode <= 38)
		weatherString = @"🌩";
	else if (currentCode == 39)
		weatherString = @"🌦";
	else if (currentCode == 40)
		weatherString = @"🌧";
	else if (currentCode <= 43)
		weatherString = @"🌨";
	else
		weatherString = @"N/A";

}

%end

// Hide Breadcrumbs

%hook SBDeviceApplicationSceneStatusBarBreadcrumbProvider

+ (BOOL)_shouldAddBreadcrumbToActivatingSceneEntity:(id)arg1 sceneHandle:(id)arg2 withTransitionContext:(id)arg3 {

	if (hideBreadcrumbsSwitch)
		return NO;
	else
		return %orig;

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.nitapreferences"];

  	[preferences registerBool:&enabled default:nil forKey:@"Enabled"];

	if (enabled) {
		// Visibility
		[preferences registerBool:&showEmojiSwitch default:NO forKey:@"showEmoji"];
		[preferences registerBool:&showTemperatureSwitch default:NO forKey:@"showTemperature"];

		// Miscellaneous
		[preferences registerBool:&replaceTimeSwitch default:NO forKey:@"replaceTime"];
		[preferences registerBool:&hideBreadcrumbsSwitch default:YES forKey:@"hideBreadcrumbs"];
		[preferences registerBool:&hideCellularSignalSwitch default:NO forKey:@"hideCellularSignal"];
		
		%init(Nita);
  	}

}