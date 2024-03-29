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

@synthesize appColors, graph, date, task, graphType, wrongSheet, debriefFile;

- (id)init {
	
	if (self = [super initWithNibName:@"LDQuestion" bundle:[NSBundle mainBundle]])  {
		
		debriefFile = [[LDTaskFile alloc] init];
		
		currentSession = 0;
		
		answer = [[LDQuestionAnswers alloc] init];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (id)initWIthDebrief:(LDTaskFile *)debrief {
	
	if (self = [super initWithNibName:@"LDQuestion" bundle:[NSBundle mainBundle]])  {
		
		debriefFile = debrief;
		
		currentSession = 0;
		
		answer = [[LDQuestionAnswers alloc] init];
		
	}
	
	return self;	
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: adds this LDQuestionViewController as an observer of selecting a 
//			 wrong or right answer
 
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

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Sets up the main question view. 
 
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
	
	if ([[date stringValue] rangeOfString:@"null"].length > 0)
		[self loadView];
	
	// Set question task
	LDQuestionData *qData = [[debriefFile calculatedDataPoints] objectForKey:
							 [graph currentDate]];
	[task setTitleWithMnemonic:[NSString stringWithFormat:@"&%@", [qData task]]];
	
	// Set graph type
	if ([graph plotNum] == 0)
		[graphType setTitleWithMnemonic:@"Line Graph"];
	else if ([graph plotNum] == 1)
		[graphType setTitleWithMnemonic:@"Stacked Area"];
	else
		[graphType setTitleWithMnemonic:@"Stream Graph"];
	
	// Set question labels
	NSArray *sortedDates = [[debriefFile datesForFile] objectForKey:[graph currentDate]];
	
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

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: This is called when the user clicks OK in the explanation window. 
//			 The window is closed and the LDQuestionAnswers object is set accordingly
 
- (IBAction)endSheet:(id)sender {
	
	[NSApp endModalSession:currentSession];
	[NSApp stopModal]; 
	[wrongSheet orderOut:sender];
	
	[answer setIsCorrect:NO];
	[answer setExplanation:[wrongText stringValue]];
	
	[self makeNewGraph:sender];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Logs the current question's answers and then generates a new graph
 
- (IBAction)makeNewGraph:(id)sender {
	
	answer = [[LDQuestionAnswers alloc] init];	
	[answer setDebriefDate:[[graph currentDate] description]];
	[answer setDebriefTask:[task stringValue]];
	[answer setGraphType:[graph plotNum]];
	[answer setIsCorrect:[graph wasCorrect]];
	if (![graph wasCorrect])	
		[answer setExplanation:[wrongText stringValue]];
		
	[answer setSecondsAway:[graph secondsAway]];
	[answer setPixelsAway:[graph pixelsAway]];
	[answer setTimeTaken:[graph timeTaken]];	
	
	[LDFileIO logAnswer:answer];
	
	[graph generateNewGraph];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)showWrongDialog {
	
	currentSession = [NSApp beginModalSessionForWindow:wrongSheet];
	[NSApp runModalSession:currentSession];
	
}																			  
							
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
