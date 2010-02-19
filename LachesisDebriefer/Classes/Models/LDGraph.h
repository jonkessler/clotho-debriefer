//
//  LDGraph.h
//  QuartzBox
//
//  Created by Joseph Subida on 1/8/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDLoadedData.h"
#import "LDPlot.h"

@interface LDGraph : NSObject {

	NSMutableArray *plots;
	LDLoadedData *metadata;	
	
	NSRect graphArea;
	
}

@property (assign, readonly) NSMutableArray *plots;
@property (assign, readonly) LDLoadedData *metadata;

- (id)initWithData:(NSArray *)points 
		   andRect:(NSRect)graphSpace 
		plotNumber:(NSInteger)plotNum
		  appNames:(NSArray *)appNames
			 dates:(NSMutableArray *)dates;

- (LDPlot *)plotContainingPoint:(NSPoint)p;
- (NSInteger)plotNumberContainingPoint:(NSPoint)p;

- (NSRect)graphSpace;

@end
