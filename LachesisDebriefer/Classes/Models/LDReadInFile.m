//
//  LDReadInFile.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDReadInFile.h"


@implementation LDReadInFile

@synthesize lines;

- (id)initWithPath:(NSString *)path {
	
	if (self = [super init]) {
		
		NSData *theData = [NSData dataWithContentsOfFile:path];
		
		NSString *theString = [[NSString alloc] initWithData:theData 
													encoding:NSUTF8StringEncoding];
		
		lines = [theString componentsSeparatedByString:@"\n"];
		
		fullPath = path;
		
		name = [path lastPathComponent];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSDate *)dateForFile {
	
	NSString *date = [name substringWithRange:NSMakeRange(7, 10)];
	NSString *time = [name substringWithRange:NSMakeRange(18, 8)];
	time = [time stringByReplacingOccurrencesOfString:@"-" withString:@":"];
	time = [time stringByAppendingString:[name substringWithRange:NSMakeRange(26, 6)]];	
	
	NSDate *fileDate = [NSDate dateWithNaturalLanguageString:
						[NSString stringWithFormat:@"%@ %@", date, time]];
	
	return fileDate;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSDate *)dateForLine:(NSString *)line {
	
	NSString *dateTime = [line substringWithRange:NSMakeRange(0, 17)];
	
	return [NSDate dateWithNaturalLanguageString:dateTime];
	
}

@end
