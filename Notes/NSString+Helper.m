//
//  NSString+Helper.m
//  ABPtablet
//
//  Created by Tim Bakker on 05-02-13.
//  Copyright (c) 2013 Triple IT. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (BOOL)isEmptyString
// Returns YES if the string is nil or equal to @""
{
    // Note that [string length] == 0 can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
    
    if (((NSNull *) self == [NSNull null]) || (self == nil) ) {
        return YES;
    }
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([trimmedString isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

- (NSString *)localized
{
    return NSLocalizedString(self, nil);
}


-(BOOL)containsString:(NSString*)substring
{
    NSRange range=[self rangeOfString:substring];
    BOOL found=(range.location!=NSNotFound);
    return found;
}

-(NSString *) stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

-(NSString *) stringByStrippingIllegalChars
{
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]]; // ? .
    string = [string stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]]; // Accent
    
    return string;
}



-(NSString *) trimmedString
{
	NSString *trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return trimmedString;
}


@end
