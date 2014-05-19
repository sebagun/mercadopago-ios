//
//  MPValidators.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/16/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPValidators : NSObject

//the card bin is the first six numbers of the credit card
+(void) validateCardBin:(NSString *)bin error:(NSError **) error;

+(BOOL) isNumericString: (NSString *) aString;

@end
