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
selected, correct, isCorrect, explanation;

- (id)init {
	
	if (self = [super init]) {
		
		debriefDate = @"";
		debriefTask = @"";
		graphType = -1;
		graphCoords = [NSArray array];
		graphAppsColors = [NSDictionary dictionary];
		selected = NSMakePoint(0.0, 0.0);
		correct = NSMakePoint(0.0, 0.0);
		isCorrect = YES;
		explanation = @"NONE";
		
	}
	
	return self;
	
}

@end
