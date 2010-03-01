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
		debriefFile = [[LDTaskFile alloc] init];
		modeController = controller;
		
		questionsByDate = [NSMutableDictionary dictionary];
		
		loadingCounter = 0;
		
		loadingText = [NSArray arrayWithObjects:
					   @"Loading files...",
					   @"Reading tasks...",
					   @"Doing calculations...",
					   @"Applying model...",
					   @"Reading your mind...", // 5
					   @"Determining your ancestral history...",
					   @"Pulling your information from a different dimension...",
					   @"Doing quantum calculations...",
					   @"Asking an alien for help...",
					   @"Realizing it was useless and doing it on my own...", // 10
					   @"Giving up and playing with a puppy...",
					   @"Getting back to work...",
					   @"Googling what to do...",
					   @"Having a breakthrough moment and furiously working to meet the deadline...",
					   @"Taking a nap...", // 15
					   @"Waking up and doing more calculations...",
					   @"Teaching a kitty how to use my calculator...",
					   @"Hiring an infinite number of monkeys to do the work...",
					   @"Letting you know that this is where the progress bar stalls and you have to wait longer without any feedback...", nil]; // 19
		
		progressTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
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

	// TODO: uncomment to use jar file
//	[self applyJoshCodeToFakeDebriefs];

	[self applyTreeToFakeDebriefs];
	
	[self finishProgress];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)createFakeDebriefs {
	
	// TODO: delete to use actual date selected
//	debriefDate = @"07-14-09";
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *theDate = [NSDate dateWithNaturalLanguageString:debriefDate];
	NSString *formattedDate = [formatter stringFromDate:theDate];
	
	LDFileIO *fileIO = [[LDFileIO alloc] initWithBasePath:LDLOG_PATH];
	
	NSString *fullPath = [[LDLOG_PATH stringByExpandingTildeInPath] 
						  stringByAppendingFormat:@"/Tasks/Task_%@.plist", 
						  formattedDate];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
		DLog(@"***ERROR: Debrief file does not exist at %@", fullPath);
		
	debriefFile = [fileIO readInTaskFile:fullPath];
	[fileIO createReadInFileWithTask:debriefFile];
	
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: code to run Java file from http://www.stackoverflow.com
//			 Runs Josh's code on the data for the given day
 
- (void)applyJoshCodeToFakeDebriefs {
	
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/usr/bin/java"];
	[task setCurrentDirectoryPath:@"/Applications/Lachesis/Resources"];
	
	NSArray *arguments = [NSArray arrayWithObjects:
						  @"-jar", @"ClothesisData.jar", 
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
												  options:(NSXMLNodePreserveWhitespace|
														   NSXMLNodePreserveCDATA)
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
	
	[debriefFile setDebriefLines:[NSMutableArray array]];
	
	// 2. generate data for each read-in file
	//
	NSArray *readInFiles = [LDFileIO readInFiles];
	for (LDReadInFile *readIn in readInFiles) {
		
		NSDate *fileDate = [readIn dateForFile];
		NSMutableArray *allAppNames = [NSMutableArray array];
		
		[[debriefFile debriefLines] addObject:fileDate];
		
		// TODO: double check calculations
		LDTaskData *task = [LDFileIO taskForDate:fileDate];
		
		LDQuestionData *question = 
		[[LDQuestionData alloc] initWithTask:[[task data] objectForKey:@"name"] 
									 andDate:fileDate];
		
		NSMutableArray *dlineDates = [NSMutableArray array];
		for (NSString *debriefLine in [readIn lines]) {
			
			if ([debriefLine isEqualToString:@""])
				continue;
			
			NSDate *dLineDate = [readIn dateForLine:debriefLine];
			
			[dlineDates addObject:dLineDate];
			
			NSArray *titles = [LDFileIO titleDataForDate:dLineDate];
			NSArray *pids = [LDFileIO pidDataForDate:dLineDate];
			NSArray *appNames = [LDFileIO appNameDataForDate:dLineDate];
			NSArray *data = [LDFileIO rawDataForDate:dLineDate];

			NSInteger i = 0;
			NSMutableDictionary *appAndPoints = [NSMutableDictionary dictionary];			
			for (NSString *app in appNames) {
				
				if ([app isEqualToString:@""])
					continue;
				
				if (![allAppNames containsObject:app])
					[allAppNames addObject:app];
				
				LDAppData *appData = [[LDAppData alloc] initWithName:app 
														  andRawData:[data objectAtIndex:i] 
															 withPID:[[pids objectAtIndex:i] 
																	  integerValue]];
				
				[appData associateTitleWithRawData:titles];
				
				// 3. apply tree!!!
				//
				NSDictionary *titleData = [appData titleRawData];
				NSXMLNode *aNode = [treeXML rootElement];
				aNode = [aNode nextNode];
				while (aNode != nil) {
					
					if ([[aNode name] isEqualToString:@"Output"]) {
						
						NSArray *attr = [(NSXMLElement *)aNode attributes];
						NSString *ratio = [[attr objectAtIndex:1] objectValue]; 
						ratio = [ratio stringByReplacingOccurrencesOfString:@"(" 
																 withString:@""];
						ratio = [ratio stringByReplacingOccurrencesOfString:@")" 
																 withString:@""];
						NSArray *vals = [ratio componentsSeparatedByString:@"/"];
						
						double calculatedVal;
						if ([vals count] == 2)
							calculatedVal = [[vals objectAtIndex:1] doubleValue]/
							[[vals objectAtIndex:0] doubleValue];
						else
							calculatedVal = [[vals objectAtIndex:0] doubleValue]/
							[[vals objectAtIndex:0] doubleValue];
						
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
				
				[appAndPoints setObject:appData
								 forKey:app];
			
			}
			
			[[question appData] setObject:appAndPoints forKey:dLineDate];			
			
		}		
		
		[[debriefFile datesForFile] setObject:dlineDates forKey:fileDate];
		
		[question setUniqueAppNames:[NSArray arrayWithArray:allAppNames]];
		
		[questionsByDate setObject:question forKey:fileDate];
		
	}
		
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)fireProgress {
	
	[[modeController progressBar] incrementBy:5.0];
	
	[[modeController loadingMessage] setTitleWithMnemonic:
	 [loadingText objectAtIndex:loadingCounter]];
	
	loadingCounter++;
	
	if ([[modeController progressBar] doubleValue] == 95.0) {
		
		[progressTimer invalidate];
		[[modeController loadingMessage] setTitleWithMnemonic:[loadingText lastObject]];
		
	}
		
		
}

// ****************************************************************************
// INPUT:    
// OUTPUT:   
// FUNCTION: 
 
- (void)finishProgress {
	
	if ([progressTimer isValid])
		[progressTimer invalidate];
	
	[[modeController progressBar] incrementBy:5.0];
	
	[debriefFile setCalculatedDataPoints:questionsByDate];
	[modeController beginQuestions:debriefFile];
	
}

@end
