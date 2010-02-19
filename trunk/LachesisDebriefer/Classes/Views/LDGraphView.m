//
//  QuartzView.m
//
//  Created by Joseph Subida on 1/4/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDGraphView.h"

#import "LDAppData.h"
#import "LDPlot.h"
#import "LDQuestionData.h"
#import "LDSubplot.h"
#import "LDFileIO.h"

#define USE_RANDOM_POINTS NO

#define NUM_PLOTS 3
#define NUM_POINTS 10

#define X_TOLERANCE 10
#define Y_TOLERANCE 10

@implementation LDGraphView

@synthesize colorKey, debriefFile, coordinates;

- (id)initWithDebriefFile:(LDDebriefFile *)debrief andFrame:(NSRect)theFrame {
	
	if (self = [super initWithFrame:theFrame]) {
		
		debriefFile = debrief;
		
	}
	
	return self;
	
}
- (id)initWithDebriefFile:(LDDebriefFile *)debrief  {
	
	if (self = [super init]) {
		
		debriefFile = debrief;
		
	}
	
	return self;
	
}

- (void)awakeFromNib {
	
	paths = [NSMutableArray array];
	dot = [NSBezierPath bezierPath];
	plotNum = random() % 3;
	
	[colorKey setNamesAndColors:[[theGraph metadata] appColors]];
	[colorKey reloadKeys];
		
}

