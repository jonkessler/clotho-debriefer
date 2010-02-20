//
//  LachesisDebrieferAppDelegate.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/13/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LachesisDebrieferAppDelegate.h"

@implementation LachesisDebrieferAppDelegate

@synthesize loadingController, questionController, dateController, window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	NSNotificationCenter *notifCent = [NSNotificationCenter defaultCenter];
	[notifCent addObserver:self
				  selector:@selector(loadQuestions:) 
					  name:@"finishedLoading"
					object:nil];
	
	[notifCent addObserver:self
				  selector:@selector(terminateApplication) 
					  name:@"terminate"
					object:nil];
	
	[window setCurrentController:dateController];
	
}

- (void)loadQuestions:(NSNotification *)notif {
	
	NSDictionary *info = [notif userInfo];
	LDTaskFile *debriefFile = [info objectForKey:@"DebriefFile"];
	
	questionController = [[LDQuestionViewController alloc] initWIthDebrief:debriefFile];
	
	[window setCurrentController:questionController];	
	
    //  Compute the new window frame
    NSSize currentSize = [[window contentView] frame].size;
    NSSize newSize = [[questionController view] frame].size;
    float deltaWidth = newSize.width - currentSize.width;
    float deltaHeight = newSize.height - currentSize.height;
    NSRect windowFrame = [window frame];
    windowFrame.size.height += deltaHeight;
    windowFrame.size.width += deltaWidth;	
	windowFrame.origin.x -= deltaWidth;
    windowFrame.origin.y -= deltaHeight;	

	[window setFrame:windowFrame display:YES animate:YES];
	[window setContentView:[questionController view]];
	
}

- (void)terminateApplication {
	
	[NSApp terminate:self];
	
}

@end
