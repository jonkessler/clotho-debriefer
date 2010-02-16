//
//  LDFileIO.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/14/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDFileIO.h"

#define DEBUG YES

// if in DEBUG mode, prints log message of the format: 
// -[Class functionName] ["ine" #] message 
#ifdef DEBUG 
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); 
#else 
#   define DLog(...) 
#endif 

// ALog always displays output regardless of the DEBUG setting 
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); 

#pragma mark -

@interface LDFileIO (LDFileIOPrivate)

- (NSData *)dataRepOfDLines:(NSArray *)dLines;

@end

@implementation LDFileIO

@synthesize baseFilePath;

#pragma mark -
#pragma mark Class Functions

+ (NSArray *)generateRandomPoints:(NSInteger)count {
	
	NSInteger i;
	NSMutableArray *toRet = [[NSMutableArray alloc] init];
	for (i=1; i<count; i++) {
		
		double r = 1.0 * random() / RAND_MAX;
		NSValue *coord = [NSValue valueWithPoint:NSMakePoint(i, r)];
		[toRet addObject:coord];
		
	}
	
	return toRet;
	
}

#pragma mark -
#pragma mark LDFileIO Functions

- (id)init {
	
	if (self = [super init]) {
		
		baseFilePath = @"";
		
	}
	
	return self;
	
}

