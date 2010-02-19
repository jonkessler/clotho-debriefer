//
//  LDTaskData.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDTaskData.h"


@implementation LDTaskData

@synthesize name, data;

- (id)init {
	
	if (self = [super init]) {
		
		name = @"";
		data = [NSDictionary dictionary];
		
	}
	
	return self;
	
}

@end
