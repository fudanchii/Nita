#import "Nita.h"

BOOL enabled;

NSString* conditions;
NSString* weatherString = nil; // emoji will be assigned to this variable

%group Nita

%hook _UIStatusBarStringView

- (void)setText:(id)arg1 {

	%orig; // making sure originalText is being initialized before comparing it

	// there might be a better way to do this but it works
	if (!([[self originalText] containsString:@":"] || [[self originalText] containsString:@"%"] || [[self originalText] containsString:@"3G"] || [[self originalText] containsString:@"4G"] || [[self originalText] containsString:@"LTE"]) && enabled) {

		// detect device language and convert current condition to emoji
		// if ([[[NSLocale preferredLanguages] firstObject] isEqual:@"en"]) {
			[self frEmojis];
		// } else if ([[[NSLocale preferredLanguages] firstObject] isEqual:@"fr"]) {
		// 	[self frEmojis];
		// } else { // if nita doesn't support the device language return the original text
		// 	%orig;
		// 	return;
		// }

		// assign the emoji (and optionally the temperature) to the carrier
		if (showEmojiSwitch && !showTemperatureSwitch)
			%orig(weatherString);
		else if (showEmojiSwitch && showTemperatureSwitch)
			%orig([NSString stringWithFormat:@"%@ %@", weatherString, [[PDDokdo sharedInstance] currentTemperature]]); // that's why i use a variable for the condition, so i can easily add the temperature
		else if (!showEmojiSwitch && showTemperatureSwitch)
			%orig([NSString stringWithFormat:@"%@", [[PDDokdo sharedInstance] currentTemperature]]);
		else
			%orig(conditions);
	} else {
		%orig;
	}

}

// libPDDokdo currently only returns the condition in the language which the device has set so i have to convert it myself
// English
%new
- (void)enEmojis {

	conditions = [[PDDokdo sharedInstance] currentConditions];

	// Sunny
	if ([conditions containsString:@"sun"]) {
		if ([conditions isEqualToString:@"Sunny"])
			weatherString = @"☀️";
		else if ([conditions isEqualToString:@"Mostly Sunny"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Clear
	if ([conditions containsString:@"clear"]) {
		if ([conditions isEqualToString:@"Clear"])
			weatherString = @"☀";
		else if ([conditions isEqualToString:@"Mostly Clear"])
			weatherString = @"🌤";
		else
			weatherString = @"☀️";
		return;
	}

	// Cloudy
	if ([conditions containsString:@"cloud"]) {
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
	if ([conditions containsString:@"showers"] || [conditions containsString:@"thunder"]) {
		if ([conditions isEqualToString:@"Showers"])
			weatherString = @"🌧";
		else if ([conditions isEqualToString:@"Thundershowers"])
			weatherString = @"⛈";
		else if ([conditions containsString:@"Thunder"])
			weatherString = @"⛈";
		else
			weatherString = @"🌦";
		return;
	}

	// Snow
	if ([conditions containsString:@"snow"]) {
		weatherString = @"🌨";
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
		if ([conditions isEqualToString:@"Averses orageuses"])
			weatherString = @"⛈";
		else
			weatherString = @"🌦";
		return;
	}

	// Thunderstorms
	if ([conditions containsString:@"Orage"]) {
		if ([conditions containsString:@"Orages"])
			weatherString = @"⛈";
		else
			weatherString = @"🌦";
		return;
	}

	// Snow
	if ([conditions containsString:@"Neige"] || [conditions containsString:@"neige"]) {
		weatherString = @"🌨";
		return;
	}

}

%end

// Update Weather Data

%hook SBControlCenterController // when opening control center

- (void)_willPresent {

	%orig;

	if (refreshWeatherDataControlCenterSwitch)
		[[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%hook SBCoverSheetPrimarySlidingViewController // when sliding down notitication center

- (void)viewWillAppear:(BOOL)animated {

	%orig;

	if (refreshWeatherDataNotificationCenterSwitch)
		[[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%hook SBBacklightController // when turning on screen

- (void)turnOnScreenFullyWithBacklightSource:(long long)source {

	%orig;

	if (source != 26 && refreshWeatherDataDisplayWakeSwitch)
		[[PDDokdo sharedInstance] refreshWeatherData];

}

%end

%end

%group NitaIntegrityFail

%hook SBIconController

- (void)viewDidAppear:(BOOL)animated {

    %orig;
    if (!dpkgInvalid) return;
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Nita"
		message:@"Seriously? Pirating a free Tweak is awful!\nPiracy repo's Tweaks could contain Malware if you didn't know that, so go ahead and get Nita from the official Source https://repo.litten.love/.\nIf you're seeing this but you got it from the official source then make sure to add https://repo.litten.love to Cydia or Sileo."
		preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {

			UIApplication *application = [UIApplication sharedApplication];
			[application openURL:[NSURL URLWithString:@"https://repo.litten.love/"] options:@{} completionHandler:nil];

	}];

		[alertController addAction:cancelAction];

		[self presentViewController:alertController animated:YES completion:nil];

}

%end

%end

%ctor {

	dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/love.litten.nita.list"];

    if (!dpkgInvalid) dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/love.litten.nita.md5sums"];

    if (dpkgInvalid) {
        %init(NitaIntegrityFail);
        return;
    }

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.nitapreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];

	// What To Display
	[preferences registerBool:&showEmojiSwitch default:NO forKey:@"showEmoji"];
	[preferences registerBool:&showTemperatureSwitch default:NO forKey:@"showTemperature"];

	// Data Refreshing
	[preferences registerBool:&refreshWeatherDataControlCenterSwitch default:YES forKey:@"refreshWeatherDataControlCenter"];
	[preferences registerBool:&refreshWeatherDataNotificationCenterSwitch default:NO forKey:@"refreshWeatherDataNotificationCenter"];
	[preferences registerBool:&refreshWeatherDataDisplayWakeSwitch default:YES forKey:@"refreshWeatherDataDisplayWake"];

	if (!dpkgInvalid && enabled) {
        BOOL ok = false;
        
        ok = ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/lib/dpkg/info/%@%@%@%@%@%@%@%@%@%@%@.nita.md5sums", @"l", @"o", @"v", @"e", @".", @"l", @"i", @"t", @"t", @"e", @"n"]]
        );

        if (ok && [@"litten" isEqualToString:@"litten"]) {
			%init(Nita);
            return;
        } else {
            dpkgInvalid = YES;
        }
    }

}