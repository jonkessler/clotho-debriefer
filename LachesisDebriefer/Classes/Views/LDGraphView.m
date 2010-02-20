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

#define DEBUG YES

// if in DEBUG mode, prints log message of the format: 
// -[Class functionName] ["ine" #] message 
#ifdef DEBUG 
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); 
#else 
#   define DLog(...) 
#endif 

// ALog always displays output regardless of the DEBUG setting 
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); 

#define USE_RANDOM_POINTS NO

#define NUM_PLOTS 3
#define NUM_POINTS 10

#define X_TOLERANCE 10
#define Y_TOLERANCE 10

@implementation LDGraphView

@synthesize colorKey, debriefFile, coordinates, currentDate, plotNum, wasCorrect;

- (id)initWithDebriefFile:(LDTaskFile *)debrief andFrame:(NSRect)theFrame {
	
	if (self = [super initWithFrame:theFrame]) {
		
		debriefFile = debrief;
		availableDates = [debriefFile debriefDates];
		
	}
	
	return self;
	
}
- (id)initWithDebriefFile:(LDTaskFile *)debrief  {
	
	if (self = [super init]) {
		
		debriefFile = debrief;
		availableDates = [debriefFile debriefDates];
	}
	
	return self;
	
}

- (void)setDebriefFile:(LDTaskFile *)dFile {
	
	debriefFile = dFile;
	availableDates = [debriefFile debriefDates];
	
}

- (void)awakeFromNib {
	
	paths = [NSMutableArray array];
	dot = [NSBezierPath bezierPath];
	availableDates = [NSMutableArray array];
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
	
	[[NSColor redColor] set];
	[dot fill];
	
	[[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.5] set];
	[correctDot fill];
	[correctDot stroke];
	
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
		
		while ([coordinates count] == 0) {
			if ([availableDates count] == 0) {
				
				NSRunInformationalAlertPanel(@"Done!", @"Thank you for debriefing today.", 
											 @"OK", nil, nil);
				
				NSString *oldDebriefs = [@"~/Library/Logs/Discipline/Log/OldDebriefs" 
										 stringByExpandingTildeInPath];
				
				NSFileManager *defMan = [NSFileManager defaultManager];
				if (![defMan fileExistsAtPath:oldDebriefs]) 
					[defMan createDirectoryAtPath:oldDebriefs
					  withIntermediateDirectories:NO
									   attributes:nil
											error:nil];
				
				NSString *moveFrom = [@"~/Library/Logs/Discipline/Log/lachisisDebriefs" 
									  stringByExpandingTildeInPath];
				
				NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
				[formatter setDateFormat:@"MM-dd-yy"];
				
				NSString *moveTo = [oldDebriefs stringByAppendingFormat:
									@"/lachisisDebriefs_%@", [formatter stringFromDate:currentDate]];
				
				if(![defMan moveItemAtPath:moveFrom toPath:moveTo error:nil])
					DLog(@"***ERROR: unable to archive lachisisDebriefs");
				
				[[NSNotificationCenter defaultCenter] postNotificationName:@"terminate" 
																	object:nil];
				
			}
				
			coordinates = [NSMutableArray arrayWithArray:[self chooseRandomDataPoints]];
		}
			
	}

	
	[self determineCorrectPoint];
	
	NSPoint p = NSMakePoint(0.0, 0.0);
	NSRect centeredRect = NSMakeRect(p.x, p.y, 0.0, 0.0);
	centeredRect = NSOffsetRect(centeredRect, 
								-NSWidth(centeredRect)/2, 
								-NSHeight(centeredRect)/2);
	dot = [NSBezierPath bezierPathWithOvalInRect:centeredRect];
	
	plotNum = random() % 3;
	
	[self setNeedsDisplay:YES];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 

- (NSMutableArray *)chooseRandomDataPoints {
	
	NSInteger randomLine = rand() % [availableDates count];
	
	NSDate *dDate = [availableDates objectAtIndex:randomLine];
	
	currentDate = dDate;
	
	NSInteger index = [availableDates indexOfObject:dDate];
	[availableDates removeObjectAtIndex:index];
	
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
	
	NSArray *dDates = [[debriefFile datesForFile] objectForKey:currentDate];
	dDates = [dDates sortedArrayUsingSelector:@selector(compare:)];
	
	NSDate *cstDate = [NSDate dateWithNaturalLanguageString:[[[currentDate description] substringToIndex:19] stringByAppendingString:@" -0500"]];
	
	NSInteger index = [dDates indexOfObject:cstDate];
	
	NSRect graphArea = [theGraph graphSpace];
	
	correctArea = NSMakeRect(index/16.0 * NSWidth(graphArea), 0.0, 
							 (index+1)/16.0 * NSWidth(graphArea), NSHeight(graphArea));
	
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
	
	if (NSPointInRect(myGuess, correctArea))
		wasCorrect = YES;
	else
		wasCorrect = NO;
	
	return wasCorrect;
	
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
	
	NSRect centeredRect = NSMakeRect(p.x, p.y, 10.0, 10.0);
	centeredRect = NSOffsetRect(centeredRect, 
								-NSWidth(centeredRect)/2, -NSHeight(centeredRect)/2);
	
	if ([self isValid:p]) {
		
		dot = [NSBezierPath bezierPathWithOvalInRect:centeredRect];
		
		// determine the correct point
		[self determineCorrectPoint];
		correctDot = [NSBezierPath bezierPathWithRect:correctArea];
		
		// determine if click is correct
		if (![self isCorrectForPoint:p]) {
			
			[self display];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"wrongAnswer" 
																object:nil];
			
		}
		
		else {
			
			[self display];
			NSInteger ret = NSRunInformationalAlertPanel(@"Correct.", nil, @"OK", 
														 nil, nil);
			
			if (ret == 1) 
				[[NSNotificationCenter defaultCenter] postNotificationName:@"rightAnswer" 
																	object:nil];
			
		}
		
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
// FUNCTION: 
 
- (CGFloat)secondsAway {
	
	NSArray *sortedDates = [[debriefFile datesForFile] objectForKey:currentDate];
	NSTimeInterval totalSecs = abs([[sortedDates lastObject] timeIntervalSinceDate:
									[sortedDates objectAtIndex:0]]);
	
	CGFloat minRight = NSMinX(correctArea);
	CGFloat maxRight = NSMaxX(correctArea);
	
	NSRect graphArea = [theGraph graphSpace];
	CGFloat width = NSWidth(graphArea);
	
	NSPoint clicked = [dot currentPoint];
	
	CGFloat secondsAway = 0.0;
	if (abs(clicked.x-maxRight) > abs(clicked.x-minRight)) {
		
		secondsAway = abs( (((clicked.x/width) * totalSecs)
							- (((minRight/width) * totalSecs))) );
		
	}
	
	else {
		
		secondsAway = abs( (((clicked.x/width) * totalSecs)
							- (((maxRight/width) * totalSecs))) );

		
	}

	return secondsAway;
						
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
