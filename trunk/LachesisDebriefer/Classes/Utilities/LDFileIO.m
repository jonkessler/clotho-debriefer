//
//  LDFileIO.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/14/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDFileIO.h"

#import "LDReadInFile.h"

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

- (NSDate *)searchForDate:(NSDate *)searchDate inArray:(NSArray *)snapsArray;

@end

@implementation LDFileIO

@synthesize baseFilePath;

#pragma mark -
#pragma mark Class Functions

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
+ (NSArray *)appNameDataForDate:(NSDate *)date {

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd--HH-mm-ss"];
	
	NSString *filePath = [@"~/Library/Logs/Discipline/Results/0" 
						  stringByExpandingTildeInPath];
	filePath = [filePath stringByAppendingFormat:@"/appName_%@.txt", 
				[formatter stringFromDate:date]];
	
	NSData *fileData = [NSData dataWithContentsOfFile:filePath];
	NSString *fileString = [[NSString alloc] initWithData:fileData 
												 encoding:NSUTF8StringEncoding];
	
	NSArray *fileArray = [fileString componentsSeparatedByString:@"\n"];
	NSMutableArray *appNames = [NSMutableArray array];
	for (NSString *appPair in fileArray)
		[appNames addObject:[[appPair componentsSeparatedByString:@" - "] objectAtIndex:0]];
	
	return appNames;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
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

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 

+ (NSArray *)pidDataForDate:(NSDate *)date {

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd--HH-mm-ss"];
	
	NSString *filePath = [@"~/Library/Logs/Discipline/Results/0" 
						  stringByExpandingTildeInPath];
	filePath = [filePath stringByAppendingFormat:@"/pid_%@.txt", 
				[formatter stringFromDate:date]];
	
	NSData *fileData = [NSData dataWithContentsOfFile:filePath];
	NSString *fileString = [[NSString alloc] initWithData:fileData 
												 encoding:NSUTF8StringEncoding];
	
	NSArray *fileArray = [fileString componentsSeparatedByString:@"\n"];
	
	return fileArray;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
+ (NSArray *)rawDataForDate:(NSDate *)date {
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd--HH-mm-ss"];
	
	NSString *filePath = [@"~/Library/Logs/Discipline/Results/0" 
						  stringByExpandingTildeInPath];
	filePath = [filePath stringByAppendingFormat:@"/%@.txt", 
				[formatter stringFromDate:date]];
	
	NSData *fileData = [NSData dataWithContentsOfFile:filePath];
	NSString *fileString = [[NSString alloc] initWithData:fileData 
												 encoding:NSUTF8StringEncoding];
	
	NSArray *fileArray = [fileString componentsSeparatedByString:@"\n"];
	
	NSMutableArray *dataPerApp = [NSMutableArray array];
	for (NSString *appData in fileArray) {
		
		NSArray *sepByComma = [appData componentsSeparatedByString:@","];
		sepByComma = [sepByComma subarrayWithRange:NSMakeRange(1, [sepByComma count]-1)];
		[dataPerApp addObject:sepByComma];
		
	}
	
	return [NSArray arrayWithArray:dataPerApp];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 

+ (NSArray *)readInFiles {
	
	NSString *path = [@"~/Library/Logs/Discipline/Log/lachisisDebriefs" stringByExpandingTildeInPath];
	
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path 
																		 error:nil];
	NSMutableArray *readIns = [NSMutableArray array];
	for (NSString *file in files) {
		
		NSString *fullPath = [path stringByAppendingPathComponent:file];
		
		if ([fullPath rangeOfString:@".DS"].length > 0)
			continue;
		
		LDReadInFile *readIn = [[LDReadInFile alloc] initWithPath:fullPath];
		
		[readIns addObject:readIn];
		
	}
	
	return [NSArray arrayWithArray:readIns];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
+ (LDTaskData *)taskForDate:(NSDate *)date {

	NSString *path = [@"~/Library/Logs/Discipline/Tasks/" stringByExpandingTildeInPath];
	
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path 
																		 error:nil];
	
	LDTaskData *tasks = [[LDTaskData alloc] init];
	
	NSDateFormatter *taskDateFormat = [[NSDateFormatter alloc] init];
	[taskDateFormat setDateFormat:@"yyyy-MM-dd"];
	
	NSString *taskFileName = [NSString stringWithFormat:@"Task_%@.plist", 
							  [taskDateFormat stringFromDate:date]];
	
	if (![files containsObject:taskFileName])
		DLog(@"***ERROR: Task file not found for path: %@", taskFileName);
	
	NSString *taskFilePath = [path stringByAppendingPathComponent:taskFileName];
	NSString *errorDesc = nil; 
	NSPropertyListFormat format; 
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:taskFilePath]; 
	NSMutableArray *taskData = 
	(NSMutableArray *)[NSPropertyListSerialization 
							propertyListFromData:plistXML 
							mutabilityOption:NSPropertyListMutableContainersAndLeaves 
							format:&format errorDescription:&errorDesc]; 
	
	for (NSDictionary *task in taskData) {
		
		NSDate *taskDate = [task objectForKey:@"Date"];
		if ([taskDate isEqualToDate:date]) {
			
			[tasks setData:task];
			break;
			
		}
			
	}
	
	[tasks setName:taskFileName];
	
	return tasks;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
+ (NSArray *)titleDataForDate:(NSDate *)date {

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd--HH-mm-ss"];
	
	NSString *filePath = [@"~/Library/Logs/Discipline/Results/0" 
						  stringByExpandingTildeInPath];
	filePath = [filePath stringByAppendingFormat:@"/title_%@.txt", 
				[formatter stringFromDate:date]];
	
	NSData *fileData = [NSData dataWithContentsOfFile:filePath];
	NSString *fileString = [[NSString alloc] initWithData:fileData 
												 encoding:NSUTF8StringEncoding];
	
	NSArray *fileArray = [fileString componentsSeparatedByString:@","];
	fileArray = [fileArray subarrayWithRange:NSMakeRange(1, [fileArray count]-1)];
	
	return fileArray;
	
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
 
- (void)createReadInFileWithTask:(LDTaskFile *)debriefFile {
	
	NSInteger rand, ltRand, gtRand;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yy"];
	
	// 0. get array of dates of each snapshot file
	//
	NSString *snapFolder = [baseFilePath stringByAppendingString:@"/System_Snapshots/"];
	NSDate *debriefDate = [debriefFile dateOfTaskFile];
	
	NSDateFormatter *sysSnapFormatter = [[NSDateFormatter alloc] init];
	[sysSnapFormatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *debriefSnapshotFolder = [NSString stringWithFormat:
									   @"System_Snapshots_%@",
									   [sysSnapFormatter stringFromDate:debriefDate]];
	
	NSString *sysSnapsFolder = [snapFolder stringByAppendingPathComponent:
								debriefSnapshotFolder];
	
	NSError *e;
	NSArray *snaps = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sysSnapsFolder 
																		 error:&e];
	if ([snaps count] == 0)
		DLog(@"%@", [e localizedDescription]);
	
	NSMutableArray *snapDates = [NSMutableArray arrayWithCapacity:[snaps count]];
	for (NSString *snapshot in snaps) {
		
		if ([[snapshot pathExtension] isEqualToString:@"plist"]) {
			
			NSString *dateTime = [snapshot substringWithRange:NSMakeRange(16, 25)];
			NSDate *snapDate = [NSDate dateWithNaturalLanguageString:dateTime];
			[snapDates addObject:snapDate];
			
		}
		
	}
	
	for (LDDebriefLine *aLine in [debriefFile debriefLines]) {
		
		// 1. generate real debrief date
		//
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
		NSDate *fakeSnap = [self searchForDate:fakeMinus2 inArray:snapDates];
		NSTimeInterval interval = [fakeMinus2 timeIntervalSinceDate:fakeSnap];
		if ( (interval > 228.0) || (interval < 0) )
			continue;
		fakeMinus2 = fakeSnap;
		NSString *date2 = [dateFormatter stringFromDate:fakeMinus2];
		NSString *time2 = [[fakeMinus2 description] substringWithRange:NSMakeRange(11, 8)];
		LDDebriefLine *fakeM2 = [[LDDebriefLine alloc] init];
		[self assignFakeDataToLine:fakeM2 withDate:date2 andTime:time2];
		
		NSDate *fakeMinus1 = [NSDate dateWithTimeInterval:-(rand+1)*seconds sinceDate:date];
		fakeSnap = [self searchForDate:fakeMinus1 inArray:snapDates];
		interval = [fakeMinus1 timeIntervalSinceDate:fakeSnap];
		if ( (interval > 228.0) || (interval < 0) )
			continue;		
		fakeMinus1 = fakeSnap;
		NSString *date1 = [dateFormatter stringFromDate:fakeMinus1];
		NSString *time1 = [[fakeMinus1 description] substringWithRange:NSMakeRange(11, 8)];
		LDDebriefLine *fakeM1 = [[LDDebriefLine alloc] init];
		[self assignFakeDataToLine:fakeM1 withDate:date1 andTime:time1];
		
		[readInFile addObject:fakeM2];
		[readInFile addObject:fakeM1];
		
		// 4. add intervals for all 0 < ltRand < rand
		//
		ltRand = rand;
		BOOL shouldContinue = NO;
		while (ltRand > 0) {
			
			NSDate *fake = [NSDate dateWithTimeInterval:-ltRand*seconds sinceDate:date];
			fakeSnap = [self searchForDate:fake inArray:snapDates];
			interval = [fake timeIntervalSinceDate:fakeSnap];
			if ( (interval > 228.0) || (interval < 0) ) {
				
				shouldContinue = YES;
				break;
				
			}				
			fake = fakeSnap;
			NSString *fakeDate = [dateFormatter stringFromDate:fake];
			NSString *fakeTime = [[fake description] substringWithRange:NSMakeRange(11, 8)];
			LDDebriefLine *fakeLine = [[LDDebriefLine alloc] init];
			[self assignFakeDataToLine:fakeLine withDate:fakeDate andTime:fakeTime];
			
			[readInFile addObject:fakeLine];
			
			ltRand--;
			
		}
		
		if (shouldContinue)
			continue;
		
		// 5. add the real deal (by deal i mean date)
		//
		[aLine setDate:[dateFormatter stringFromDate:date]];
		[readInFile addObject:aLine];
		
		// 6. add intervals for all rand < gtRand < 12
		//
		NSInteger multipler = 1;
		gtRand = rand;
		while (gtRand < 12) {

			NSDate *fake = [NSDate dateWithTimeInterval:multipler*seconds sinceDate:date];
			fakeSnap = [self searchForDate:fake inArray:snapDates];
			interval = [fake timeIntervalSinceDate:fakeSnap];
			if ( (interval > 228.0) || (interval < 0) ) {
				
				shouldContinue = YES;
				break;
				
			}		
			fake = fakeSnap;
			NSString *fakeDate = [dateFormatter stringFromDate:fake];
			NSString *fakeTime = [[fake description] substringWithRange:NSMakeRange(11, 8)];
			LDDebriefLine *fakeLine = [[LDDebriefLine alloc] init];
			[self assignFakeDataToLine:fakeLine withDate:fakeDate andTime:fakeTime];
			
			[readInFile addObject:fakeLine];
			
			multipler++;
			gtRand++;
			
		}
		
		if (shouldContinue)
			continue;		
		
		// 7. add intervals for all rand > 12
		//
		NSDate *fakePlus1 = [NSDate dateWithTimeInterval:multipler*seconds sinceDate:date];
		fakeSnap = [self searchForDate:fakePlus1 inArray:snapDates];
		interval = [fakePlus1 timeIntervalSinceDate:fakeSnap];
		if ( (interval > 228.0) || (interval < 0) )
			continue;				
		fakePlus1 = fakeSnap;
		NSString *fakeDP1 = [dateFormatter stringFromDate:fakePlus1];
		NSString *fakeTP1 = [[fakePlus1 description] substringWithRange:NSMakeRange(11, 8)];
		LDDebriefLine *fakeP1 = [[LDDebriefLine alloc] init];
		[self assignFakeDataToLine:fakeP1 withDate:fakeDP1 andTime:fakeTP1];
		
		multipler++;		

		NSDate *fakePlus2 = [NSDate dateWithTimeInterval:multipler*seconds sinceDate:date];
		fakeSnap = [self searchForDate:fakePlus2 inArray:snapDates];
		interval = [fakePlus2 timeIntervalSinceDate:fakeSnap];
		if ( (interval > 228.0) || (interval < 0) )
			continue;				
		fakePlus2 = fakeSnap;		
		NSString *fakeDP2 = [dateFormatter stringFromDate:fakePlus2];
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
 
+ (void)logAnswer:(LDQuestionAnswers *)answer {
	
	NSString *path = [@"~/Library/Logs/Discipline/Log/Lachesis" stringByExpandingTildeInPath];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path])
		[[NSFileManager defaultManager] createDirectoryAtPath:path 
								  withIntermediateDirectories:NO
												   attributes:nil
														error:nil];
	
	path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"debrief_%@.txt", 
												 [answer debriefDate]]];
	
	NSString *stringToLog = [NSString stringWithFormat:@"%@, %@, %d, %f, %d, %@",
							 [answer debriefDate], [answer debriefTask],
							 [answer graphType], [answer secondsAway],
							 ([answer isCorrect]) ? 1 : 0, [answer explanation]];
	NSData *theData = [stringToLog dataUsingEncoding:NSUTF8StringEncoding];
	
	[[NSFileManager defaultManager] createFileAtPath:path contents:theData attributes:nil];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (LDTaskFile *)readInTaskFile:(NSString *)taskPath {

	baseFilePath = [[taskPath stringByDeletingLastPathComponent] 
					stringByDeletingLastPathComponent];
	
	LDTaskFile *task = [[LDTaskFile alloc] initWithTaskPath:taskPath];
	return task;
	
}

@end

@implementation LDFileIO (LDFileIOPrivate)

// ****************************************************************************
// INPUT:    NSArray - array of LDDebrieferLine objects
// OUTPUT:   NSData - data representation of all LDDebrieferLines
// FUNCTION: creates the NSData representation of the array of LDDebrieferLines

- (NSData *)dataRepOfDLines:(NSArray *)dLines {
	
	NSMutableData *dataRep = [NSMutableData data];
	for (LDDebriefLine *aLine in dLines) {
		[dataRep appendData:[aLine dataRepresentation]];
	}
		
	
	return [NSData dataWithData:dataRep];
	
}

// ****************************************************************************
// INPUT:    NSDate - date to look for in snapsArray
//			 NSArray - array of NSDates of each snapshot
// OUTPUT:   NSDate - date on or < 228 seconds before searchDate
// FUNCTION: attempts to locate searchDate in snapsArray. if not found, find 
//			 snapshot < 228 seconds away from searchDate. binary search from:
//			 http://en.wikipedia.org/wiki/Binary_search_algorithm#Overview
 
- (NSDate *)searchForDate:(NSDate *)searchDate inArray:(NSArray *)snapsArray {
	
	NSInteger lo = 0;
	NSInteger hi = [snapsArray count];
	NSInteger mid;
	NSDate *dateAtMid;
	
	while (lo < hi) {
		
		mid = lo + (hi-lo)/2;
		dateAtMid = [snapsArray objectAtIndex:mid];
		if ([[dateAtMid earlierDate:searchDate] isEqualToDate:dateAtMid])
			lo = mid + 1;
		else
			hi = mid;
		
	}
	
	if (lo > 0)
		return [snapsArray objectAtIndex:lo-1];
	return [snapsArray objectAtIndex:lo];
	
}

@end
