//
//  LDLoadedData.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDLoadedData.h"


@implementation LDLoadedData

@synthesize appColors, timeStamps;

- (id)init {
	
	if (self = [super init]) {
		
		appColors = [NSMutableDictionary dictionary];
		timeStamps = [NSMutableArray array];
		
	}
	
	return self;
	
}

@end
