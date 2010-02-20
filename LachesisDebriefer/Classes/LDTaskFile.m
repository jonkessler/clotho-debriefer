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
		
		NSString *errorDesc = nil; 
		NSPropertyListFormat format; 
		NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:taskPath]; 
		NSMutableArray *taskData = 
		(NSMutableArray *)[NSPropertyListSerialization 
						   propertyListFromData:plistXML 
						   mutabilityOption:NSPropertyListMutableContainersAndLeaves 
						   format:&format errorDescription:&errorDesc]; 

		NSMutableArray *dates = [NSMutableArray arrayWithCapacity:[taskData count]];
		for (NSDictionary *task in taskData) {
			
			[dates addObject:[task objectForKey:@"date"]];
			
		}
		
		debriefLines = [NSMutableArray arrayWithArray:dates];
		
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
	
	return [debriefLines objectAtIndex:0];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSMutableArray *)taskDates {
	
	return [NSMutableArray arrayWithArray:[debriefLines sortedArrayUsingSelector:@selector(compare:)]];
	
}

@end
