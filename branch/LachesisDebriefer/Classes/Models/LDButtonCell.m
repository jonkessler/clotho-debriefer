//
//  LDButtonCell.m
//  QuartzBox
//
//  Created by Joseph Subida on 1/10/10.
//  Copyright 2010 University of Illinois Champaign-Urbana. All rights reserved.
//

#import "LDButtonCell.h"


@implementation LDButtonCell

- (void)awakeFromNib {
	
	[self setTitle:@"Poo"];
	[self setBezelStyle:NSRoundRectBezelStyle];
	[self setButtonType:NSRadioButton];
	
}

@end
