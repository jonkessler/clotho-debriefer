//
//  LDPlot.h
//  QuartzBox
//
//  Created by Joseph Subida on 1/8/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDSubplot.h"

@interface LDPlot : NSObject {

	//  contains NSValue objects of the form ( [1-width], [0-1] )
	//  where the NSPoint.x is an integer from 1 to width
	//  and the NSPoint.y is a float between 0 and 1
	NSMutableArray *dataPoints;
	NSBezierPath *path;
	
}

@property (assign) NSBezierPath *path;

- (id)initWithPoints:(NSArray *)dataPts 
			 andRect:(NSRect)graphSpace 
		   fillColor:(NSColor *)toFill;

- (id)initWithPoints:(NSArray *)dataPts 
			 andRect:(NSRect)graphSpace 
		   fillColor:(NSColor *)toFill
		currentPlots:(NSArray *)curPlots;

- (void)initializePathWithRect:(NSRect)graphSpace
					 fillColor:(NSColor *)fillColor;

- (void)initializePathWithRect:(NSRect)graphSpace 
					 fillColor:(NSColor *)fillColor
				  currentPlots:(NSArray *)curPlots;

- (NSPoint)adjustPoint:(NSPoint)p usingPlots:(NSArray *)plots origHeight:(CGFloat)oHeight;

- (BOOL)containsPoint:(NSPoint)p;

- (CGFloat)yPointNotInPlots:(NSArray *)plots atX:(CGFloat)xCoord;

@end
