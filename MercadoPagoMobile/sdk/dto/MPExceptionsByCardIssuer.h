//
//  MPExceptionsByCardIssuer.h
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPCardIssuer.h"

@interface MPExceptionsByCardIssuer : NSObject

@property (nonatomic,strong) MPCardIssuer *issuerInfo;
@property (nonatomic,strong) NSArray *labels;
@property (nonatomic,strong) NSString *secureThumbnail;
@property (nonatomic,strong) NSString *thumbnail;
@property (nonatomic,strong) NSArray *payerCosts; //array of MPPayerCostInfo
@property (nonatomic,strong) NSArray *acceptedBins; //array of NSNumber
@property (nonatomic,strong) NSNumber *totalFinantialCost;

/*
 This method should not be invoked in your code. This is used by MercadoPago to retrieve
 payment method data using a MercadoPago API response
 */
- (instancetype) initFromDictionary: (NSDictionary *) dict;

@end
