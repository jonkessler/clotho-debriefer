//
//  LDQuestionAnswers.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDQuestionAnswers : NSObject {

	NSString *debriefDate;
	NSString *debriefTask; 
	
	NSInteger graphType;
	NSArray *graphCoords;
	NSDictionary *graphAppsColors;
	
	NSPoint selected;
	NSPoint correct;
	
	BOOL isCorrect;
	NSString *explanation;
	
	
}

@property (assign) NSString *debriefDate;
@property (assign) NSString *debriefTask; 

@property (assign) NSInteger graphType;
@property (assign) NSArray *graphCoords;
@property (assign) NSDictionary *graphAppsColors;

@property (assign) NSPoint selected;
@property (assign) NSPoint correct;

@property (assign) BOOL isCorrect;
@property (assign) NSString *explanation;

@end
