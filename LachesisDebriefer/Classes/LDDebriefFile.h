//
//  LDDebriefFile.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/9/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDDebriefFile : NSObject {

	NSArray *debriefLines;
	
}

- (id)initWithData:(NSData *)fileData;

@property(assign, readonly) NSArray *debriefLines;

@end
