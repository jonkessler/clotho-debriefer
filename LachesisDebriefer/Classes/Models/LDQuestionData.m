//
//  LDQuestionData.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDAppData.h"
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

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSString *)description {

	NSMutableString *toPrint = [NSMutableString string];
	[toPrint appendFormat:@"    task: %@\n", task];
	[toPrint appendFormat:@"    date: %@\n", date];
	[toPrint appendFormat:@" appData: %@\n", appData];
	[toPrint appendFormat:@"appNames: %@\n", uniqueAppNames];
	
	return [NSString stringWithString:toPrint];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSArray *)dataPointsForApp:(NSString *)app {

	NSMutableArray *appPoints = [NSMutableArray array];
	NSArray *allAppPoints = [appData allValues];
	for (NSDictionary *appPoint in allAppPoints) {
		
		LDAppData *appDatum = [appPoint objectForKey:app];
		[appPoints addObject:[NSNumber numberWithDouble:[appDatum dataPoint]]];
		
	}
	
	return [NSArray arrayWithArray:appPoints];
	
	
}

@end
