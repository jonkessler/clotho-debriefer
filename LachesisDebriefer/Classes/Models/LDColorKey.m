//
//  LDColorKey.m
//  QuartzBox
//
//  Created by Joseph Subida on 1/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDColorDB.h"
#import "LDColorKey.h"
#import "LDButtonCell.h"

@implementation LDColorKey

@synthesize namesAndColors;

#pragma mark -
#pragma mark Class Methods Overridden

- (void)awakeFromNib {
	
	NSSize cellSpace = NSMakeSize(2.0, 2.0);
	[self setIntercellSpacing:cellSpace];
	keyCount = 0;
	
}

- (BOOL)isFlipped {
	
	return YES;
	
}

#pragma mark -
#pragma mark Helper Methods

// ****************************************************************************
// INPUT:    numRows - number of rows in this matrix
//			 numCols - number of cols in this matrix
// OUTPUT:   
// FUNCTION: traslates the Y-coord based on the number of rows in this matrix

//- (void)resizeForNumRows:(NSInteger)numRows andCols:(NSInteger)numCols {
//	
//	NSRect oldRect = [self frame];
//	CGFloat newX = NSMinX(oldRect);
//	CGFloat newY = NSMinY(oldRect) - (1/2) * (numRows-1) * NSHeight(oldRect);
//	
//	[self renewRows:numRows columns:numCols];
//	
//	NSRect newRect = NSMakeRect(newX, newY, NSWidth(oldRect), NSHeight(oldRect));
//	[self setFrame:newRect];
//	
//	[self sizeToCells];
//	
//}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: loads the app-color keys based on namesAndColors

- (NSCell *)tableView:(NSTableView *)tableView 
dataCellForTableColumn:(NSTableColumn *)tableColumn 
				  row:(NSInteger)row {
	
	LDColorDB *colorDB = [[LDColorDB alloc] init];
	NSArray *allKeys = [namesAndColors allKeys];
	allKeys = [allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSString *aKey = [allKeys objectAtIndex:keyCount];
	NSInteger numKeys = [allKeys count];
	NSSize colorSize = NSMakeSize(10.0, 10.0);
	
	// Determining number of rows and cols
	//	NSInteger numRows = numKeys % 6;
	
	NSInteger numCols;
	if (numKeys < 6) 
		numCols = numKeys;
	else
		numCols = 6;
	
	//	[self resizeForNumRows:numRows andCols:numCols];
	
	//	NSInteger row = 0;
	//	NSInteger col = 0;	
	//	for (NSString *aKey in allKeys) {
	
	//		LDButtonCell *cell = [self cellAtRow:row column:tableColumn];
	
	NSCell *cell = [[NSCell alloc] initTextCell:aKey];		
	// Creating key's title
	//		[cell setTitle:aKey];
	
	// Creating key's color
	NSBitmapImageRep *newImageRep = 
	[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL 
											pixelsWide:colorSize.width
											pixelsHigh:colorSize.height 
										 bitsPerSample:8 
									   samplesPerPixel:4 
											  hasAlpha:YES 
											  isPlanar:NO
										colorSpaceName:@"NSDeviceRGBColorSpace"
										   bytesPerRow:0 
										  bitsPerPixel:0];
	
	NSColor *currColor = [colorDB colorForApp:aKey];
	NSInteger i, j;
	for (i=0; i<colorSize.width; i++)
		for (j=0; j<colorSize.height; j++)
			[newImageRep setColor:currColor atX:i y:j];
	
	NSImage *colorImg = [[NSImage alloc] initWithSize:colorSize];
	[colorImg addRepresentation:newImageRep];
	
	[cell setImage:colorImg];
	
	//		if ( (keyCount % 5 == 0) && (col != 0) ) {
	//			[self renewRows:row++ columns:5];
	//			[self sizeToCells];
	//			col = 0;
	//		}
	//		else
	//			col++;
	
	keyCount++;
	
	//	while (col < numCols) {
	//		
	//		[[self cellAtRow:row column:col] setTransparent:YES];
	//		col++;
	//		
	//	}
	//	
	//	[self sizeToCells];
	
	return cell;
	
}

@end
