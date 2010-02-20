//
//  LDPlot.m
//  QuartzBox
//
//  Created by Joseph Subida on 1/8/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDPlot.h"

#import "LDSubplot.h"

#define NUM_POINTS 10

@implementation LDPlot

@synthesize path;

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (id)initWithPoints:(NSArray *)dataPts 
			 andRect:(NSRect)graphSpace 
		   fillColor:(NSColor *)toFill {

	if (self = [super init]) {
		
		dataPoints = [NSMutableArray arrayWithArray:dataPts];
		
		[self initializePathWithRect:graphSpace fillColor:toFill];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    NSArray - array of NSValue objects of NSPoints
// OUTPUT:   LDPlot
// FUNCTION: initializes the plot with an array of (x,y) coordinates
 
- (id)initWithPoints:(NSArray *)dataPts 
			 andRect:(NSRect)graphSpace 
		   fillColor:(NSColor *)toFill
		currentPlots:(NSArray *)curPlots {
	
	if (self = [super init]) {
		
		dataPoints = [NSMutableArray arrayWithArray:dataPts];
		
		[self initializePathWithRect:graphSpace fillColor:toFill currentPlots:curPlots];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    NSRect - rectangle represnting the view
//			 NSColor - color to fill the path with
// OUTPUT:   
// FUNCTION: generates graph #2 by default
 
- (void)initializePathWithRect:(NSRect)graphSpace 
					 fillColor:(NSColor *)fillColor {
	
	CGFloat height = NSHeight(graphSpace);
	CGFloat width = NSWidth(graphSpace);
	
	NSPoint start = NSMakePoint(NSMinX(graphSpace), NSMinY(graphSpace));
	NSPoint end;
	
	path = [NSBezierPath bezierPath];	
	[path moveToPoint:start];
	
	for (NSValue *point in dataPoints) {
		
		end = [point pointValue];
		end = NSMakePoint(end.x/NUM_POINTS * width, end.y * height);
		
		LDSubplot *subPlot = [[LDSubplot alloc] initWithStart:start andEnd:end];
		
		[path curveToPoint:end
			 controlPoint1:[subPlot bottomRight]
			 controlPoint2:[subPlot topLeft]];
		
		start = end;
		
	}
	
	LDSubplot *subplot = [[LDSubplot alloc] initWithStart:start andEnd:end];
	[path curveToPoint:end
		 controlPoint1:[subplot bottomRight]
		 controlPoint2:[subplot topLeft]];
	
	[path lineToPoint:NSMakePoint(end.x, 0.0)];
	
	[[NSColor blackColor] set];
	[path setLineWidth:3.0];
	[path stroke];
	
	[fillColor set];
	[path fill];
	
}

- (void)initializePathWithRect:(NSRect)graphSpace 
					 fillColor:(NSColor *)fillColor
				  currentPlots:(NSArray *)curPlots {
	
	CGFloat height = NSHeight(graphSpace);
	CGFloat width = NSWidth(graphSpace);
	
	NSPoint start = NSMakePoint(NSMinX(graphSpace), NSMinY(graphSpace));
	NSPoint end;
	
	path = [NSBezierPath bezierPath];	
	[path moveToPoint:start];
	
	CGFloat yCoord = 0.0;
	for (NSValue *point in dataPoints) {
		
		end = [point pointValue];			
		end = NSMakePoint(end.x/NUM_POINTS * width, end.y * height);
		yCoord = [self yPointNotInPlots:curPlots atX:end.x];
		end = NSMakePoint(end.x, end.y+yCoord);
		LDSubplot *subPlot = [[LDSubplot alloc] initWithStart:start andEnd:end];
		
		[path curveToPoint:end
			 controlPoint1:[subPlot bottomRight]
			 controlPoint2:[subPlot topLeft]];
		
		start = end;
		
	}
	
	LDSubplot *subplot = [[LDSubplot alloc] initWithStart:start andEnd:end];
	
	[path curveToPoint:end
		 controlPoint1:[subplot bottomRight]
		 controlPoint2:[subplot topLeft]];
	
	[path lineToPoint:NSMakePoint(end.x, 0.0)];
	
	[[NSColor blackColor] set];
	[path setLineWidth:3.0];
	[path stroke];
	
	[fillColor set];
	[path fill];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSPoint)adjustPoint:(NSPoint)p usingPlots:(NSArray *)plots origHeight:(CGFloat)oHeight {

	NSPoint adjustedP = NSMakePoint(p.x, oHeight * p.y);
	for (NSBezierPath *plot in plots) {
		
		while ([plot containsPoint:adjustedP]) {
			adjustedP = NSMakePoint(adjustedP.x, adjustedP.y+1);
		}
		
	}
	
	CGFloat newHeight = oHeight - adjustedP.y;
	
	adjustedP = NSMakePoint(p.x, newHeight * p.y + adjustedP.y);
	
	return adjustedP;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (BOOL)containsPoint:(NSPoint)p {
	
	return [path containsPoint:p];
	
}

// ****************************************************************************
// INPUT:    NSArray - array of NSBezierPaths
//			 CGFloat - x coordinate 
// OUTPUT:   CGFloat - the y coordinate that is just above all plots in plots
// FUNCTION: determines the y coordinate that is just above every plot in 
//			 plots that is at xCoord
 
- (CGFloat)yPointNotInPlots:(NSArray *)plots atX:(CGFloat)xCoord {
	
	NSPoint p = NSMakePoint(xCoord, 0.0);
	for (NSBezierPath *plot in plots)
		while ([plot containsPoint:p])
			p = NSMakePoint(p.x, p.y+1.0);
	
	return p.y;
	
}

@end
