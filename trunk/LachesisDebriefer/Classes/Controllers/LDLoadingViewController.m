//
//  LDLoadingViewController.m
//
//  Created by Joseph Subida on 1/13/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDLoadingViewController.h"

#import "LDLoadingMaster.h"

@implementation LDLoadingViewController

@synthesize progressBar, loadingMessage, chosenDate, fakeDebriefs;

- (id)init {
	
	if (self = [super initWithNibName:@"LDLoading" bundle:nil]) {
		
		chosenDate = @"";
		
	}
	
	return self;
	
}

- (void)awakeFromNib {
	
	[progressWheel setUsesThreadedAnimation:YES];
	[progressWheel setIndeterminate:YES];
	[progressWheel startAnimation:nil];
	
	[progressBar setUsesThreadedAnimation:YES];
	[progressBar setIndeterminate:NO];	
	[progressBar startAnimation:nil];
	[progressBar setMinValue:0.0];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)beginLoading {

	LDLoadingMaster *lMaster = [[LDLoadingMaster alloc] initWithController:self];	
	[lMaster beginLoading];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)beginQuestions:(LDDebriefFile *)dFile {

	NSDictionary *info = [NSDictionary dictionaryWithObject:dFile forKey:@"DebriefFile"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"finishedLoading" 
														object:nil
													  userInfo:info];
	
}

@end
