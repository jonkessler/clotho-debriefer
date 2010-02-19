//
//  LDLoadingMaster.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 1/14/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDLoadingMaster.h"

#import "LDAppData.h"
#import "LDFileIO.h"
#import "LDQuestionData.h"
#import "LDReadInFile.h"
#import "LDTaskData.h"

#define LDLOG_PATH @"~/Library/Logs/Discipline"
#define DEBUG YES

// if in DEBUG mode, prints log message of the format: 
// -[Class functionName] ["ine" #] message 
#ifdef DEBUG 
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); 
#else 
#   define DLog(...) 
#endif 

// ALog always displays output regardless of the DEBUG setting 
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); 

@implementation LDLoadingMaster

- (id)initWithController:(LDLoadingViewController *)controller {
	
	if (self = [super init]) {
		
		debriefDate = [controller chosenDate];
		debriefFile = [[LDDebriefFile alloc] init];
		modeController = controller;
		
		questionsByDate = [NSMutableDictionary dictionary];
		
		progressTimer = [NSTimer scheduledTimerWithTimeInterval:100.0
														 target:self
													   selector:@selector(fireProgress) 
													   userInfo:nil 
														repeats:YES];
		
	}
	
	return self;
	
}

- (void)beginLoading {
	
	NSString *absPath = [LDLOG_PATH stringByExpandingTildeInPath];
	BOOL isDir;
	if (![[NSFileManager defaultManager] fileExistsAtPath:absPath isDirectory:&isDir]
		&& isDir) {
		
		DLog(@"***ERROR: ~/Library/Logs/Discipline does not exist!!!");
		return;
		
	}
		
	
	[self createFakeDebriefs];

//	[self applyJoshCodeToFakeDebriefs];

	[self applyTreeToFakeDebriefs];
	
	[self fireProgress];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)createFakeDebriefs {
	
	debriefDate = @"07-14-09";
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yy"];
	NSDate *theDate = [NSDate dateWithNaturalLanguageString:debriefDate];
	NSString *formattedDate = [formatter stringFromDate:theDate];
	
	LDFileIO *fileIO = [[LDFileIO alloc] initWithBasePath:LDLOG_PATH];
	
	NSString *fullPath = [[LDLOG_PATH stringByExpandingTildeInPath] 
						  stringByAppendingFormat:@"/Log/Debriefer/Debriefing_%@.log", 
						  formattedDate];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
		DLog(@"***ERROR: Debrief file does not exist at %@", fullPath);
		
	debriefFile = [fileIO readInDebriefFile:fullPath];
	[fileIO createReadInFileWithDebrief:debriefFile];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: code to run Java file from http://www.stackoverflow.com
//			 Runs Josh's code on the data for the given day
 
- (void)applyJoshCodeToFakeDebriefs {
	
	// TODO: make sure Josh's code writes to ~/Library/Logs/Discipline and 
	// works only for the given day
	
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/usr/bin/java"];
	[task setCurrentDirectoryPath:@"/Users/JC/Desktop"];
	
	NSArray *arguments = [NSArray arrayWithObjects:
						  @"-jar", @"LachesisData.jar", 
						  [@"~/Library/Logs/Discipline" stringByExpandingTildeInPath], nil];
	[task setArguments:arguments];
	
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput:pipe];
	
	NSFileHandle *file = [pipe fileHandleForReading];
	
	[task launch];
	
	NSData *data = [file readDataToEndOfFile];
	
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"return\n %@", string);
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)applyTreeToFakeDebriefs {
	
	// 1. read in tree
	//
	NSString *treePath = [[NSBundle mainBundle] pathForResource:@"tree" 
														 ofType:@"xml"];
	
	NSXMLDocument *treeXML;
    NSError *err=nil;
    NSURL *furl = [NSURL fileURLWithPath:treePath];
    if (!furl) {
        NSLog(@"Can't create an URL from file %@.", treePath);
        return;
    }
	
    treeXML = [[NSXMLDocument alloc] initWithContentsOfURL:furl
												  options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
													error:&err];
	
	if (treeXML == nil)
        treeXML = [[NSXMLDocument alloc] initWithContentsOfURL:furl
													  options:NSXMLDocumentTidyXML
														error:&err];
    
    if (treeXML == nil)  {
		
        if (err)
            DLog(@"%@",err);
        return;
		
    }
	
	// 2. generate data for each read-in file
	//
	NSArray *readInFiles = [LDFileIO readInFiles];
	for (LDReadInFile *readIn in readInFiles) {
		
		NSDate *fileDate = [readIn dateForFile];
		
		// TODO: uncomment to log actual tasks
//		LDTaskData *task = [LDFileIO taskForDate:fileDate];
		
//		LDQuestionData *question = 
//		[[LDQuestionData alloc] initWithTask:[[task data] objectForKey:@"Task"] 
//									 andDate:fileDate];
		LDQuestionData *question = 
		[[LDQuestionData alloc] initWithTask:@"Pooping"
									 andDate:fileDate];		
		
		for (NSString *debriefLine in [readIn lines]) {
			
			if ([debriefLine isEqualToString:@""])
				continue;
			
			NSDate *dLineDate = [readIn dateForLine:debriefLine];
			
			NSArray *titles = [LDFileIO titleDataForDate:dLineDate];
			NSArray *pids = [LDFileIO pidDataForDate:dLineDate];
			NSArray *appNames = [LDFileIO appNameDataForDate:dLineDate];
			NSArray *data = [LDFileIO rawDataForDate:dLineDate];

			NSMutableDictionary *appDataDict = [NSMutableDictionary dictionary];
			NSInteger i = 0;
			for (NSString *app in appNames) {
				
				LDAppData *appData = [[LDAppData alloc] initWithName:app 
														  andRawData:[data objectAtIndex:i] 
															 withPID:[[pids objectAtIndex:i] integerValue]];
				
				[appData associateTitleWithRawData:titles];
				
				// 3. apply tree!!!
				//
				NSDictionary *titleData = [appData titleRawData];
				NSXMLNode *aNode = [treeXML rootElement];
				aNode = [aNode nextNode];
				while (aNode != nil) {
					
					if ([[aNode name] isEqualToString:@"Output"]) {
						
						NSArray *attr = [(NSXMLElement *)aNode attributes];
						NSArray *vals = [[[attr objectAtIndex:1] objectValue]
										 componentsSeparatedByString:@"/"];
						
						double calculatedVal;
						if ([vals count] == 2)
							calculatedVal = [[vals objectAtIndex:1] doubleValue]/
							[[vals objectAtIndex:0] doubleValue];
						else
							calculatedVal = [[vals objectAtIndex:0] doubleValue];
						
						if ([[[attr objectAtIndex:0] objectValue] isEqualToString:@"0"])
							[appData setDataPoint:calculatedVal];
						
						else
							[appData setDataPoint:1-calculatedVal];							
						
						break;
							
					}
					
					NSArray *attributes = [(NSXMLElement*)aNode attributes];
					NSString *title = [[attributes objectAtIndex:0] objectValue];
					NSString *operator = [[attributes objectAtIndex:1] objectValue];
					double val = [[[attributes objectAtIndex:2] objectValue] doubleValue];
					double raw = [[titleData objectForKey:title] doubleValue];
					
					if ([operator isEqualToString:@"<="]) {
						
						if (raw <= val)
							aNode = [aNode childAtIndex:0];
						else
							aNode = [aNode nextSibling];
						
						
						
					}
					else {
						
						if (raw > val) 
							aNode = [aNode childAtIndex:0];
						
						else
							DLog(@"SHit. WTF??!?");
						
					}

					
					
				}
				
				[appDataDict setObject:appData forKey:app];
				
			}
			
			[[question appData] setObject:appDataDict forKey:dLineDate];
			
		}
		
		[questionsByDate setObject:question forKey:fileDate];
		
	}
	
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)fireProgress {
	
	[[modeController progressBar] incrementBy:100.0];
	
	if ([[modeController progressBar] doubleValue] >= 100.0) {
		
		[progressTimer invalidate];
		[modeController beginQuestions:debriefFile];
		
	}
		
	
}

@end
