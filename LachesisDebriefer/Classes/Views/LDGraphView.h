//
//  QuartzView.h
//
//  Created by Joseph Subida on 1/4/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDColorKey.h"
#import "LDGraph.h"

@interface LDGraphView : NSView {

	IBOutlet LDColorKey *colorKey;
	
	LDGraph *theGraph;	
	NSMutableArray *coordinates;
	NSMutableArray *paths;
	NSBezierPath *dot;
	NSBezierPath *correctDot;
	NSPoint correctPoint;
	NSInteger plotNum;
	
}

@property (assign, readonly) LDColorKey *colorKey;

- (void)generateNewGraph;

- (void)determineCorrectPoint;

- (void)drawXYAxisInContext:(CGContextRef)contextA;

- (BOOL)isCorrectForPoint:(NSPoint)myGuess;
- (BOOL)isValid:(NSPoint)point;

- (void)mouseMovedInMe:(NSEvent *)event;

@end
