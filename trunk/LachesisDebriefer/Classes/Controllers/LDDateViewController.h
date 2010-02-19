//
//  LDDateViewController.h
//  LachesisDebriefer
//
//  Created by Joseph Subida on 2/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDLoadingViewController.h"

@interface LDDateViewController : NSViewController {

	IBOutlet NSButton *next;
	IBOutlet NSMatrix *dates;
	LDLoadingViewController *loadingVC;
	
}

@property (assign) NSButton *next;
@property (assign) NSMatrix *dates;
@property (assign) LDLoadingViewController *loadingVC;
- (IBAction)loadLoadingScreen:(id)sender;

@end
