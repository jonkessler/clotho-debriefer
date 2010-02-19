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

#import "LDColorDB.h"
#import "LDPlot.h"
#import "LDPlot1.h"
#import "LDPlot2.h"
#import "LDPlot3.h"

@implementation LDGraph

@synthesize plots, metadata;

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 

- (id)initWithData:(NSArray *)points 
		   andRect:(NSRect)graphSpace 
		plotNumber:(NSInteger)plotNum
		  appNames:(NSArray *)appNames
			 dates:(NSMutableArray *)dates {
	
	if (self = [super init]) {
		
		graphArea = graphSpace;
		plotNum = 1;
		
		[NSBezierPath setDefaultLineJoinStyle:NSRoundLineJoinStyle];
		[NSBezierPath setDefaultFlatness:0.3];
		[NSBezierPath setDefaultMiterLimit:1.0];
		
		metadata = [[LDLoadedData alloc] initWithAppNames:appNames andTimeStamps:dates];
			
		plots = [NSMutableArray arrayWithCapacity:[points count]];
		
		NSInteger i = 0;
		LDPlot *plotToUse;
		
		// Line Graph
		if (plotNum == 0) {
			
			for (NSArray *setOfPoints in points) {
				
				NSString *currApp = [appNames objectAtIndex:i];
				
				plotToUse = [[LDPlot1 alloc] initWithPoints:setOfPoints 
													andRect:graphSpace
												  fillColor:[metadata colorForApp:currApp]];
				
				[plots addObject:plotToUse];
				i++;
				
			}
			
			// Color the plots
			NSInteger j = 0;
			NSArray *reverseApps = [[appNames reverseObjectEnumerator] allObjects];
			NSArray *reversePlots = [[plots reverseObjectEnumerator] allObjects];
			for (LDPlot *plot in reversePlots) {

				[[metadata colorForApp:[reverseApps objectAtIndex:j]] set];				
				[[plot path] setLineWidth:3.0];
				[[plot path] stroke];
				
				j++;
				
			}
			
		}			
		
		// Stacked Bar Graph		
		else if (plotNum == 1) {
			
			LDPlot2 *pl2 = [[LDPlot2 alloc] initWithPoints:points
												   andRect:graphSpace
												 fillColor:nil];
			
			[pl2 normalizeDataPoints];
			
			plots = [pl2 graphPoints];
			
			NSInteger j = 0;
			for (NSBezierPath *plot in plots) {
				
				[[NSColor blackColor] set];
				[plot setLineWidth:3.0];
				[plot stroke];
				
				[[metadata colorForApp:[appNames objectAtIndex:j]] set];
				[plot fill];
				
				j++;
				
			}
			
		}
		
		// Flow Graph
		else {
			
			LDPlot3 *pl3 = [[LDPlot3 alloc] initWithPoints:points 
												   andRect:graphSpace];
			
			plots = [pl3 graphPoints];

			NSInteger j = 0;
			for (NSBezierPath *plot in plots) {
				
				[[NSColor blackColor] set];
				[plot setLineWidth:3.0];
				[plot stroke];
				
				[[metadata colorForApp:[appNames objectAtIndex:j]] set];
				[plot fill];
				
				j++;
				
			}
			
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

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSRect)graphSpace {
	
	return graphArea;
	
}

@end
