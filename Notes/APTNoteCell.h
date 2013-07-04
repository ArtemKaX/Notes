//
//  AppNoteCell.h
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Note;

@interface APTNoteCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (void)configureCellWithNote:(Note *)note;

@end
