//
//  LDAppData.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDAppData.h"


@implementation LDAppData

@synthesize name, color, dataPoints;

- (id)init {
	
	if (self = [super init]) {
		
		name = @"";
		color = [NSColor blackColor];
		dataPoints = [NSArray array];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (id)initWithName:(NSString *)iName andPoints:(NSArray *)iPoints {
	
	if (self = [super init]) {
		
		name = iName;
		color = [NSColor blackColor];
		dataPoints = [NSArray arrayWithArray:iPoints];
		
	}
	
	return self;
	
}

@end
