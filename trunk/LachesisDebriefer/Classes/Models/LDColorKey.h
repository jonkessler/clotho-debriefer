//
//  LDColorKey.h
//  QuartzBox
//
//  Created by Joseph Subida on 1/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDColorKey : NSMatrix {

	NSMutableDictionary *namesAndColors;
	
}

@property (assign) NSMutableDictionary *namesAndColors;

- (void)reloadKeys;

@end