- (id)initWithBasePath:(NSString *)basePath {
	
	if (self = [super init]) {
		
		baseFilePath = basePath;
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    LDDebriefLine - the line with which we set the variables for
//			 NSString - the date to set the debriefLine's date to
//			 NSString - the time to set the debriefLine's time to
// OUTPUT:   
// FUNCTION: Sets the variables of debriefLine to the fake data
 
- (void)assignFakeDataToLine:(LDDebriefLine *)debriefLine 
					withDate:(NSString *)dDate
					 andTime:(NSString *)dTime {
	
	NSInteger daysAgo = 0;
	NSString *breakPoint = @"1MM";
	NSArray *iApps = [NSArray arrayWithObject:@"1234"];		
	
	[debriefLine setDate:dDate];
	[debriefLine setTime:dTime];
	[debriefLine setDaysAgo:daysAgo];
	[debriefLine setBPointType:breakPoint];
	[debriefLine setImportantApps:iApps];
	
}

// ****************************************************************************
// INPUT:    LDDebriefFile - the debrief file with which to create ReadIn Files
// OUTPUT:   
// FUNCTION: creates a read in list for each LDDebriefLine in debriefFile
 
- (void)createReadInFileWithDebrief:(LDDebriefFile *)debriefFile {
	
	NSInteger rand, ltRand, gtRand;
	
	for (LDDebriefLine *aLine in [debriefFile debriefLines]) {
		
		// 1. generate real debrief date
		//
		NSLog(@"%@", [aLine time]);
		if ([[aLine time] rangeOfString:@"-500"].length > 0)
			[aLine setTime:[[aLine time] substringToIndex:8]];
		
		NSString *dateString = [NSString stringWithFormat:@"%@ %@",
								[aLine date], [aLine time]];
		
		if ([dateString rangeOfString:@"null"].length > 0)
			continue;
			
		NSDate *date = [NSDate dateWithNaturalLanguageString:dateString];
		
		// 2. pick a number between 1-12
		//
		rand = random() % 12;
		
		NSMutableArray *readInFile = [NSMutableArray arrayWithCapacity:16];
		NSTimeInterval seconds = 228.0;
		
		// 3. add intervals for all rand < 0
		//
		NSDate *fakeMinus2 = [NSDate dateWithTimeInterval:-(rand+2)*seconds sinceDate:date];
		NSString *date2 = [[fakeMinus2 description] substringToIndex:10];
		NSString *time2 = [[fakeMinus2 description] substringWithRange:NSMakeRange(11, 8)];
		LDDebriefLine *fakeM2 = [[LDDebriefLine alloc] init];
		[self assignFakeDataToLine:fakeM2 withDate:date2 andTime:time2];
		
		NSDate *fakeMinus1 = [NSDate dateWithTimeInterval:-(rand+1)*seconds sinceDate:date];
		NSString *date1 = [[fakeMinus1 description] substringToIndex:10];
		NSString *time1 = [[fakeMinus1 description] substringWithRange:NSMakeRange(11, 8)];
		LDDebriefLine *fakeM1 = [[LDDebriefLine alloc] init];
		[self assignFakeDataToLine:fakeM1 withDate:date1 andTime:time1];
		
		[readInFile addObject:fakeM2];
		[readInFile addObject:fakeM1];
		
		// 4. add intervals for all 0 < ltRand < rand
		//
		ltRand = rand;
		while (ltRand > 0) {
			
			NSDate *fake = [NSDate dateWithTimeInterval:-ltRand*seconds sinceDate:date];
			NSString *fakeDate = [[fake description] substringToIndex:10];
			NSString *fakeTime = [[fake description] substringWithRange:NSMakeRange(11, 8)];
			LDDebriefLine *fakeLine = [[LDDebriefLine alloc] init];
			[self assignFakeDataToLine:fakeLine withDate:fakeDate andTime:fakeTime];
			
			[readInFile addObject:fakeLine];
			
			ltRand--;
			
		}
		
		// 5. add the real deal (by deal i mean date)
		//
		[aLine setDate:[[date description] substringToIndex:10]];
		[aLine setTime:[[aLine time] stringByAppendingFormat:@" -500"]];
		[readInFile addObject:aLine];
		
		// 6. add intervals for all rand < gtRand < 12
		//
		NSInteger multipler = 1;
		gtRand = rand;
		while (gtRand < 12) {

			NSDate *fake = [NSDate dateWithTimeInterval:multipler*seconds sinceDate:date];
			NSString *fakeDate = [[fake description] substringToIndex:10];
			NSString *fakeTime = [[fake description] substringWithRange:NSMakeRange(11, 8)];
			LDDebriefLine *fakeLine = [[LDDebriefLine alloc] init];
			[self assignFakeDataToLine:fakeLine withDate:fakeDate andTime:fakeTime];
			
			[readInFile addObject:fakeLine];
			
			multipler++;
			gtRand++;
			
		}
		
		// 7. add intervals for all rand > 12
		//
		NSDate *fakePlus1 = [NSDate dateWithTimeInterval:multipler*seconds sinceDate:date];
		NSString *fakeDP1 = [[fakePlus1 description] substringToIndex:10];
		NSString *fakeTP1 = [[fakePlus1 description] substringWithRange:NSMakeRange(11, 8)];
		LDDebriefLine *fakeP1 = [[LDDebriefLine alloc] init];
		[self assignFakeDataToLine:fakeP1 withDate:fakeDP1 andTime:fakeTP1];
		
		multipler++;		

		NSDate *fakePlus2 = [NSDate dateWithTimeInterval:multipler*seconds sinceDate:date];
		NSString *fakeDP2 = [[fakePlus2 description] substringToIndex:10];
		NSString *fakeTP2 = [[fakePlus2 description] substringWithRange:NSMakeRange(11, 8)];
		LDDebriefLine *fakeP2 = [[LDDebriefLine alloc] init];
		[self assignFakeDataToLine:fakeP2 withDate:fakeDP2 andTime:fakeTP2];
		
		[readInFile addObject:fakeP1];		
		[readInFile addObject:fakeP2];
		
		// 8. write fake data to file
		// 
		NSString *destinPath = [baseFilePath stringByAppendingPathComponent:@"lachisisDebriefs"];
		if (![[NSFileManager defaultManager] fileExistsAtPath:destinPath isDirectory:nil])
			[[NSFileManager defaultManager] createDirectoryAtPath:destinPath 
									  withIntermediateDirectories:NO
													   attributes:nil
															error:nil];
		
		destinPath = [destinPath stringByAppendingPathComponent:
					  [NSString stringWithFormat:@"readIn %@ %@.txt", 
					   [[aLine date] stringByReplacingOccurrencesOfString:@"/" 
															   withString:@"-"], 
					   [[aLine time] stringByReplacingOccurrencesOfString:@":" 
															   withString:@"-"]]];
		
		NSData *dataRep = [self dataRepOfDLines:readInFile];
		
		[[NSFileManager defaultManager] createFileAtPath:destinPath 
												contents:dataRep 
											  attributes:nil];
		
	}
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (LDDebriefFile *)readInDebriefFile:(NSString *)debriefPath {

	baseFilePath = [[debriefPath stringByDeletingLastPathComponent] 
					stringByDeletingLastPathComponent];
	
	NSData *debriefData = [NSData dataWithContentsOfFile:debriefPath];
	LDDebriefFile *debrief = [[LDDebriefFile alloc] initWithData:debriefData];
	return debrief;
	
}

@end

@implementation LDFileIO (LDFileIOPrivate)

// ****************************************************************************
// INPUT:    NSArray - array of LDDebrieferLine objects
// OUTPUT:   NSData - data representation of all LDDebrieferLines
// FUNCTION: creates the NSData representation of the array of LDDebrieferLines

- (NSData *)dataRepOfDLines:(NSArray *)dLines {
	
	NSMutableData *dataRep = [NSMutableData data];
	for (LDDebriefLine *aLine in dLines)
		[dataRep appendData:[aLine dataRepresentation]];
	
	return [NSData dataWithData:dataRep];
	
}

@end
