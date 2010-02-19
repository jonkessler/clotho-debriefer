//
//  LDReadInFile.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDReadInFile : NSObject {
	
	NSArray *lines;
	NSString *fullPath;
	NSString *name;

}

@property (assign) NSArray *lines;

- (id)initWithPath:(NSString *)path;

- (NSDate *)dateForFile;
- (NSDate *)dateForLine:(NSString *)line;

@end
