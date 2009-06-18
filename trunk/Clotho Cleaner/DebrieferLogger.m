//
//  DebrieferLogger.m
//  Debriefer
//
//  Created by Joseph Subida on 5/23/09.
//  Copyright 2009 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "DebrieferLogger.h"


@implementation DebrieferLogger

@synthesize dataToLog;


- (id)init {
    dataToLog = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)dealloc {
    [dataToLog release];
    [super dealloc];
}

- (void)logApp:(NSString *)appID {
    
    //  if we have an array for apps to log
    if ([[dataToLog allKeys] containsObject:@"apps"]) {
        NSMutableArray *appsArray = [NSMutableArray arrayWithArray:[dataToLog objectForKey:@"apps"]];
        //  if that array already contains the app, we were going to un-log it (deselected)
        if ([appsArray containsObject:appID]) {
            [appsArray removeObject:appID];
            [dataToLog setObject:appsArray forKey:@"apps"];
        }
        //  else we want to log this app (selected)
        else {
            [appsArray addObject:appID];
            [dataToLog setObject:appsArray forKey:@"apps"];            
        }
    }
    //  else we haven't logged a single app. make an array!
    else {
        NSArray *appsArray = [NSArray arrayWithObject:appID];
        [dataToLog setObject:appsArray forKey:@"apps"];
    }
    
}

- (void)logData:(NSString *)datum forKey:(NSString *)theKey {
    [dataToLog setObject:datum forKey:theKey];
}

- (void)resetApps {
    [dataToLog removeObjectForKey:@"apps"];
}

- (void)writeToFile {
    
    BOOL isDir = NO;
    NSString *writeMe;
    NSArray *appsList = [NSArray arrayWithArray:[dataToLog objectForKey:@"apps"]];
    NSString *fileName = [@"Debriefing_" stringByAppendingString:[dataToLog objectForKey:@"date"]];
    fileName = [[fileName substringToIndex:19] stringByAppendingPathExtension:@"log"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    NSString *path = [@"~/Library/Logs/Discipline/Log/Debriefer" stringByExpandingTildeInPath];    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && !isDir) 
        [[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
    
    path = [path stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir])
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    
    FILE *log = fopen([path fileSystemRepresentation], "a");
    
    NSString *dateAndTime = [NSString stringWithFormat:@"%@ %@\t%@ %@ ", 
                             [dataToLog objectForKey:@"date"], 
                             [dataToLog objectForKey:@"time"],
                             [dataToLog objectForKey:@"daysAgo"],
                             [dataToLog objectForKey:@"breakpoint"]];
    
    NSString *apps = [NSString string];
    for (id datum in appsList) {
        NSString *formattedApp = [NSString stringWithFormat:@"%@, ", (NSString*)datum];
        apps = [apps stringByAppendingString:formattedApp];
    }
    
    writeMe = [NSString stringWithFormat:@"%@%@\n", dateAndTime, apps];
    
    fprintf(log, [writeMe UTF8String]);
    fflush(log);
    fclose(log);
    
}

@end
