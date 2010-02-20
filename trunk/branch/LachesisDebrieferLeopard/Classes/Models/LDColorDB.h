//
//  LDColorDB.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/18/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDColorDB : NSObject {

	NSSet *fieldSpecificTools;
	NSSet *imageTools;
	NSSet *media;
	NSSet *pim;
	NSSet *system;
	NSSet *workTools;
	NSSet *web;

	NSMutableDictionary *appColors;

	NSMutableSet *usedColors;
	
}

- (NSColor *)adjustForUsedColor:(NSColor *)maybeUsed
					  forAppSet:(NSSet *)appSet;

- (NSColor *)colorForApp:(NSString *)app;

@end
