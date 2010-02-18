//
//  LDAppData.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDAppData : NSObject {
	
	NSString *name;
	NSColor *color;
	NSArray *dataPoints;

}

@property (assign) NSString *name;
@property (assign) NSColor *color;
@property (assign) NSArray *dataPoints;

- (id)initWithName:(NSString *)iName andPoints:(NSArray *)iPoints;

@end
