//
//  LachesisDebrieferAppDelegate.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/13/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDDateViewController.h"
#import "LDLoadingViewController.h"
#import "LDQuestionViewController.h"
#import "LDWindow.h"

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface LachesisDebrieferAppDelegate : NSObject
#else
@interface LachesisDebrieferAppDelegate : NSObject <NSApplicationDelegate>
#endif
{
//@interface LachesisDebrieferAppDelegate : NSObject <NSApplicationDelegate> {
	
    LDWindow *window;
	LDLoadingViewController *loadingController;
	LDQuestionViewController *questionController;
	LDDateViewController *dateController;
	
}

@property (assign) IBOutlet LDWindow *window;
@property (assign) LDLoadingViewController *loadingController;
@property (assign) LDQuestionViewController *questionController;
@property (assign) LDDateViewController *dateController;

- (void)loadQuestions:(NSNotification *)notif;

- (void)terminateApplication;

@end
