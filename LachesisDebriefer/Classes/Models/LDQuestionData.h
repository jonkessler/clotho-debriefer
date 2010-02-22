//
//  LDQuestionData.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/17/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDQuestionData : NSObject {

	NSString *task;
	NSDate *date;
	NSMutableDictionary *appData;
	NSArray *uniqueAppNames;
	
}

@property(assign) NSString *task;
@property(assign) NSDate *date;
@property(assign) NSMutableDictionary *appData;
@property(assign) NSArray *uniqueAppNames;

- (id)initWithTask:(NSString *)iTask andDate:(NSDate *)iDate;

- (NSArray *)dataPointsForApp:(NSString *)app;

@end
