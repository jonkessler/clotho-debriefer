//
//  LDLoadingMaster.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/14/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDLoadingMaster.h"

#import "LDFileIO.h"

#import <JavaVM/JavaVM.h>

#define LDLOG_PATH @"~/Library/Logs/Discipline"
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

@implementation LDLoadingMaster

- (id)initWithController:(LDLoadingViewController *)controller {
	
	if (self = [super init]) {
		
		debriefDate = [controller chosenDate];
		debriefFile = [[LDDebriefFile alloc] init];
		modeController = controller;
		progressTimer = [NSTimer scheduledTimerWithTimeInterval:100.0
														 target:self
													   selector:@selector(fireProgress) 
													   userInfo:nil 
														repeats:YES];
		
	}
	
	return self;
	
}

- (void)beginLoading {
	
	NSString *absPath = [LDLOG_PATH stringByExpandingTildeInPath];
	BOOL isDir;
	if (![[NSFileManager defaultManager] fileExistsAtPath:absPath isDirectory:&isDir]
		&& isDir) {
		
		DLog(@"***ERROR: ~/Library/Logs/Discipline does not exist!!!");
		return;
		
	}
		
	
	[self createFakeDebriefs];
	NSLog(@"Start: %@", [NSDate date]);
	[self applyJoshCodeToFakeDebriefs];
	NSLog(@"End: %@", [NSDate date]);
	[self applyTreeToFakeDebriefs];
	
	[self fireProgress];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)createFakeDebriefs {
	
	debriefDate = @"07-14-09";
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yy"];
	NSDate *theDate = [NSDate dateWithNaturalLanguageString:debriefDate];
	NSString *formattedDate = [formatter stringFromDate:theDate];
	
	LDFileIO *fileIO = [[LDFileIO alloc] initWithBasePath:LDLOG_PATH];
	
	NSString *fullPath = [[LDLOG_PATH stringByExpandingTildeInPath] 
						  stringByAppendingFormat:@"/Log/Debriefer/Debriefing_%@.log", 
						  formattedDate];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
		DLog(@"***ERROR: Debrief file does not exist at %@", fullPath);
		
	debriefFile = [fileIO readInDebriefFile:fullPath];
	[fileIO createReadInFileWithDebrief:debriefFile];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: code to run Java file from http://www.stackoverflow.com
//			 Runs Josh's code on the data for the given day
 
- (void)applyJoshCodeToFakeDebriefs {
	
	// TODO: make sure Josh's code writes to ~/Library/Logs/Discipline and 
	// works only for the given day
	
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/usr/bin/java"];
	[task setCurrentDirectoryPath:@"/Users/JC/Desktop"];
	
	NSArray *arguments = [NSArray arrayWithObjects:
						  @"-jar", @"LachesisData.jar", 
						  [@"~/Library/Logs/Discipline" stringByExpandingTildeInPath], nil];
	[task setArguments:arguments];
	
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput:pipe];
	
	NSFileHandle *file = [pipe fileHandleForReading];
	
	[task launch];
	
	NSData *data = [file readDataToEndOfFile];
	
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"return\n %@", string);
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)applyTreeToFakeDebriefs {
	
	// TODO: determine where generated tree is located
	
	// TODO: determine where title file located and read it in
	
	// TODO: parse xml tree 
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)fireProgress {
	
	[[modeController progressBar] incrementBy:100.0];
	
	if ([[modeController progressBar] doubleValue] >= 100.0) {
		
		[progressTimer invalidate];
		[modeController beginQuestions:debriefFile];
		
	}
		
	
}

@end
