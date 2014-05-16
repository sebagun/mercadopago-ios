//
//  MPValidators.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/16/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPValidators.h"

@implementation MPValidators

+(void) validateCardBin:(NSString *)bin error:(NSError **) error
{
    if (!bin ||
        [bin isEqualToString:@""] ||
        [bin length] < 6 ||
        ![[self class] isNumericString:bin]) {
        
        *error = [NSError errorWithDomain:@"card_data_error"
                                     code:1
                                 userInfo:@{
                                            @"description":@"invalid card bin, cannot be nil and has to be at least 6 digits"
                                            }
                  ];
        
    }
}

+(BOOL) isNumericString: (NSString *) aString
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([aString rangeOfCharacterFromSet:notDigits].location == NSNotFound);
}

@end
