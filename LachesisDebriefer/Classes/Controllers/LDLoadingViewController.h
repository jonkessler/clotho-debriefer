//
//  LDLoadingViewController.h
//
//  Created by Joseph Subida on 1/13/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDTaskFile.h"

@interface LDLoadingViewController : NSViewController {

	IBOutlet NSProgressIndicator *progressWheel;
	IBOutlet NSProgressIndicator *progressBar;
	IBOutlet NSTextField *loadingMessage;
	
	NSString *chosenDate;
	NSArray *fakeDebriefs;
	
}

@property (assign) NSProgressIndicator *progressBar;
@property (assign) NSTextField *loadingMessage;
@property (assign) NSString *chosenDate;
@property (assign) NSArray *fakeDebriefs;

- (void)beginLoading;
- (void)beginQuestions:(LDTaskFile *)dFile;

@end
