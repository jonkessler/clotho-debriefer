//
//  LDDebriefLine.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/9/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDDebriefLine : NSObject {

	NSString *date;
	NSString *time;
	NSInteger daysAgo;
	NSString *bPointType;
	NSArray *importantApps;
	
}

- (id)initWithLine:(NSArray *)debriefLine;

- (NSString *)stringRepresentation;
- (NSData *)dataRepresentation;

@property(assign) NSString *date;
@property(assign) NSString *time;
@property(assign) NSInteger daysAgo;
@property(assign) NSString *bPointType;
@property(assign) NSArray *importantApps;

@end
