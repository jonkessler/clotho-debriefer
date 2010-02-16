//
//  LDWindow.h
//
//  Created by Joseph Subida on 1/15/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "LDLoadingViewController.h"
#import "LDQuestionViewController.h"

@interface LDWindow : NSWindow {

	id currentController;
	
}

@property (assign) id currentController;

@end
