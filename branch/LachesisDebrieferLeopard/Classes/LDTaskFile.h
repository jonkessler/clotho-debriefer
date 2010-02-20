//
//  LDDebriefFile.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/9/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDTaskFile : NSObject {

	NSMutableArray *debriefLines; // array of LDDebriefLines

	// of the form: 
	// fileDate -> LDQuestionData
	// LDQuestionData.appData[dLineDate] -> appsAndPoints[app] -> LDAppData
	NSMutableDictionary *calculatedDataPoints; 
	NSMutableDictionary *datesForFile;
	
}

@property(assign) NSMutableArray *debriefLines;
@property(assign) NSMutableDictionary *calculatedDataPoints;
@property(assign) NSMutableDictionary *datesForFile;

- (id)initWithTaskPath:(NSString *)taskPath;

- (NSDate *)dateOfTaskFile;

- (NSMutableArray *)taskDates;

@end
