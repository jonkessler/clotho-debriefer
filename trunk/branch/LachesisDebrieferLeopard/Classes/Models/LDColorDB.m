//
//  LDColorDB.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/18/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDColorDB.h"


@implementation LDColorDB

- (id)init {
	
	if (self = [super init]) {
		
		fieldSpecificTools = [NSSet setWithObjects:@"Dreamweaver", @"Mathematica", @"Xcode", @"Eclipse", 
							  @"Interface Builder", @"Coda", @"CocoaMsgs", @"ChemDraw Ultra", @"SPSS 16", 
							  @"CheckBook Pro", nil];
		imageTools = [NSSet setWithObjects:@"Acrobat", @"Photoshop", @"Adobe Illustrator CS4", @"Adobe Reader", 
					  @"Adobe Illustrator CS3", @"OmniGraffle Professional", @"Lightroom", @"InDesign", 
					  @"OmniGraffle", @"Pixelmator", @"GraphicConverter", nil];
		media = [NSSet setWithObjects:@"Preview", @"iTunes", @"RealPlayer Downloader", @"Voltedge", @"iPhoto", 
				 @"Smultron", @"EyeTV", @"Nicecast", @"Kung-Tunes", @"RealPlayer", @"PandoraJam", @"QuickTime Player", @"Google Earth", @"VLC", @"DVD Player", @"Digital Photo Professional", @"EOS Utility", 
				 nil];
		pim = [NSSet setWithObjects:@"Mail", @"iCal", @"iChat", @"Adium", @"Skype", @"Oracle Calendar", @"Address Book", @"Lotus Notes", @"AIM", @"Colloquy", @"My Day", @"Mail.appetizer Notification Service", 
			   @"Things", @"NoteBook", @"Tweetie", @"Sametime", @"iScrobbler", @"Entourage", @"TweetDeck", 
			   @"Nambu", @"PGP Engine", @"Daylite", @"Thunderbird", @"iCal Helper", @"Gabble", @"Stationary Pack"
			   , nil];
		system = [NSSet setWithObjects:@"Terminal", @"SlimBatteryMonitor", @"Parallels Desktop", 
				  @"DashboardClient", @"Activity Monitor", @"Snapz Pro X", @"Dock", @"VMware Fusion", @"Clotho Debriefer", @"Installer", @"X11", @"MAMP", @"System Preferences", @"1Password", @"FileMerge", 
				  @"Virex", @"Quicksilver", @"Disk Utility", @"Bluetooth Firmware Update", @"Stickies", @"Clotho Cleaner", @"Software Update", @"MAPP Online Pro", @"Transmit", @"AutoUpdate", @"Grab", 
				  @"Network Utility", @"Cyberduck", @"Automator Launcher", @"Remote Desktop Connection", @"Clotho Logger", 
				  @"BlueMac", @"Trasmission", @"Workbench", @"System Profiler", @"tn3270 X", @"Tivoli Storage Manager", @"Airport Utility", @"Caffeine", @"Finder", nil];
		workTools = [NSSet setWithObjects:@"Word", @"Excel", @"TextEdit", @"FileMaker Pro", @"Pages", @"TextMate"
					 , @"PowerPoint", @"EvernoteHelper", @"TextWrangler", @"Evernote", @"Dictionary", @"TeXShop", 
					 @"Oxygen", @"Keynote", @"Mobility Client", @"Versions", @"Numbers", @"Dictionary Panel", 
					 @"OmniFocus", @"Library", @"EndNote X1", @"DEVONthink", @"Murky", @"Protege", @"Mendeley Desktop", @"Bento", nil];
		web = [NSSet setWithObjects:@"Safari", @"Firefox", @"NetNewsWire", @"Dropbox", @"Google Quick Search Box"
			   , @"Google Reader", @"Mozy Status", @"Google Notifier", @"Netscape", @"Chrome", @"DING!", 
			   @"WebnoteHappy", nil];		
		
		appColors = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					 [NSColor colorWithCalibratedHue:273.0/360.0
										  saturation:87.0/100.0
										  brightness:84.0/100.0 
											   alpha:1.0], fieldSpecificTools,
					 [NSColor colorWithCalibratedHue:0.0/360.0 
										  saturation:87.0/100.0 
										  brightness:75.0/100.0 
											   alpha:1.0], imageTools,
					 [NSColor colorWithCalibratedHue:94.0/360.0 
										  saturation:100.0/100.0 
										  brightness:72.0/100.0 
											   alpha:1.0], media,
					 [NSColor colorWithCalibratedHue:170.0/360.0 
										  saturation:59.0/100.0 
										  brightness:80.0/100.0 
											   alpha:1.0], pim,
					 [NSColor colorWithCalibratedHue:60.0/360.0 
										  saturation:86.0/100.0
										  brightness:84.0/100.0 
											   alpha:1.0], system,
					 [NSColor colorWithCalibratedHue:238.0/360.0 
										  saturation:86.0/100.0 
										  brightness:74.0/100.0 
											   alpha:1.0], workTools,
					 [NSColor colorWithCalibratedHue:38.0/360.0 
										  saturation:87.0/100.0 
										  brightness:80.0/100.0 
											   alpha:1.0], web, nil];	
		
		usedColors = [NSMutableSet set];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSColor *)adjustForUsedColor:(NSColor *)maybeUsed
					  forAppSet:(NSSet *)appSet {
	
	if (![usedColors containsObject:maybeUsed]) {
		
		[usedColors addObject:maybeUsed];
		return maybeUsed;
		
	}
	
	else {
	
		CGFloat hue, saturation, brightness, alpha;
		[maybeUsed getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
		
		if (hue > 0.2)
			return [NSColor colorWithCalibratedHue:hue-0.1
										saturation:saturation
										brightness:brightness
											 alpha:alpha];
		else if (brightness > 0.3)
			return [NSColor colorWithCalibratedHue:hue
										saturation:saturation
										brightness:brightness-0.2
											 alpha:alpha];
		else
			return [NSColor colorWithCalibratedHue:hue
										saturation:saturation
										brightness:brightness
											 alpha:alpha-0.2];
		
	}

		
	
}
 
// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSColor *)colorForApp:(NSString *)app {
	
	if ([fieldSpecificTools containsObject:app])
		return [self adjustForUsedColor:[appColors objectForKey:fieldSpecificTools] 
							  forAppSet:fieldSpecificTools];
	
	else if ([imageTools containsObject:app])
		return [self adjustForUsedColor:[appColors objectForKey:imageTools] 
							  forAppSet:imageTools];
	
	else if ([media containsObject:app])
		return [self adjustForUsedColor:[appColors objectForKey:media] 
							  forAppSet:media];
	
	else if ([pim containsObject:app])
		return [self adjustForUsedColor:[appColors objectForKey:pim] 
							  forAppSet:pim];
	
	else if ([system containsObject:app])
		return [self adjustForUsedColor:[appColors objectForKey:system] 
							  forAppSet:system];
	
	else if ([workTools containsObject:app])
		return [self adjustForUsedColor:[appColors objectForKey:workTools] 
							  forAppSet:workTools];
	
	else if ([web containsObject:app])
		return [self adjustForUsedColor:[appColors objectForKey:web] 
							  forAppSet:web];
	
	else
		return [NSColor blackColor];
	
}

@end
