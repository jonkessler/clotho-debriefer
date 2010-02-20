//
//  LDDateViewController.m
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDDateViewController.h"


@implementation LDDateViewController

@synthesize next, dates, loadingVC;

- (void)awakeFromNib {
	
	loadingVC = [[LDLoadingViewController alloc] init];
	[dates addRow];
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setTimeStyle:NSDateFormatterNoStyle];
	[format setDateStyle:NSDateFormatterFullStyle];
	
	NSCell *today = [dates cellAtRow:0 column:0];
	[today setTitle:[format stringFromDate:[NSDate date]]];
	
	NSCell *yesterday = [dates cellAtRow:1 column:0];
	[yesterday setTitle:[format stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-86500]]];
	
}

- (IBAction)loadLoadingScreen:(id)sender {
	
	// inform the loading screen of the chosen date
	[loadingVC setChosenDate:[[dates selectedCell] title]];
	
	NSWindow *theWindow = [[self view] window];
    BOOL ended = [theWindow makeFirstResponder:theWindow];
    if (!ended) {
        NSBeep();
        return;
    }
    
    NSView *theView = [loadingVC view];
    
    //  Compute the new window frame
    NSSize currentSize = [[theWindow contentView] frame].size;
    NSSize newSize = [theView frame].size;
//    newSize.height += [questionVC theFactor];
    float deltaWidth = newSize.width - currentSize.width;
    float deltaHeight = newSize.height - currentSize.height;
    NSRect windowFrame = [theWindow frame];
    windowFrame.size.height += deltaHeight;
    windowFrame.origin.y -= deltaHeight;
    windowFrame.size.width += deltaWidth;
    
    [theWindow setFrame:windowFrame
                display:YES
                animate:YES];
    
    //  Put the view in the window
    [theWindow setContentView:theView];
	
	[theWindow display];
	
	[loadingVC beginLoading];
	
}

@end
