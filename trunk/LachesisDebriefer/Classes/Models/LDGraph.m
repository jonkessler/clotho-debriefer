//
//  LDGraph.m
//  QuartzBox
//
//  Created by Joseph Subida on 1/8/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//
//  What's Here:
//  App-Color Name
//  Random Selection of Plots

#import "LDGraph.h"
#import "LDPlot.h"
#import "LDPlot1.h"
#import "LDPlot2.h"
#import "LDPlot3.h"

@implementation LDGraph

@synthesize plots, metadata;

// ****************************************************************************
// INPUT:    NSMutableArray - array of arrays of points
// OUTPUT:   NSArray - array of the average each corresponding point
// FUNCTION: averages the corresponding points in each array

- (NSArray *)averageOfPoints:(NSArray *)arrOfPoints {
	
	if ([arrOfPoints count] == 0)
		return [NSArray array];
	
	NSInteger numArrays = [arrOfPoints count];	
	NSInteger numPoints = [[arrOfPoints objectAtIndex:0] count];
	
	NSMutableArray *averages = [NSMutableArray arrayWithCapacity:numPoints];	
	
	//
	// 1. get every point i in array1, array2, array3, ...
	//
	
	// loop through every point 
	NSInteger i;
	for (i=0; i<numPoints; i++) {
		
		// loop through every array of points
		CGFloat largest = 0.0;
		for (NSArray *points in arrOfPoints) {
			
			//
			// 2. determine the largest y value
			//
			CGFloat pointY = [[points objectAtIndex:i] pointValue].y;
			if (pointY > largest)
				largest = pointY;
			
		}
		
		//
		// 3. average for this group of points i = largest/(number of points)
		//
		CGFloat average = largest/numArrays;
		
		[averages addObject:[NSNumber numberWithDouble:average]];
		
	}
	
	return [NSArray arrayWithArray:averages];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 

- (id)initWithData:(NSArray *)points 
		   andRect:(NSRect)graphSpace 
		plotNumber:(NSInteger)plotNum {
	
	if (self = [super init]) {
		
		plotNum = 1;
		
		[NSBezierPath setDefaultLineJoinStyle:NSRoundLineJoinStyle];
		[NSBezierPath setDefaultFlatness:0.3];
		[NSBezierPath setDefaultMiterLimit:1.0];
		
		metadata = [[LDLoadedData alloc] init];		
		
		NSArray *colors = [NSArray arrayWithObjects:
						   [NSColor redColor],						   
						   [NSColor blueColor], 
						   [NSColor greenColor], nil];
		
		plots = [NSMutableArray arrayWithCapacity:[points count]];
		
		NSInteger i = 0;
		LDPlot *plotToUse;
		
		// Line Graph
		if (plotNum == 0) {
			
			for (NSArray *setOfPoints in points) {
				
				plotToUse = [[LDPlot1 alloc] initWithPoints:setOfPoints 
													andRect:graphSpace
												  fillColor:[colors objectAtIndex:i]];
				
				[plots addObject:plotToUse];
				[[metadata appColors] setObject:[colors objectAtIndex:i] 
										 forKey:[NSString stringWithFormat:@"app %d", i]];
				i++;
				
			}
			
			// Color the plots
			NSInteger j = 0;
			NSArray *reversePlots = [[plots reverseObjectEnumerator] allObjects];
			for (LDPlot *plot in reversePlots) {
				
				[[NSColor blackColor] set];
				[[plot path] setLineWidth:3.0];
				
				[[colors objectAtIndex:j] set];
				[[plot path] stroke];
				
				j++;
				
			}
			
		}			
		
		// Stacked Bar Graph		
		else if (plotNum == 1) {
			
			LDPlot2 *pl2 = [[LDPlot2 alloc] initWithPoints:points
												   andRect:graphSpace
												 fillColor:nil];
			
			plots = [pl2 graphPoints];
			
			NSInteger j = 0;
			for (NSBezierPath *plot in plots) {
				
				[[NSColor blackColor] set];
				[plot setLineWidth:3.0];
				[plot stroke];
				
				[[colors objectAtIndex:j] set];
				[plot fill];
				
				j++;
				
			}
			
		}
		
		// Flow Graph
		else {
			
			LDPlot3 *pl3 = [[LDPlot3 alloc] initWithPoints:points 
												   andRect:graphSpace];
			
		}
		
	}
	
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 

- (LDPlot *)plotContainingPoint:(NSPoint)p {
	
	NSArray *reversePlots = [[plots reverseObjectEnumerator] allObjects];
	for (LDPlot *aPlot in reversePlots) {
		
		if ([aPlot containsPoint:p])
			return aPlot;
		
	}
	
	return nil;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 

- (NSInteger)plotNumberContainingPoint:(NSPoint)p {
	
	LDPlot *plotContainingPoint = [self plotContainingPoint:p];
	
	if (plotContainingPoint)
		return [plots indexOfObject:plotContainingPoint];
	else
		return -1;
	
}

@end
