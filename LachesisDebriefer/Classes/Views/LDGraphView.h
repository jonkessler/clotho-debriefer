//
//  QuartzView.h
//
//  Created by Joseph Subida on 1/4/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDColorKey.h"
#import "LDDebriefFile.h"
#import "LDGraph.h"

@interface LDGraphView : NSView {

	IBOutlet LDColorKey *colorKey;
	
	LDDebriefFile *debriefFile;
	
	LDGraph *theGraph;	
	NSMutableArray *coordinates;
	NSMutableArray *paths;
	NSBezierPath *dot;
	NSBezierPath *correctDot;
	NSPoint correctPoint;
	NSInteger plotNum;
	NSArray *appNames;
	
}

@property (assign, readonly) LDColorKey *colorKey;
@property (assign) LDDebriefFile *debriefFile;
@property (assign, readonly) NSMutableArray *coordinates;

- (id)initWithDebriefFile:(LDDebriefFile *)debrief andFrame:(NSRect)theFrame;
- (id)initWithDebriefFile:(LDDebriefFile *)debrief;

- (void)generateNewGraph;

- (NSMutableArray *)chooseRandomDataPoints;

- (void)determineCorrectPoint;

- (void)drawXYAxisInContext:(CGContextRef)contextA;

- (BOOL)isCorrectForPoint:(NSPoint)myGuess;
- (BOOL)isValid:(NSPoint)point;

- (void)mouseMovedInMe:(NSEvent *)event;

@end