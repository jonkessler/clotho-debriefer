//
//  LDTaskData.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDTaskData : NSObject {
	
	NSString *name;
	NSDictionary *data;

}

@property (assign) NSString *name;
@property (assign) NSDictionary *data;

@end
