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
	
}

@property(assign) NSMutableArray *debriefLines;
@property(assign) NSMutableDictionary *calculatedDataPoints;

- (id)initWithData:(NSData *)fileData;

- (NSDate *)dateOfDebriefFile;

@end
