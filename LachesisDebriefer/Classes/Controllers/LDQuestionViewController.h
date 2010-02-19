//
//  LDQuestionViewController.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/14/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDColorKey.h"
#import "LDDebriefFile.h"
#import "LDGraphView.h"
#import "LDQuestionAnswers.h"
#import "LDQuestionView.h"

@interface LDQuestionViewController : NSViewController {

	IBOutlet LDColorKey *appColors;
	IBOutlet LDGraphView *graph;

	IBOutlet NSTextField *date;
	IBOutlet NSTextField *task;
	IBOutlet NSWindow *wrongSheet;	
	IBOutlet NSTextField *wrongText;
	
	IBOutlet LDQuestionView *questionView;
	
	IBOutlet NSTextField *dateL;
	IBOutlet NSTextField *dateM;
	IBOutlet NSTextField *dateR;

	
	LDDebriefFile *debriefFile;
	NSModalSession currentSession;
	LDQuestionAnswers *answer;
	
}

@property (assign) LDColorKey *appColors;
@property (assign) LDGraphView *graph;

@property (assign) NSTextField *date;
@property (assign) NSTextField *task;
@property (assign) NSWindow *wrongSheet;

@property (assign) LDDebriefFile *debriefFile;

- (IBAction)endSheet:(id)sender;
- (IBAction)makeNewGraph:(id)sender;

- (id)initWIthDebrief:(LDDebriefFile *)debrief;

- (void)showWrongDialog;

@end
