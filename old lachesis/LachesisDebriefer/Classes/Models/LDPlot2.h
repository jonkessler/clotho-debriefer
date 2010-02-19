//
//  LDPlot2.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/16/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDPlot.h"

@interface LDPlot2 : LDPlot {
	
	NSRect graphSpace;
	NSArray *ySums;
	double largestSum;

}

@property (assign) NSArray *ySums;
@property (assign) double largestSum;

- (NSMutableArray *)graphPoints;

- (void)graphOnPlot:(NSBezierPath *)currPlot backwardsFor:(NSArray *)points;
- (void)graphOnPlot:(NSBezierPath *)currPlot forwardsFor:(NSArray *)points;

- (void)normalizeDataPoints;
- (NSMutableArray *)normalizeForPlot3:(NSMutableArray *)plot3Points 
							andHalves:(NSMutableArray *)plot3Halves;

- (NSMutableArray *)plot2DataPoints;

@end
