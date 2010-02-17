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

	NSRect graphArea;
	
}

- (id)initWithPoints:(NSArray *)points 
			 andRect:(NSRect)graphSpace;

- (void)graphOnPlot:(NSBezierPath *)currPlot backwardsFor:(NSArray *)points;
- (void)graphOnPlot:(NSBezierPath *)currPlot forwardsFor:(NSArray *)points;

@end
