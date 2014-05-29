//
//  MPCardIssuerInfo.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCardIssuer : NSObject

@property (nonatomic,strong) NSNumber *issuerId;
@property (nonatomic,strong) NSString *name;

/*
 This method should not be invoked in your code. This is used by MercadoPago to retrieve
 payment method data using a MercadoPago API response
 */
- (instancetype) initFromDictionary: (NSDictionary *) dict;

@end
