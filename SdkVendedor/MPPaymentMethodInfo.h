//
//  MPPaymentMethodInfo.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPCardIssuerInfo.h"
#import "MPCardConfigurationInfo.h"

@interface MPPaymentMethodInfo : NSObject

@property (nonatomic,strong) NSString *paymentMethodId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *paymentTypeId;
@property (nonatomic,strong) MPCardIssuerInfo *issuerInfo;
@property (nonatomic,strong) NSString *siteId;
@property (nonatomic,strong) NSString *secureThumbnail;
@property (nonatomic,strong) NSString *thumbnail;
@property (nonatomic,strong) NSArray *labels; //array of strings
@property (nonatomic,strong) NSNumber *minAccreditationDays;
@property (nonatomic,strong) NSNumber *maxAccreditationDays;
@property (nonatomic,strong) NSArray *payerCosts; //array of MPPayerCostInfo
@property (nonatomic,strong) NSArray *exceptionsByCardIssuer; //array of MPExceptionsByCardIssuerInfo
@property (nonatomic,strong) NSArray *cardConfiguration; //array of MPCardConfigurationInfo

- (NSString *) description;

@end
