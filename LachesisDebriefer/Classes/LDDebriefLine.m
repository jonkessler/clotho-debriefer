//
//  LDDebriefLine.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/9/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDDebriefLine.h"


@implementation LDDebriefLine

@synthesize date, time, daysAgo, bPointType, importantApps;

- (id)init {
	
	if (self = [super init]) {
		
		date = @"";
		time = @"";
		daysAgo = -1;
		bPointType = @"";
		importantApps = [NSMutableArray array];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    NSArray - array representing a debrief line; of the format:
//						date, time, days ago, bp type, app1, app2, ...
// OUTPUT:   LDDebriefLine 
// FUNCTION: initializes an LDDebriefLine object using the given array
 
- (id)initWithLine:(NSArray *)debriefLine {
	
	if ( (self = [super init]) && ([debriefLine count] > 3) ) {
		
		date = [debriefLine objectAtIndex:0];
		time = [debriefLine objectAtIndex:1];
		daysAgo = [[debriefLine objectAtIndex:2] integerValue];
		bPointType = [debriefLine objectAtIndex:3];
		
		NSInteger i = 4;		
		NSMutableArray *iApps = [NSMutableArray array];
		NSCharacterSet *commas = [NSCharacterSet punctuationCharacterSet];		
		while (i < [debriefLine count]) {
			
			[iApps addObject:
			 [[debriefLine objectAtIndex:i] stringByTrimmingCharactersInSet:commas]];
			i++;
			
		}
		
		[iApps removeLastObject];
		
		importantApps = [NSArray arrayWithArray:iApps];
		
	}

	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSString *)stringRepresentation {
	
	NSMutableString *str = [NSMutableString stringWithFormat:@"%@ %@\t%d %@",
							[date stringByReplacingOccurrencesOfString:@"-" withString:@"/"],
							 time, daysAgo, bPointType];
	
	for (NSString *app in importantApps)
		[str appendFormat:@" %@,", app];
		
	[str appendString:@"\n"];
	
	return [NSString stringWithString:str];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSData *)dataRepresentation {
	
	return [[self stringRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
	
}

@end
