//
//  LDPlot1.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/15/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDPlot1.h"

#define NUM_POINTS 10

@implementation LDPlot1

// ****************************************************************************
// INPUT:    NSRect - rectangle represnting the view
//			 NSColor - color to fill the path with
// OUTPUT:   
// FUNCTION: generates graph #1

- (void)initializePathWithRect:(NSRect)graphSpace 
					 fillColor:(NSColor *)fillColor {
	
	CGFloat height = NSHeight(graphSpace);
	CGFloat width = NSWidth(graphSpace);
	
	NSPoint start = NSMakePoint(0.0, 0.0);
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
	
	end = NSMakePoint(width, 0);
	
	LDSubplot *subplot = [[LDSubplot alloc] initWithStart:start andEnd:end];
	[path curveToPoint:end
		 controlPoint1:[subplot bottomRight]
		 controlPoint2:[subplot topLeft]];
	
	[path lineToPoint:NSMakePoint(end.x, 0.0)];
	
	[path setLineWidth:3.0];
	[fillColor set];
	
	[path stroke];
	
}

@end
