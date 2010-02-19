//
//  LDFileIO.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/14/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDDebriefFile.h"
#import "LDDebriefLine.h"
#import "LDQuestionAnswers.h"
#import "LDTaskData.h"

@interface LDFileIO : NSObject {

	NSString *baseFilePath; // absolute path to User's log folder
	
}

@property (assign, readonly) NSString *baseFilePath;

#pragma mark -
#pragma mark Class Functions

+ (NSArray *)appNameDataForDate:(NSDate *)date;

+ (NSArray *)generateRandomPoints:(NSInteger)count;

+ (NSArray *)pidDataForDate:(NSDate *)date;

+ (NSArray *)rawDataForDate:(NSDate *)date;

+ (NSArray *)readInFiles;

+ (LDTaskData *)taskForDate:(NSDate *)date;

+ (NSArray *)titleDataForDate:(NSDate *)date;

#pragma mark -
#pragma mark LDFileIO Functions

- (id)initWithBasePath:(NSString *)basePath;

- (void)assignFakeDataToLine:(LDDebriefLine *)debriefLine 
					withDate:(NSString *)dDate
					 andTime:(NSString *)dTime;

- (void)createReadInFileWithDebrief:(LDDebriefFile *)debriefFile;

+ (void)logAnswer:(LDQuestionAnswers *)answer;

- (LDDebriefFile *)readInDebriefFile:(NSString *)debriefPath;

@end
