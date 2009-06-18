//
//  DebrieferTasks.m
//  Debriefer
//
//  Created by Joseph Subida on 5/25/09.
//  Copyright 2009 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "DebrieferTasks.h"


@implementation DebrieferTasks

@synthesize taskFileList;

- (id)initWithDate:(NSString *)dateToInitWith {
    
    taskFileList = [[NSArray alloc] initWithArray:[self retrieveTaskFilesStartingAtDate:dateToInitWith]];
    return self;

}

- (NSString *)createTaskFileNameFromDate:(NSString *)fileDate {
    
    NSString *formattedDate = [self formatAppendedDate:fileDate];
    NSString *fileName = [[@"Task_" stringByAppendingString:formattedDate]
                          stringByAppendingPathExtension:@"plist"];
    fileName = [fileName stringByStandardizingPath];
    return fileName;
    
}

- (NSString *)formatAppendedDate:(NSString *)dateToFormat {
    
    NSDate *typeDate = [NSDate dateWithNaturalLanguageString:dateToFormat];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDate = [formatter stringFromDate:typeDate];
    [formatter release];
    return formattedDate;
    
}

- (BOOL)logExistsForDate:(NSString *)dateInQuestion {

    NSString *taskPath = [@"~/Library/Logs/Discipline/Tasks" stringByExpandingTildeInPath];
    NSString *formattedDate = [self formatAppendedDate:dateInQuestion];
    NSArray *directoryContents = 
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:taskPath error:nil];
    BOOL fileExists = NO;
    
    for (NSString *fileName in directoryContents) {
        if ([fileName rangeOfString:formattedDate].length > 0) {
            fileExists = YES;
            break;
        }
    }
    
    return fileExists;
}

//  returns an NSArray of file names from chosenDate all the way back to the previous Sunday
- (NSArray *)retrieveTaskFilesStartingAtDate:(NSString *)chosenDate {
    
    NSDate *theDate = [NSDate dateWithNaturalLanguageString:chosenDate];
    NSString *theDateAsString = [theDate description];
    NSMutableArray *fileNames = [[[NSMutableArray alloc] init] autorelease];
    NSTimeInterval timeTillYest = -86400.0;
    NSInteger maxDays = 0;
    
    while (maxDays < 5) {
        if ([self logExistsForDate:theDateAsString])
            [fileNames addObject:[self createTaskFileNameFromDate:theDateAsString]];
        
        theDate = [theDate initWithTimeInterval:timeTillYest sinceDate:theDate];
        theDateAsString = [theDate description];
        maxDays++;
    }
    return fileNames;
    
}

@end
