//
//  LDLoadingMaster.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/14/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LDTaskFile.h"
#import "LDLoadingViewController.h"

@interface LDLoadingMaster : NSObject {

	LDLoadingViewController *modeController;
	LDTaskFile *debriefFile;
	NSTimer *progressTimer;
	NSString *debriefDate;
	NSMutableDictionary *questionsByDate;
	NSArray *loadingText;
	NSInteger loadingCounter;
	
}

- (id)initWithController:(LDLoadingViewController *)controller;

- (void)beginLoading;

- (void)fireProgress;

- (void)finishProgress;

- (void)createFakeDebriefs;

- (void)applyJoshCodeToFakeDebriefs;

- (void)applyTreeToFakeDebriefs;

@end
