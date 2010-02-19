//
//  LDWindow.m
//
//  Created by Joseph Subida on 1/15/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDWindow.h"

#import "LDQuestionView.h"

@implementation LDWindow

@synthesize currentController;

- (void)awakeFromNib {
	
	[self setAcceptsMouseMovedEvents:NO];
	
}

- (void)mouseMoved:(NSEvent *)theEvent {
	
	if ([currentController isKindOfClass:[LDQuestionViewController class]])
		[currentController mouseMoved:theEvent];
	
}

@end
