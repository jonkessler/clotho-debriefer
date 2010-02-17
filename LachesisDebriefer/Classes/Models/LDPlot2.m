//
//  LDPlot2.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/16/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDPlot2.h"

#define NUM_POINTS 10

@implementation LDPlot2

@synthesize ySums;

- (id)init {
	
	if (self = [super init]) {
		
		graphSpace = NSZeroRect;
		ySums = [NSArray array];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    NSRect - rectangle represnting the view
//			 NSColor - color to fill the path with
// OUTPUT:   
// FUNCTION: recalculates each point in dataPoints

- (void)initializePathWithRect:(NSRect)graph
					 fillColor:(NSColor *)color {
	
	graphSpace = graph;
	
	NSInteger numPoints = [[dataPoints objectAtIndex:0] count];
	NSMutableArray *sums = [NSMutableArray arrayWithCapacity:numPoints];	
	NSInteger i;
	
	// 1. Sum up the value of each y-coord of each array at index i
	//
	for (i=0; i<numPoints; i++) {
		
		double sum = 0.0;
		for (NSArray *points in dataPoints)
			sum += [[points objectAtIndex:i] pointValue].y;
		
		[sums addObject:[NSNumber numberWithDouble:sum]];
		
	}
	
	ySums = [NSArray arrayWithArray:sums];
	
	// 2. Modify the data points accordingly
	// 
	double largest = 0.0;
	BOOL isFirstArr = YES;	
	NSMutableArray *newDataPoints = [NSMutableArray arrayWithCapacity:[dataPoints count]];
	NSMutableArray *newYVals = [NSMutableArray arrayWithCapacity:[sums count]];
	for (NSArray *points in dataPoints) {
		
		NSMutableArray *newPointsArr = [NSMutableArray arrayWithCapacity:[points count]];
		if (isFirstArr) {
			
			i=0;
			for (NSNumber *ySum in sums) {
				
				double yDub = [ySum doubleValue];
				NSPoint oldPoint = [[points objectAtIndex:i] pointValue];
				NSPoint newPoint = NSMakePoint(oldPoint.x, yDub);
				
				[newPointsArr addObject:[NSValue valueWithPoint:newPoint]];
				[newYVals addObject:ySum];
				
				if (yDub > largest)
					largest = yDub;
				
				i++;
				
			}
			
			isFirstArr = NO;
			
		}
		
		else {

			NSMutableArray *newNewYs = [NSMutableArray arrayWithCapacity:[newYVals count]];
			i=0;
			for (NSNumber *prevY in newYVals) {
				
				NSPoint oldPoint = [[points objectAtIndex:i] pointValue];
				double newY = [prevY doubleValue] - oldPoint.y;
				NSPoint newPoint = NSMakePoint(oldPoint.x, newY);
				
				[newPointsArr addObject:[NSValue valueWithPoint:newPoint]];
				[newNewYs addObject:[NSNumber numberWithDouble:newY]];
				
				i++;
				
			}			
			
			newYVals = newNewYs;
			
		}
		
		[newDataPoints addObject:newPointsArr];
		
	}
	
	// 3. Normalize all values by dividing by largest
	//
	NSMutableArray *normDataPoints = [NSMutableArray arrayWithCapacity:[newDataPoints count]];
	for (NSArray *pointsArr in newDataPoints) {
		
		NSMutableArray *normPointsArr = [NSMutableArray arrayWithCapacity:[sums count]];
		for (NSValue *point in pointsArr) {
			
			NSPoint oldPoint = [point pointValue];
			NSPoint normPoint = NSMakePoint(oldPoint.x, oldPoint.y/largest);
			[normPointsArr addObject:[NSValue valueWithPoint:normPoint]];
			
		}
		
		[normDataPoints addObject:normPointsArr];
		
	}
	
	dataPoints = normDataPoints;
	
}

- (void)initializePathWithRect:(NSRect)graph 
					 fillColor:(NSColor *)color
				  currentPlots:(NSArray *)curPlots {
	
	CGFloat height = NSHeight(graph);
	CGFloat width = NSWidth(graph);
	
	NSPoint start = NSMakePoint(0.0, 0.0);
	NSPoint end;
	
	path = [NSBezierPath bezierPath];	
	[path moveToPoint:start];
	
	CGFloat yCoord = 0.0;
	for (NSValue *point in dataPoints) {
		
		end = [point pointValue];
		end = NSMakePoint(end.x/NUM_POINTS * width, end.y);
		yCoord = [self yPointNotInPlots:curPlots atX:end.x];
		end = NSMakePoint(end.x, end.y*(height-yCoord)+yCoord);
		
		LDSubplot *subplot = [[LDSubplot alloc] initWithStart:start andEnd:end];
		
		[path curveToPoint:end
			 controlPoint1:[subplot bottomRight]
			 controlPoint2:[subplot topLeft]];
		
		start = end;
		
	}
	
	end = NSMakePoint(width, 0);	
	
	LDSubplot *subplot = [[LDSubplot alloc] initWithStart:start andEnd:end];
	[path curveToPoint:end
		 controlPoint1:[subplot bottomRight]
		 controlPoint2:[subplot topLeft]];
	
	[path lineToPoint:NSMakePoint(end.x, 0.0)];
	
	[[NSColor blackColor] set];
	[path setLineWidth:3.0];
	[path stroke];
	
	[color set];
	[path fill];	
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   NSArray - array of NSBezierPaths
// FUNCTION: plots the points in each array of dataPoints in graphSpace
 
- (NSMutableArray *)graphPoints {
	
	NSMutableArray *plots = [NSMutableArray arrayWithCapacity:[dataPoints count]];
	
	NSInteger i = 0;
	NSInteger totalArrs = [dataPoints count];
	for (NSArray *mainArr in dataPoints) {
	
		NSPoint start = NSMakePoint(NSMinX(graphSpace), NSMinY(graphSpace));
		if (i != totalArrs-1) {
			
			NSArray *nextArr = [dataPoints objectAtIndex:i+1];
			
			NSBezierPath *thePath = [NSBezierPath bezierPath];
			[thePath moveToPoint:start];
			
			[self graphOnPlot:thePath forwardsFor:mainArr];
			
			NSPoint endPoint = NSMakePoint(NSMaxX(graphSpace), 0.0);
			LDSubplot *subPlot = [[LDSubplot alloc] initWithStart:[thePath currentPoint]
														   andEnd:endPoint];
			[thePath curveToPoint:endPoint
					controlPoint1:[subPlot bottomRight] 
					controlPoint2:[subPlot topLeft]];			
			
			[self graphOnPlot:thePath backwardsFor:nextArr];
			
			endPoint = NSMakePoint(NSMinX(graphSpace), 0.0);
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
		
		else {
			
			NSBezierPath *thePath = [NSBezierPath bezierPath];
			[thePath moveToPoint:start];
			
			[self graphOnPlot:thePath forwardsFor:mainArr];

			NSPoint curPoint = [thePath currentPoint];
			NSPoint endPoint = NSMakePoint(NSMaxX(graphSpace), 0.0);
			LDSubplot *subPlot = [[LDSubplot alloc] initWithStart:curPoint 
														   andEnd:endPoint];
			[thePath curveToPoint:endPoint
					controlPoint1:[subPlot bottomRight] 
					controlPoint2:[subPlot topLeft]];
			
			[thePath closePath];
			[[NSColor blackColor] set];
			[thePath setLineWidth:3.0];
			[thePath stroke];
			[plots addObject:thePath];			
			
		}

		
		i++;
		
	}
	
	return plots;
	
}

// ****************************************************************************
// INPUT:    NSBezierPath - current path 
//			 NSArray - array of NSValue (NSPoint) objects 
// OUTPUT:   
// FUNCTION: backwards graphing of each point in points on currPlot. Assume 
//			 currPlot is already at the starting point
 
- (void)graphOnPlot:(NSBezierPath *)currPlot backwardsFor:(NSArray *)points {
	
	CGFloat height = NSHeight(graphSpace) * 0.90;
	CGFloat width = NSWidth(graphSpace);
	
	NSPoint start = [currPlot currentPoint];
	NSPoint end;
	
	NSArray *reversePoints = [[points reverseObjectEnumerator] allObjects];
	NSInteger total = [reversePoints count] + 1;
	
	for (NSValue *point in reversePoints) {
		
		end = [point pointValue];
		end = NSMakePoint(end.x/total * width, end.y * height);
		
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

	CGFloat height = NSHeight(graphSpace) * 0.90;
	CGFloat width = NSWidth(graphSpace);
	
	NSPoint start = [currPlot currentPoint];
	NSPoint end;
	
	NSInteger total = [points count] + 1;
	
	for (NSValue *point in points) {
		
		end = [point pointValue];
		end = NSMakePoint(end.x/total * width, end.y * height);
		
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

- (NSMutableArray *)plot2DataPoints {
	
	return dataPoints;
	
}

@end