- (void)drawRect:(NSRect)dirtyRect {
	
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	[self drawXYAxisInContext:context];
	
	theGraph = [[LDGraph alloc] initWithData:coordinates 
									 andRect:dirtyRect
								  plotNumber:plotNum
									appNames:appNames
									   dates:[debriefFile debriefDates]];
	
	paths = [theGraph plots];
	
	[colorKey setNamesAndColors:[[theGraph metadata] appColors]];
	[colorKey reloadKeys];
	
	[colorKey display];
	
	[[NSColor blackColor] set];
	[dot fill];
	
	[[NSColor cyanColor] set];
	[correctDot fill];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Generates 1 of the 3 graphs randomly
 
- (void)generateNewGraph {
	
	coordinates = [NSMutableArray array];
	
	if (USE_RANDOM_POINTS) {
			
		NSInteger i = 0;
		for (i=0; i<NUM_PLOTS; i++) 
			[coordinates addObject:[LDFileIO generateRandomPoints:NUM_POINTS]];
		
	}
	
	else {
		
		while ([coordinates count] == 0)
			coordinates = [NSMutableArray arrayWithArray:[self chooseRandomDataPoints]];
	}

	
	[self determineCorrectPoint];
	
	NSPoint p = NSMakePoint(0.0, 0.0);
	NSRect centeredRect = NSMakeRect(p.x, p.y, 0.0, 0.0);
	centeredRect = NSOffsetRect(centeredRect, -NSWidth(centeredRect)/2, -NSHeight(centeredRect)/2);
	dot = [NSBezierPath bezierPathWithOvalInRect:centeredRect];
	
	plotNum = random() % 3;
	
	[self setNeedsDisplay:YES];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 

- (NSMutableArray *)chooseRandomDataPoints {
	
	NSInteger randomLine = rand() % [[debriefFile debriefLines] count];
	
	NSDate *dDate = [[debriefFile debriefLines] objectAtIndex:randomLine];
	
	NSInteger index = [[debriefFile debriefLines] indexOfObject:dDate];
	[[debriefFile debriefLines] removeObjectAtIndex:index];
	
	LDQuestionData *qData = [[debriefFile calculatedDataPoints] objectForKey:dDate];
	
	NSMutableDictionary *appData = [qData appData];
	NSArray *readInDDates = [appData allKeys];
	readInDDates = [readInDDates sortedArrayUsingSelector:@selector(compare:)];
	
	NSArray *allApps = [qData uniqueAppNames];
	allApps = [allApps sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	appNames = [NSArray arrayWithArray:allApps];
	
	NSMutableDictionary *dataPointsDict = [NSMutableDictionary dictionary];
	for (NSString *app in allApps)
		[dataPointsDict setObject:[NSMutableArray array] forKey:app];
	
	for (NSDate *aDate in readInDDates) {
		
		NSDictionary *dataForDate = [appData objectForKey:aDate];
		NSArray *apps = [dataForDate allKeys];
		for (NSString *anApp in allApps) {
			
			if ([apps containsObject:anApp]) {
				
				LDAppData *appData = [dataForDate objectForKey:anApp];
				NSMutableArray *appArr = [dataPointsDict objectForKey:anApp];
				[appArr addObject:[NSNumber numberWithDouble:[appData dataPoint]]];
				
			}
			
			else {
				
				NSMutableArray *appArr = [dataPointsDict objectForKey:anApp];				
				[appArr addObject:[NSNumber numberWithDouble:0.0]];
				
			}
			
		}
			
	}
	
	NSMutableArray *dataCoordinates = [NSMutableArray array];
	for (NSString *app in allApps) {
		
		[dataCoordinates addObject:[dataPointsDict objectForKey:app]];
		
	}
	
	NSMutableArray *coordinatePoints = [NSMutableArray array];
	for (NSArray *arr in dataCoordinates) {
		
		double i = 0.0;
		NSMutableArray *appCoords = [NSMutableArray arrayWithCapacity:[arr count]];
		for (NSNumber *yCord in arr) {
			
			NSPoint coordinate = NSMakePoint(i, [yCord doubleValue]);
			[appCoords addObject:[NSValue valueWithPoint:coordinate]];
			i++;
			
		}
		
		[coordinatePoints addObject:appCoords];
		
	}
	
	return coordinatePoints;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Determines the actual answer based on the coordinates
 
- (void)determineCorrectPoint {
	
	correctPoint = NSMakePoint(100.0, 100.0);
	// TODO: figure out how to calculate the answer
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Draws 2 lines representing the X and Y axes 
 
- (void)drawXYAxisInContext:(CGContextRef)contextA {
	
	CGFloat heightBound = super.bounds.size.height;
	CGFloat  widthBound = super.bounds.size.width;
	CGContextSetLineWidth(contextA,1.0);
	CGContextSetRGBStrokeColor(contextA, 0.0, 0.0, 0.0, 1.0);
	
	// Draw X-axis
	CGContextMoveToPoint(contextA, 0.0f, 0.0f);
	CGContextAddLineToPoint(contextA,widthBound , 0.0f);
	CGContextStrokePath(contextA);
	
	// Draw Y-axis
	CGContextMoveToPoint(contextA, 0.0f, 0.0f);
	CGContextAddLineToPoint(contextA, 0.0f, heightBound);
	CGContextStrokePath(contextA);
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Determines whether user's guess is 'correct'
 
- (BOOL)isCorrectForPoint:(NSPoint)myGuess {
	
	NSPoint lowerBound = NSMakePoint(correctPoint.x - X_TOLERANCE, 
									 correctPoint.y - Y_TOLERANCE);
	NSPoint upperBound = NSMakePoint(correctPoint.x + X_TOLERANCE, 
									 correctPoint.y + Y_TOLERANCE);
	
	if (myGuess.x > lowerBound.x && myGuess.x < upperBound.x
		&& myGuess.y > lowerBound.y && myGuess.y < upperBound.y)
		return TRUE;
	else
		return FALSE;
	
}

// ****************************************************************************
// INPUT:    NSPoint - point to check if valid
// OUTPUT:   
// FUNCTION: Determines if the point of the click is correct (within at least 
//			 one of the graphs)
 
- (BOOL)isValid:(NSPoint)point {
	
	for (NSBezierPath *path in paths) {
		
		if ([path containsPoint:point])
			return YES;
		
	}
	
	return NO;
	
}

#pragma mark -
#pragma mark Mouse Events

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Handles mouse click

- (void)mouseDown:(NSEvent *)event {

	// determine where clicked
	NSPoint p = [event locationInWindow];
	p = [self convertPoint:p fromView:nil];
	
	NSRect centeredRect = NSMakeRect(p.x, p.y, 5.0, 5.0);
	centeredRect = NSOffsetRect(centeredRect, 
								-NSWidth(centeredRect)/2, -NSHeight(centeredRect)/2);
	
	if ([self isValid:p]) {
		
		dot = [NSBezierPath bezierPathWithOvalInRect:centeredRect];
		// determine if click is correct
		if (![self isCorrectForPoint:p]) {
			
			[self display];
			
			NSRunInformationalAlertPanel(@"FAIL.", @"You are wrong.", @"Whimper", nil, nil);
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"wrongAnswer" 
																object:nil];
			
		}
		
		else {
			
			[self display];
			NSInteger ret = NSRunInformationalAlertPanel(@"WIN.", @"You are right.", @"Cheers", 
														 nil, nil);
			
			if (ret == 1) 
				[[NSNotificationCenter defaultCenter] postNotificationName:@"rightAnswer" 
																	object:nil];
			
		}
		
		// determine the correct point
		p = correctPoint;
		centeredRect = NSMakeRect(p.x, p.y, 5.0, 5.0);
		centeredRect = NSOffsetRect(centeredRect, 
									-NSWidth(centeredRect)/2, 
									-NSHeight(centeredRect)/2);
		correctDot = [NSBezierPath bezierPathWithOvalInRect:centeredRect];
		
		[self setNeedsDisplay:YES];
		
	}
	
	else
		NSRunInformationalAlertPanel(@"Oops!", 
									 @"Please click somewhere within one of the plots!", 
									 @"OK", nil, nil);
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: Used for tracking the mouse
 
- (void)mouseMovedInMe:(NSEvent *)event {
	
	NSPoint winP = [event locationInWindow];

	NSPoint p = [self convertPoint:winP fromView:nil];
	
	NSInteger index = [theGraph plotNumberContainingPoint:p];
	if (index > -1)
		NSLog(@"Point in plot %d", index);
	
}

@end
