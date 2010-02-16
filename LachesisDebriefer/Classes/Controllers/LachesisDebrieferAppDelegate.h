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

@interface LachesisDebrieferAppDelegate : NSObject <NSApplicationDelegate> {
	
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

@end
