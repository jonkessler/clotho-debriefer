//
//  LDPlot3.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/16/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDPlot3.h"

#import "LDPlot2.h"

#define NUM_POINTS 10

@implementation LDPlot3

// ****************************************************************************
// INPUT:    NSArray - array of arrays of points
//			 NSRect - the overall space this graph can be drawn in
// OUTPUT:   LDPlot3
// FUNCTION: initializes graph 3

- (id)initWithPoints:(NSArray *)points 
			 andRect:(NSRect)graphSpace {
	
	if (self = [super init]) {
		
		LDPlot2 *pl2 = [[LDPlot2 alloc] initWithPoints:points 
											   andRect:graphSpace
											 fillColor:nil];
		
		dataPoints = [NSArray arrayWithArray:[pl2 plot2DataPoints]];
		
		graphArea = graphSpace;
		
		// 1. Determine 1/2 of each summed value
		// 
		NSArray *sums = [pl2 ySums];
		NSMutableArray *halves = [NSMutableArray arrayWithCapacity:[sums count]];
		
		for (NSNumber *sum in sums)
			[halves addObject:[NSNumber numberWithDouble:[sum doubleValue]/2.0]];
		
		// 2. Subtract dataPoints[i] - halved[i]
		// 
		NSMutableArray *newDataPoints = [NSMutableArray arrayWithCapacity:[dataPoints count]];
		for (NSArray *arrOfPoints in dataPoints) {
			
			NSMutableArray *newArrOfPoints = 
			[NSMutableArray arrayWithCapacity:[arrOfPoints count]];
			
			NSInteger i = 0;
			for (NSValue *point in arrOfPoints) {
				
				double half = [[halves objectAtIndex:i] doubleValue];
				NSPoint oldPoint = [point pointValue];
				NSPoint newPoint = NSMakePoint(oldPoint.x, oldPoint.y - half);
				
				[newArrOfPoints addObject:[NSValue valueWithPoint:newPoint]];
				
				i++;
				
			}
			
			[newDataPoints addObject:newArrOfPoints];
			
		}
		
		NSMutableArray *newArrOfPoints = [NSMutableArray array];
		double curX = 1.0;
		for (NSNumber *half in halves) {
			
			NSPoint zeroPoint = NSMakePoint(curX, 0.0-[half doubleValue]);
			[newArrOfPoints addObject:[NSValue valueWithPoint:zeroPoint]];
			
			curX++;
			
		}
		
		[newDataPoints addObject:newArrOfPoints];
		
		dataPoints = [pl2 normalizeForPlot3:newDataPoints andHalves:halves];
		
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
 

// ****************************************************************************
// INPUT:    NSRect - rectangle represnting the view
//			 NSColor - color to fill the path with
// OUTPUT:   
// FUNCTION: generates graph #3


// ****************************************************************************
// INPUT:    NSBezierPath - current path 
//			 NSArray - array of NSValue (NSPoint) objects 
// OUTPUT:   
// FUNCTION: backwards graphing of each point in points on currPlot. Assume 
//			 currPlot is already at the starting point

- (void)graphOnPlot:(NSBezierPath *)currPlot backwardsFor:(NSArray *)points {
	
	NSRect topHalf = NSMakeRect(0.0, NSMidY(graphArea), 
								NSWidth(graphArea)/2, NSHeight(graphArea)/2);
	
	CGFloat halfHeight = NSHeight(topHalf) * 0.9;
	
	CGFloat width = NSWidth(graphArea);
	
	NSPoint start = [currPlot currentPoint];
	NSPoint end;
	
	NSInteger total = [points count] + 1;
	
	NSArray *reversePoints = [[points reverseObjectEnumerator] allObjects];
	for (NSValue *point in reversePoints) {
		
		end = [point pointValue];
		
		if (end.y < 0)
			end = NSMakePoint(end.x/total * width, halfHeight + (end.y * halfHeight));
		else
			end = NSMakePoint(end.x/total * width, halfHeight + (end.y * halfHeight));
		
		end.y += 25;
		
		LDSubplot *subPlot = [[LDSubplot alloc] initWithStart:start andEnd:end];
		
		[currPlot curveToPoint:end
				 controlPoint1:[subPlot bottomRight] 
				 controlPoint2:[subPlot topLeft]];
		
		start = end;
		
	}
	
	LDSubplot *subPlot = [[LDSubplot alloc] initWithStart:start andEnd:end];
	
	[currPlot curveToPoint:end
			 controlPoint1:[subPlot bottomRight] 
			 controlPoint2:[subPlot topLeft]];
	
}

// ****************************************************************************
// INPUT:    NSBezierPath - current path 
//			 NSArray - array of NSValue (NSPoint) objects 
// OUTPUT:   
// FUNCTION: forwards graphing of each point in points on currPlot

- (void)graphOnPlot:(NSBezierPath *)currPlot forwardsFor:(NSArray *)points {
	
	NSRect topHalf = NSMakeRect(0.0, NSMidY(graphArea), 
								NSWidth(graphArea)/2, NSHeight(graphArea)/2);
	
	CGFloat halfHeight = NSHeight(topHalf) * 0.90;
	
	CGFloat width = NSWidth(graphArea);
	
	NSPoint start = [currPlot currentPoint];
	NSPoint end;
	
	NSInteger total = [points count] + 1;
	
	for (NSValue *point in points) {
		
		end = [point pointValue];
		
		if (end.y < 0)
			end = NSMakePoint(end.x/total * width, halfHeight + (end.y * halfHeight));
		else
			end = NSMakePoint(end.x/total * width, halfHeight + (end.y * halfHeight));
		
		end.y += 25;
		
		LDSubplot *subPlot = [[LDSubplot alloc] initWithStart:start andEnd:end];
		
		[currPlot curveToPoint:end
				 controlPoint1:[subPlot bottomRight] 
				 controlPoint2:[subPlot topLeft]];
		
		start = end;
		
	}
	
	LDSubplot *subPlot = [[LDSubplot alloc] initWithStart:start andEnd:end];
	
	[currPlot curveToPoint:end
			 controlPoint1:[subPlot bottomRight] 
			 controlPoint2:[subPlot topLeft]];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSMutableArray *)graphPoints {
	
	NSMutableArray *plots = [NSMutableArray arrayWithCapacity:[dataPoints count]];
	
	NSInteger i = 0;
	NSInteger totalArrs = [dataPoints count];
	for (NSArray *mainArr in dataPoints) {
		
		if (i != totalArrs-1) {
			
			NSBezierPath *thePath = [NSBezierPath bezierPath];
			[thePath moveToPoint:NSMakePoint(0.0, NSMidY(graphArea))];
			
			[self graphOnPlot:thePath forwardsFor:mainArr];
			
			NSPoint endPoint = NSMakePoint(NSMaxX(graphArea), NSMidY(graphArea));
			LDSubplot *subPlot = [[LDSubplot alloc] initWithStart:[thePath currentPoint]
														   andEnd:endPoint];
			[thePath curveToPoint:endPoint
					controlPoint1:[subPlot bottomRight] 
					controlPoint2:[subPlot topLeft]];
			
			NSArray *nextArr = [dataPoints objectAtIndex:i+1];
			[self graphOnPlot:thePath backwardsFor:nextArr];
			
			endPoint = NSMakePoint(NSMinX(graphArea), NSMidY(graphArea));
			subPlot = [[LDSubplot alloc] initWithStart:[thePath currentPoint]
												andEnd:endPoint];
			[thePath curveToPoint:endPoint
					controlPoint1:[subPlot bottomRight] 
					controlPoint2:[subPlot topLeft]];
			
			[[NSColor blackColor] set];
			[thePath setLineWidth:3.0];
			[thePath stroke];
			[plots addObject:thePath];
			
		}
		
		i++;
		
	}
	
	return plots;
	
}

@end
