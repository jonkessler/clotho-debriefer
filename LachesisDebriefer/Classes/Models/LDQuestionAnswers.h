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
	
	CGFloat secondsAway;
	CGFloat pixelsAway;
	CGFloat timeTaken;
	
	BOOL isCorrect;
	NSString *explanation;
	
	
}

@property (assign) NSString *debriefDate;
@property (assign) NSString *debriefTask; 

@property (assign) NSInteger graphType;
@property (assign) NSArray *graphCoords;
@property (assign) NSDictionary *graphAppsColors;

@property (assign) CGFloat secondsAway;
@property (assign) CGFloat pixelsAway;
@property (assign) CGFloat timeTaken;

@property (assign) BOOL isCorrect;
@property (assign) NSString *explanation;

@end
