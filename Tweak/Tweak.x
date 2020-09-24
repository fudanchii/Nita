#import "Nita.h"

BOOL enabled;

NSString* conditions = nil; // weather condition which will be converted to an emoji
NSString* weatherString = nil; // emoji will be assigned to this variable
NSString* languageCode = nil; // language code to detect device language

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
		// detect device language and convert current condition to emoji
		if ([languageCode containsString:@"en"])
			[self enEmojis];
		else if ([languageCode containsString:@"fr"])
			[self frEmojis];
		else if ([languageCode containsString:@"de"])
			[self deEmojis];

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
		// detect device language and convert current condition to emoji
		if ([languageCode containsString:@"en"])
			[self enEmojis];
		else if ([languageCode containsString:@"fr"])
			[self frEmojis];
		else if ([languageCode containsString:@"de"])
			[self deEmojis];

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

// libPDDokdo currently only returns the condition in the language which the device has set so i have to convert it myself

// English
%new
- (void)enEmojis {

	conditions = [[PDDokdo sharedInstance] currentConditions];

	// Sunny
	if ([conditions containsString:@"sun"] || [conditions containsString:@"Sun"]) {
		if ([conditions isEqualToString:@"Sunny"])
			weatherString = @"☀️";
		else if ([conditions isEqualToString:@"Mostly Sunny"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Clear
	if ([conditions containsString:@"clear"] || [conditions containsString:@"Clear"]) {
		if ([conditions isEqualToString:@"Clear"])
			weatherString = @"☀";
		else if ([conditions isEqualToString:@"Mostly Clear"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Cloudy
	if ([conditions containsString:@"cloud"] || [conditions containsString:@"Cloud"]) {
		if ([conditions isEqualToString:@"Cloudy"])
			weatherString = @"☁️";
		else if ([conditions isEqualToString:@"Mostly Cloudy"])
			weatherString = @"🌥";
		else if ([conditions isEqualToString:@"Partly Cloudy"])
			weatherString = @"🌤";
		else
			weatherString = @"☁️";
		return;
	}

	// Rain
	if ([conditions containsString:@"showers"] || [conditions containsString:@"Showers"] || [conditions containsString:@"rain"] || [conditions containsString:@"Rain"]) {
		if ([conditions isEqualToString:@"Showers"])
			weatherString = @"🌧";
		else if ([conditions containsString:@"Rain"] || [conditions containsString:@"rain"])
			weatherString = @"🌧";
		else if ([conditions isEqualToString:@"Thundershowers"])
			weatherString = @"⛈";
		else
			weatherString = @"🌦";
		return;
	}

	// Snow
	if ([conditions containsString:@"snow"] || [conditions containsString:@"Snow"]) {
		weatherString = @"🌨";
		return;
	}

	// Thunderstorms
	if ([conditions containsString:@"thunder"] || [conditions containsString:@"Thunder"]) {
		if ([conditions isEqualToString:@"Thundershowers"])
			weatherString = @"⛈";
		else if ([conditions containsString:@"Thunder"])
			weatherString = @"⛈";
		else
			weatherString = @"⛈";
		return;
	}

	// Tornado
	if ([conditions containsString:@"tornado"] || [conditions containsString:@"Tornado"]) {
		if ([conditions isEqualToString:@"Tornado"])
			weatherString = @"🌪";
		else
			weatherString = @"🌪";
		return;
	}

	// Fog
	if ([conditions containsString:@"fog"] || [conditions containsString:@"Fog"]) {
		weatherString = @"🌫";
		return;
	}

	// Bad Air Quality
	if ([conditions containsString:@"Unhealthy Air Quality"]) {
		weatherString = @"🌫";
		return;
	}

}

// French
%new
- (void)frEmojis {

	conditions = [[PDDokdo sharedInstance] currentConditions];

	// Sunny
	if ([conditions containsString:@"Ensoleillé"] || [conditions containsString:@"ensoleillé"]) {
		if ([conditions isEqualToString:@"Ensoleillé"])
			weatherString = @"☀️";
		else if ([conditions isEqualToString:@"Plutôt ensoleillé"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Clear
	if ([conditions containsString:@"Dégagé"] || [conditions containsString:@"dégagé"]) {
		if ([conditions isEqualToString:@"Dégagé"])
			weatherString = @"☀";
		else if ([conditions isEqualToString:@"Ciel plutôt dégagé"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Cloudy
	if ([conditions containsString:@"Nuage"] || [conditions containsString:@"nuage"] || [conditions containsString:@"Belles éclaircies"]) {
		if ([conditions isEqualToString:@"Nuageux"])
			weatherString = @"☁️";
		else if ([conditions isEqualToString:@"Nuages prédominants"])
			weatherString = @"🌥";
		else if ([conditions isEqualToString:@"Quelques nuages"])
			weatherString = @"🌤";
		else if  ([conditions isEqualToString:@"Belles éclaircies"])
			weatherString = @"🌤";
		else
			weatherString = @"☁️";
		return;
	}

	// Rain
	if ([conditions containsString:@"pluie"] || [conditions containsString:@"Pluie"] || [conditions containsString:@"averses"] || [conditions containsString:@"Averses"]) {
		if ([conditions isEqualToString:@"Averses"])
			weatherString = @"🌧";
		else if ([conditions isEqualToString:@"Averses orageuses"])
			weatherString = @"⛈";
		else if ([conditions isEqualToString:@"Pluie"])
			weatherString = @"🌧";
		else
			weatherString = @"🌦";
		return;
	}

	// Snow
	if ([conditions containsString:@"neige"] || [conditions containsString:@"Neige"]) {
		weatherString = @"🌨";
		return;
	}

	// Thunderstorms
	if ([conditions containsString:@"orage"] || [conditions containsString:@"Orage"]) {
		if ([conditions containsString:@"Orages"])
			weatherString = @"⛈";
		else
			weatherString = @"⛈";
		return;
	}

	// Tornado
	if ([conditions containsString:@"tornade"] || [conditions containsString:@"Tornade"]) {
		if ([conditions isEqualToString:@"Tornade"])
			weatherString = @"🌪";
		else
			weatherString = @"🌪";
		return;
	}

	// Fog
	if ([conditions containsString:@"brouillard"] || [conditions containsString:@"Brouillard"]) {
		weatherString = @"🌫";
		return;
	}

	// Bad Air Quality
	if ([conditions containsString:@"Qualité de l'air"]) {
		weatherString = @"🌫";
		return;
	}

}

// German
%new
- (void)deEmojis {

	conditions = [[PDDokdo sharedInstance] currentConditions];

	// Sunny
	if ([conditions containsString:@"sonn"] || [conditions containsString:@"Sonn"]) {
		if ([conditions isEqualToString:@"Sonnig"])
			weatherString = @"☀️";
		else if ([conditions isEqualToString:@"Meist sonnig"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Clear
	if ([conditions containsString:@"wolken"] || [conditions containsString:@"Wolken"]) {
		if ([conditions isEqualToString:@"Wolkenlos"])
			weatherString = @"☀";
		else if ([conditions isEqualToString:@"Meist Wolkenlos"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Cloudy
	if ([conditions containsString:@"wölkt"]) {
		if ([conditions isEqualToString:@"Bewölkt"])
			weatherString = @"☁️";
		else if ([conditions isEqualToString:@"Meist bewölkt"])
			weatherString = @"🌥";
		else if ([conditions isEqualToString:@"Teilweise bewölkt"])
			weatherString = @"🌤";
		else
			weatherString = @"☁️";
		return;
	}

	// Rain
	if ([conditions containsString:@"regen"] || [conditions containsString:@"Regen"] || [conditions containsString:@"schauer"] || [conditions containsString:@"Schauer"]) {
		if ([conditions isEqualToString:@"Regen"])
			weatherString = @"🌧";
		else if ([conditions isEqualToString:@"Schauer"])
			weatherString = @"🌧";
		else
			weatherString = @"🌦";
		return;
	}

	// Snow
	if ([conditions containsString:@"schnee"] || [conditions containsString:@"Schnee"]) {
		weatherString = @"🌨";
		return;
	}

	// Thunderstorms
	if ([conditions containsString:@"gewitter"] || [conditions containsString:@"Gewitter"]) {
		if ([conditions containsString:@"Gewitter"])
			weatherString = @"⛈";
		else
			weatherString = @"⛈";
		return;
	}

	// Tornado
	if ([conditions containsString:@"wirbelsturm"] || [conditions containsString:@"Wirbelsturm"]) {
		if ([conditions isEqualToString:@"Wirbelsturm"])
			weatherString = @"🌪";
		else
			weatherString = @"🌪";
		return;
	}

	// Fog
	if ([conditions containsString:@"nebel"] || [conditions containsString:@"Nebel"]) {
		if ([conditions isEqualToString:@"Nebel"])
			weatherString = @"🌫";
		else
			weatherString = @"🌫";
		return;
	}

	// Bad Air Quality
	if ([conditions containsString:@"Ungesunde Luftqualität"]) {
		weatherString = @"🌫";
		return;
	}

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

	// Visibility
	[preferences registerBool:&showEmojiSwitch default:NO forKey:@"showEmoji"];
	[preferences registerBool:&showTemperatureSwitch default:NO forKey:@"showTemperature"];

	// Miscellaneous
	[preferences registerBool:&replaceTimeSwitch default:NO forKey:@"replaceTime"];
	[preferences registerBool:&hideBreadcrumbsSwitch default:YES forKey:@"hideBreadcrumbs"];
	[preferences registerBool:&hideCellularSignalSwitch default:NO forKey:@"hideCellularSignal"];

	if (enabled) {
		NSLocale* locale = [NSLocale autoupdatingCurrentLocale];
		languageCode = locale.languageCode;
		%init(Nita);
        return;
    }

}