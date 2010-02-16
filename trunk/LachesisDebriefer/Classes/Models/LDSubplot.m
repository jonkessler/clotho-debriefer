//
//  LDSubplot.m
//  QuartzBox
//
//  Created by Joseph Subida on 1/7/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDSubplot.h"

#define XMultiplier 1.0
#define YMultiplier 1.0
#define BR_X 0.95
#define BR_Y 1.0
#define TL_X 1.05
#define TL_Y 1.0

@implementation LDSubplot

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (id)initWithStart:(NSPoint)strt andEnd:(NSPoint)nd {

	if (self = [super init]) {

		start = strt;
		end = nd;
		box = NSMakeRect(strt.x, strt.y, nd.x-strt.x, nd.y-strt.y);
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (BOOL)endIsHigherThanStart {
	
	return (end.y > start.y);
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSPoint)bottomLeft {

	return NSMakePoint(XMultiplier * NSMinX(box), YMultiplier * NSMinY(box));
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSPoint)bottomRight {
	
	return NSMakePoint(BR_X * NSMaxX(box), BR_Y * NSMinY(box));
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSPoint)topLeft {
	
	return NSMakePoint(TL_X * NSMinX(box), TL_Y * NSMaxY(box));
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSPoint)topRight {
	
	return NSMakePoint(XMultiplier * NSMaxX(box), YMultiplier * NSMaxY(box));
	
}

@end
