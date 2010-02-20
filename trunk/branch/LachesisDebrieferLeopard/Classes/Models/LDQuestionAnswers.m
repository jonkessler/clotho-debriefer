//
//  LDQuestionAnswers.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDQuestionAnswers.h"


@implementation LDQuestionAnswers

@synthesize debriefDate, debriefTask, graphType, graphCoords, graphAppsColors,
secondsAway, isCorrect, explanation;

- (id)init {
	
	if (self = [super init]) {
		
		debriefDate = @"";
		debriefTask = @"";
		graphType = -1;
		graphCoords = [NSArray array];
		graphAppsColors = [NSDictionary dictionary];
		secondsAway = -1.0;
		isCorrect = YES;
		explanation = @"NONE";
		
	}
	
	return self;
	
}

@end
