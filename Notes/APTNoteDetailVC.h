//
//  APTNoteDetailVC.h
//  Notes
//
//  Created by Artem Shiyanov on 04.07.13.
//  Copyright (c) 2013 AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class Note;

@interface APTNoteDetailVC : UIViewController <CLLocationManagerDelegate>
{
	CLLocationManager *locationManager;
	CLLocation *userCoordinate;
}
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) IBOutlet UITextField *titleFiled;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
