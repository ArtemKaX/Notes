//
//  NSString+Helper.h
//  ABPtablet
//
//  Created by Tim Bakker on 05-02-13.
//  Copyright (c) 2013 Triple IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)


- (BOOL)isEmptyString;

- (BOOL)containsString:(NSString*)substring;

- (NSString *)localized;

-(NSString *) stringByStrippingHTML;
-(NSString *) stringByStrippingIllegalChars;
-(NSString *) trimmedString;

@end
