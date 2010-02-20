//
//  LDQuestionData.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDQuestionData.h"


@implementation LDQuestionData

@synthesize task, date, appData, uniqueAppNames;

- (id)init {
	
	if (self = [super init]) {
		
		task = @"";
		date = [NSDate date];
		appData = [NSMutableDictionary dictionary];
		uniqueAppNames = [NSArray array];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (id)initWithTask:(NSString *)iTask andDate:(NSDate *)iDate {

	if (self = [super init]) {
		
		task = iTask;
		date = iDate;
		appData = [NSMutableDictionary dictionary];
		uniqueAppNames = [NSArray array];
		
	}
	
	return self;
	
}

@end
