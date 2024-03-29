//
//  QuartzView.h
//
//  Created by Joseph Subida on 1/4/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDColorKey.h"
#import "LDTaskFile.h"
#import "LDGraph.h"

@interface LDGraphView : NSView {

	IBOutlet LDColorKey *colorKey;
	
	LDTaskFile *debriefFile;
	NSMutableArray *availableDates;
	
	LDGraph *theGraph;	
	NSDate *currentDate;
	NSMutableArray *coordinates;
	NSMutableArray *paths;
	NSBezierPath *dot;
	NSBezierPath *correctDot;
	NSRect correctArea;
	NSInteger plotNum;
	NSArray *appNames;
	BOOL wasCorrect;
	
}

@property (assign, readonly) NSInteger plotNum;
@property (assign, readonly) LDColorKey *colorKey;
@property (assign) LDTaskFile *debriefFile;
@property (assign, readonly) NSMutableArray *coordinates;
@property (assign) NSDate *currentDate;
@property (assign, readonly) BOOL wasCorrect;

- (id)initWithDebriefFile:(LDTaskFile *)debrief andFrame:(NSRect)theFrame;
- (id)initWithDebriefFile:(LDTaskFile *)debrief;

- (void)generateNewGraph;

- (NSMutableArray *)chooseRandomDataPoints;

- (void)determineCorrectPoint;

- (void)drawXYAxisInContext:(CGContextRef)contextA;

- (BOOL)isCorrectForPoint:(NSPoint)myGuess;
- (BOOL)isValid:(NSPoint)point;

- (CGFloat)secondsAway;

- (void)mouseMovedInMe:(NSEvent *)event;

@end
