//
//  LDDebriefFile.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/9/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDTaskFile.h"

#import "LDDebriefLine.h"

@implementation LDTaskFile

@synthesize debriefLines, calculatedDataPoints, datesForFile;

// ****************************************************************************
// INPUT:    NSData - contents of a debrief file
// OUTPUT:   LDDebriefFile
// FUNCTION: initializes this object using fileData
 
- (id)initWithTaskPath:(NSString *)taskPath {

	if (self = [super init]) {
		
		datesForFile = [NSMutableDictionary dictionary];
		
		
		debriefLines = [NSMutableArray array];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   NSDate - date of this debriefFile
// FUNCTION: determines and returns the date of this debrie file
 
- (NSDate *)dateOfTaskFile {
	
	if ([debriefLines count] == 0)
		return nil;
	
	LDDebriefLine *dLine = [debriefLines objectAtIndex:0];
	
	NSString *dateString = [NSString stringWithFormat:@"%@ %@",
							[dLine date], [dLine time]];
	
	return [NSDate dateWithNaturalLanguageString:dateString];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSMutableArray *)debriefDates {
	
	return [NSMutableArray arrayWithArray:[debriefLines sortedArrayUsingSelector:@selector(compare:)]];
	
}

@end
