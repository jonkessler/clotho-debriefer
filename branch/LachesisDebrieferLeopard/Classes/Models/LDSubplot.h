//
//  LDSubplot.h
//  QuartzBox
//
//  Created by Joseph Subida on 1/7/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDSubplot : NSObject {

	NSPoint start;
	NSPoint end;
	NSRect box;
	
}

- (id)initWithStart:(NSPoint)strt andEnd:(NSPoint)nd;

- (BOOL)endIsHigherThanStart;

- (NSPoint)bottomLeft;
- (NSPoint)bottomRight;
- (NSPoint)topLeft;
- (NSPoint)topRight;

@end
