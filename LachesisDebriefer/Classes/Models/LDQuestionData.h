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
	NSMutableArray *appData;
	
}

@property(assign) NSString *task;
@property(assign) NSDate *date;
@property(assign) NSMutableArray *appData;

- (id)initWithTask:(NSString *)iTask andDate:(NSDate *)iDate;

@end
