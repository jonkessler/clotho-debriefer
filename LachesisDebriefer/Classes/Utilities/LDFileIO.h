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

@interface LDFileIO : NSObject {

	NSString *baseFilePath; // absolute path to User's log folder
	
}

@property (assign, readonly) NSString *baseFilePath;

+ (NSArray *)generateRandomPoints:(NSInteger)count;

- (id)initWithBasePath:(NSString *)basePath;

- (void)assignFakeDataToLine:(LDDebriefLine *)debriefLine 
					withDate:(NSString *)dDate
					 andTime:(NSString *)dTime;

- (void)createReadInFileWithDebrief:(LDDebriefFile *)debriefFile;

- (LDDebriefFile *)readInDebriefFile:(NSString *)debriefPath;

@end
