//
//  LDQuestionViewController.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/14/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDQuestionViewController.h"
#import "LDQuestionData.h"

@implementation LDQuestionViewController

@synthesize appColors, graph, date, task, wrongSheet, debriefFile;

- (id)init {
	
	if (self = [super initWithNibName:@"LDQuestion" bundle:[NSBundle mainBundle]])  {
		
		debriefFile = [[LDDebriefFile alloc] init];
		
		currentSession = 0;
		
		answer = [[LDQuestionAnswers alloc] init];
		
//		graph = [[LDGraphView alloc] initWithDebriefFile:debriefFile];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (id)initWIthDebrief:(LDDebriefFile *)debrief {
	
	if (self = [super initWithNibName:@"LDQuestion" bundle:[NSBundle mainBundle]])  {
		
		debriefFile = debrief;
		
		currentSession = 0;
		
		answer = [[LDQuestionAnswers alloc] init];
		
//		graph = [[LDGraphView alloc] initWithDebriefFile:debriefFile];
		
	}
	
	return self;	
	
}

- (void)awakeFromNib {
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(showWrongDialog) 
												 name:@"wrongAnswer" 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(makeNewGraph:) 
												 name:@"rightAnswer" 
											   object:nil];
	
}

- (void)loadView {
	
	[super loadView];
	[graph setDebriefFile:debriefFile];
	[graph generateNewGraph];
	
}

- (IBAction)endSheet:(id)sender {
	
	[NSApp endModalSession:currentSession];
	[NSApp stopModal]; 
	[wrongSheet orderOut:sender];
	
	[answer setIsCorrect:NO];
	[answer setExplanation:[wrongText stringValue]];
	
	[self makeNewGraph:sender];
	
}

- (IBAction)makeNewGraph:(id)sender {
	
//	[answer setDebriefDate:
	
	answer = [[LDQuestionAnswers alloc] init];	
	
	[graph generateNewGraph];
	
}

- (void)showWrongDialog {
	
	currentSession = [NSApp beginModalSessionForWindow:wrongSheet];
	[NSApp runModalSession:currentSession];
	
}																			  
																			  
- (void)mouseMoved:(NSEvent *)theEvent {
	
	[graph mouseMovedInMe:theEvent];
	
}
																			
@end
