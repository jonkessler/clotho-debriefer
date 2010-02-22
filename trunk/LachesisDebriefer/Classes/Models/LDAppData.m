//
//  LDAppData.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDAppData.h"


@implementation LDAppData

@synthesize name, pid, color, dataPoint, rawData, titleRawData;

- (id)init {
	
	if (self = [super init]) {
		
		name = @"";
		pid = 0;
		color = [NSColor blackColor];
		dataPoint = 0.0;
		rawData = [NSArray array];
		titleRawData = [NSDictionary dictionary];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (id)initWithName:(NSString *)iName
	  andDataPoint:(double)dPoint {

	if (self = [super init]) {
		
		name = iName;
		pid = 0;
		color = [NSColor blackColor];
		dataPoint = dPoint;
		rawData = [NSArray array];
		titleRawData = [NSDictionary dictionary];				
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (id)initWithName:(NSString *)iName
		andRawData:(NSArray *)iRaw 
		   withPID:(NSInteger)iPid {
	
	if (self = [super init]) {
		
		name = iName;
		pid = iPid;
		color = [NSColor blackColor];
		dataPoint = 0.0;
		rawData = [NSArray arrayWithArray:iRaw];
		titleRawData = [NSDictionary dictionary];		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSString *)description {

	NSMutableString *toPrint = [NSMutableString string];
	[toPrint appendFormat:@"name     = %@\n", name];
	[toPrint appendFormat:@" pid     = %d\n", pid];
	[toPrint appendFormat:@"color	 = %@\n", [color description]];
	[toPrint appendFormat:@"dataPoint= %f\n", dataPoint];
	[toPrint appendFormat:@"rawData  = %@\n", rawData];
	[toPrint appendFormat:@"titleRawData= %@\n", titleRawData];
	
	return [NSString stringWithString:toPrint];
	
}

// ****************************************************************************
// INPUT:    NSArray - array of titles
// OUTPUT:   
// FUNCTION: associates each raw datum with each title
 
- (void)associateTitleWithRawData:(NSArray *)titles {
	
	NSInteger i = 0;
	NSMutableDictionary *iTitleRaw = [NSMutableDictionary dictionary];
	for (NSString *title in titles) {
		
		[iTitleRaw setObject:[rawData objectAtIndex:i] forKey:title];
		i++;
		
	}
	
	[self setTitleRawData:[NSDictionary dictionaryWithDictionary:iTitleRaw]];
	
}

@end
