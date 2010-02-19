//
//  LDLoadedData.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//
//  LDLoadedData contains the data required for each question. 

#import <Cocoa/Cocoa.h>


@interface LDLoadedData : NSObject {

	NSMutableDictionary *appColors;
	NSMutableArray *timeStamps;
	
}

@property (assign) NSMutableDictionary *appColors;
@property (assign) NSMutableArray *timeStamps;

- (id)initWithAppNames:(NSArray *)appNames;

- (NSColor *)colorForApp:(NSString *)app;

@end
