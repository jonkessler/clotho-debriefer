//
//  LDPlot3.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/16/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDPlot3.h"

#define NUM_POINTS 10

@implementation LDPlot3

// ****************************************************************************
// INPUT:    NSArray - array of arrays of points
//			 NSArray - averages of corresponding points
//			 NSRect - the overall space this graph can be drawn in
// OUTPUT:   LDPlot3
// FUNCTION: initializes graph 3

- (id)initWithPoints:(NSArray *)points 
			averages:(NSArray *)averages 
			 inSpace:(NSRect)totalSpace {
	
	if (self = [super init]) {
		
		dataPoints = [NSMutableArray arrayWithArray:points];
		arrOfAverages = [NSArray arrayWithArray:averages];;
		
		topSpace = NSMakeRect(NSMinX(totalSpace), NSMidY(totalSpace), 
							  NSWidth(totalSpace), NSHeight(totalSpace)/2.0);
		botSpace = NSMakeRect(NSMinX(totalSpace), NSMinY(totalSpace), 
							  NSWidth(totalSpace), NSHeight(totalSpace)/2.0);;
		
		topDataPoints = [NSMutableArray arrayWithCapacity:[dataPoints count]];
		botDataPoints = [NSMutableArray arrayWithCapacity:[dataPoints count]];
		
		NSInteger midHeight = NSHeight(totalSpace)/2;
		NSInteger i = 0;
		for (NSValue *point in dataPoints) {
			
			NSPoint aPoint = [point pointValue];
			CGFloat yPoint = aPoint.y;
			CGFloat avgOfY = [[arrOfAverages objectAtIndex:i] floatValue];
			
			CGFloat normalizedY1 = yPoint - avgOfY;
			
			midHeight += normalizedY1;
			
			
			i++;
			
		}
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    NSArray - array of arrays of points
//			 NSArray - averages of corresponding points
//			 NSRect - the overall space this graph can be drawn in
//			 NSArray - array of LDPlots previously plotted
// OUTPUT:   LDPlot3
// FUNCTION: initializes graph 3
 
- (id)initWithPoints:(NSArray *)points 
			averages:(NSArray *)averages 
			 inSpace:(NSRect)totalSpace
		currentPlots:(NSArray *)currPlots {
	
	if (self = [super init]) {
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    NSRect - rectangle represnting the view
//			 NSColor - color to fill the path with
// OUTPUT:   
// FUNCTION: generates graph #3

- (void)initializePathWithRect:(NSRect)graphSpace 
					 fillColor:(NSColor *)fillColor {
	
	if (NSMinY(graphSpace) > 0) 
		[self drawTopInSpace:graphSpace andColor:fillColor];
	else
		[self drawBottomInSpace:graphSpace andColor:fillColor];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Shifts the graph by +y pixels

- (void)drawTopInSpace:(NSRect)graphSpace andColor:(NSColor *)fillColor {
	
	CGFloat height = NSHeight(graphSpace);
	CGFloat width = NSWidth(graphSpace);
	
	NSPoint start = NSMakePoint(NSMinX(graphSpace), NSMinY(graphSpace));
	NSPoint end;
	
	CGFloat normalization = start.y;
	
	path = [NSBezierPath bezierPath];	
	[path moveToPoint:start];
	
	for (NSValue *point in dataPoints) {
		
		end = [point pointValue];
		end = NSMakePoint(end.x/NUM_POINTS * width, (end.y * height) + normalization);
		
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
	
	[path lineToPoint:NSMakePoint(end.x, NSMinY(graphSpace))];
	[path lineToPoint:NSMakePoint(NSMinX(graphSpace), NSMinY(graphSpace))];
	
	[[NSColor blackColor] set];
	[path setLineWidth:3.0];
	[path stroke];
	
	[fillColor set];
	[path fill];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Sets the end point to be height - (end.y * height)

- (void)drawBottomInSpace:(NSRect)graphSpace andColor:(NSColor *)fillColor {
	
	CGFloat height = NSHeight(graphSpace);
	CGFloat width = NSWidth(graphSpace);
	
	NSPoint start = NSMakePoint(NSMinX(graphSpace), NSMaxY(graphSpace));
	NSPoint end;
	
	path = [NSBezierPath bezierPath];	
	[path moveToPoint:start];
	
	for (NSValue *point in dataPoints) {
		
		end = [point pointValue];
		end = NSMakePoint(end.x/NUM_POINTS * width, height - (end.y * height));
		
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
	
	[path lineToPoint:NSMakePoint(end.x, NSMaxY(graphSpace))];
	[path lineToPoint:NSMakePoint(NSMinX(graphSpace), NSMaxY(graphSpace))];
	
	[[NSColor blackColor] set];
	[path setLineWidth:3.0];
	[path stroke];
	
	[fillColor set];
	[path fill];
	
}

@end
