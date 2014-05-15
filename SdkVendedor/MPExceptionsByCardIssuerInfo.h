//
//  MPExceptionsByCardIssuerInfo.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPCardIssuerInfo.h"

@interface MPExceptionsByCardIssuerInfo : NSObject

@property (nonatomic,strong) MPCardIssuerInfo *issuerInfo;
@property (nonatomic,strong) NSArray *labels;
@property (nonatomic,strong) NSString *secureThumbnail;
@property (nonatomic,strong) NSString *thumbnail;
@property (nonatomic,strong) NSArray *payerCosts; //array of MPPayerCostInfo
@property (nonatomic,strong) NSArray *acceptedBins; //array of NSNumber
@property (nonatomic,strong) NSNumber *totalFinantialCost;

@end
