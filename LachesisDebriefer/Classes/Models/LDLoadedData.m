//
//  LDLoadedData.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDLoadedData.h"

#import "LDColorDB.h"

@implementation LDLoadedData

@synthesize appColors, timeStamps;

- (id)init {
	
	if (self = [super init]) {
		
		appColors = [NSMutableDictionary dictionary];
		timeStamps = [NSMutableArray array];
		
	}
	
	return self;
	
}

- (id)initWithAppNames:(NSArray *)appNames {
	
	if (self = [super init]) {
		
		LDColorDB *colorsList = [[LDColorDB alloc] init];
		appColors = [NSMutableDictionary dictionary];
		for (NSString *app in appNames) {
			
			[appColors setObject:[colorsList colorForApp:app] forKey:app];
			
		}
		
		timeStamps = [NSMutableArray array];
		
	}
	
	return self;
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (NSColor *)colorForApp:(NSString *)app {
	
	return [appColors objectForKey:app];
	
}

@end
