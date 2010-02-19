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
	NSInteger pid;
	NSColor *color;
	double dataPoint;
	
	NSArray *rawData;
	NSDictionary *titleRawData;

}

@property (assign) NSString *name;
@property (assign) NSInteger pid;
@property (assign) NSColor *color;
@property (assign) double dataPoint;

@property (assign) NSArray *rawData;
@property (assign) NSDictionary *titleRawData;

- (id)initWithName:(NSString *)iName
		andRawData:(NSArray *)iRaw 
		   withPID:(NSInteger)iPid;

- (void)associateTitleWithRawData:(NSArray *)titles;

@end
