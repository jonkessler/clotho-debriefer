//
//  LDQuestionViewController.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/14/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDFileIO.h"
#import "LDQuestionViewController.h"
#import "LDQuestionData.h"

@implementation LDQuestionViewController

@synthesize appColors, graph, date, task, wrongSheet, debriefFile;

- (id)init {
	
	if (self = [super initWithNibName:@"LDQuestion" bundle:[NSBundle mainBundle]])  {
		
		debriefFile = [[LDDebriefFile alloc] init];
		
		currentSession = 0;
		
		answer = [[LDQuestionAnswers alloc] init];
		
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
	
	// Set question date
	NSDateFormatter *taskDate = [[NSDateFormatter alloc] init];
	[taskDate setDateStyle:NSDateFormatterFullStyle];
	[taskDate setTimeStyle:NSDateFormatterNoStyle];
	[date setTitleWithMnemonic:[NSString stringWithFormat:@"&%@", 
								[taskDate stringFromDate:[graph currentDate]]]];
	
	// Set question task
	LDQuestionData *qData = [[debriefFile calculatedDataPoints] objectForKey:
							 [graph currentDate]];
	[task setTitleWithMnemonic:[NSString stringWithFormat:@"&%@", [qData task]]];
	
	// Set question labels
	NSArray *sortedDates = [[debriefFile dLineDatesForFile] objectForKey:[graph currentDate]];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterLongStyle];
	
	if ([sortedDates count] == 17) {
		
		[dateL setTitleWithMnemonic:[formatter stringFromDate:[sortedDates objectAtIndex:0]]];
		[dateM setTitleWithMnemonic:[formatter stringFromDate:[sortedDates objectAtIndex:9]]];
		[dateR setTitleWithMnemonic:[formatter stringFromDate:[sortedDates objectAtIndex:16]]];	
		
	}	
	else {
		
		[dateL setTitleWithMnemonic:@"&Earlier"];
		[dateM setTitleWithMnemonic:@"&"];
		[dateR setTitleWithMnemonic:@"&Later"];
		
	}

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
	
	answer = [[LDQuestionAnswers alloc] init];	
	[answer setDebriefDate:[[graph currentDate] description]];
	[answer setDebriefTask:[task stringValue]];
	[answer setGraphType:[graph plotNum]];
	[answer setIsCorrect:[graph wasCorrect]];
	if (![graph wasCorrect]) {
		
		[answer setExplanation:[wrongText stringValue]];
		[answer setSecondsAway:[graph secondsAway]];
		
	}
	else
		[answer setSecondsAway:0.0];
		
	[LDFileIO logAnswer:answer];
	
	[graph generateNewGraph];
	
}

- (void)showWrongDialog {
	
	currentSession = [NSApp beginModalSessionForWindow:wrongSheet];
	[NSApp runModalSession:currentSession];
	
}																			  
																			  
- (void)mouseMoved:(NSEvent *)theEvent {
	
	[graph mouseMovedInMe:theEvent];
	
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
