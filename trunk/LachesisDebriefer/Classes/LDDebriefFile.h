//
//  LDDebriefFile.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/9/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LDDebriefFile : NSObject {

	NSMutableArray *debriefLines; // array of LDDebriefLines

	// of the form: 
	// fileDate -> LDQuestionData
	// LDQuestionData.appData[dLineDate] -> appsAndPoints[app] -> LDAppData
	NSMutableDictionary *calculatedDataPoints; 
	NSMutableDictionary *dLineDatesForFile;
	
}

@property(assign) NSMutableArray *debriefLines;
@property(assign) NSMutableDictionary *calculatedDataPoints;
@property(assign) NSMutableDictionary *dLineDatesForFile;
- (id)initWithData:(NSData *)fileData;

- (NSDate *)dateOfDebriefFile;

- (NSMutableArray *)debriefDates;

@end
