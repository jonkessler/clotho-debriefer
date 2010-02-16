//
//  LDPlot3.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/16/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDPlot.h"

@interface LDPlot3 : LDPlot {

	NSMutableArray *topDataPoints;
	NSMutableArray *botDataPoints;
	NSArray *arrOfAverages; // array of NSNumbers
	NSRect topSpace;
	NSRect botSpace;
	
}

- (id)initWithPoints:(NSArray *)points 
			averages:(NSArray *)averages 
			 inSpace:(NSRect)totalSpace;

- (id)initWithPoints:(NSArray *)points 
			averages:(NSArray *)averages 
			 inSpace:(NSRect)totalSpace
		currentPlots:(NSArray *)currPlots;

- (void)drawTopInSpace:(NSRect)graphSpace andColor:(NSColor *)fillColor;
- (void)drawBottomInSpace:(NSRect)graphSpace andColor:(NSColor *)fillColor;

@end
