//
//  LDDebriefFile.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/9/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDDebriefFile.h"

#import "LDDebriefLine.h"

@implementation LDDebriefFile

@synthesize debriefLines, calculatedDataPoints, dLineDatesForFile;

// ****************************************************************************
// INPUT:    NSData - contents of a debrief file
// OUTPUT:   LDDebriefFile
// FUNCTION: initializes this object using fileData
 
- (id)initWithData:(NSData *)fileData {

	if (self = [super init]) {
		
		dLineDatesForFile = [NSMutableDictionary dictionary];
		
		NSMutableArray *dividedByLineAndSpace = [NSMutableArray array];
		
		//  make data into string
		NSString *fileDataAsString = [[NSString alloc] initWithData:fileData 
														   encoding:NSUTF8StringEncoding];
		
		//  divide string by newline character
		NSArray *dividedByLineBreak = [fileDataAsString componentsSeparatedByString:@"\n"]; 
		
		//  divide each line by space
		NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceCharacterSet];
		for (NSString *line in dividedByLineBreak) {
			
			// each space separated word
			NSArray *dividedWords = 
			[line componentsSeparatedByCharactersInSet:whiteSpace]; 
			NSMutableArray *dividedBySpace = [NSMutableArray arrayWithArray:dividedWords];
			
			//  fix all of the logs with "first run" in them
			if ( ([dividedBySpace count] > 4)
				&& ([[dividedBySpace objectAtIndex:3] isEqualToString:@"first"]) ) {
				
				NSString *firstRun = @"first_run";
				[dividedBySpace replaceObjectAtIndex:3 withObject:firstRun];
				
				NSRange rangeUntilEnd;
				rangeUntilEnd.location = 5;
				rangeUntilEnd.length = [dividedBySpace count] - 5;
				
				NSIndexSet *indexesUntilEnd = 
				[NSIndexSet indexSetWithIndexesInRange:rangeUntilEnd];
				
				NSArray *restOfArray = [dividedBySpace objectsAtIndexes:indexesUntilEnd];
				
				rangeUntilEnd.location = 4;
				rangeUntilEnd.length = [dividedBySpace count] - 5;
				indexesUntilEnd = [NSIndexSet indexSetWithIndexesInRange:rangeUntilEnd];
				[dividedBySpace replaceObjectsAtIndexes:indexesUntilEnd 
											withObjects:restOfArray];
				
			}
			
			LDDebriefLine *dLine = [[LDDebriefLine alloc] initWithLine:dividedBySpace];
			
			[dividedByLineAndSpace addObject:dLine];
			
		}
		
		debriefLines = [NSMutableArray arrayWithArray:dividedByLineAndSpace];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   NSDate - date of this debriefFile
// FUNCTION: determines and returns the date of this debrie file
 
- (NSDate *)dateOfDebriefFile {
	
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
