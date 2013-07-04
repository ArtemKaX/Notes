//
//  AppNoteCell.m
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import "APTNoteCell.h"
#import "Note.h"

@implementation APTNoteCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/**
 This Function configures View
 @param Note
 */
- (void)configureCellWithNote:(Note *)note
{
	if (nil != note.name) {
		self.textLabel.text = note.name;
	}
}

@end
