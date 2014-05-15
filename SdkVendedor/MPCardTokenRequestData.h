//
//  MPCardInfo.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/8/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCardTokenRequestData : NSObject

@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSNumber *securityCode;
@property (nonatomic, strong) NSNumber *expirationMonth;
@property (nonatomic, strong) NSNumber *expirationYear;
@property (nonatomic, strong) NSString *cardholderName;
@property (nonatomic, strong) NSString *docType;
@property (nonatomic, strong) NSString *docSubType;
@property (nonatomic, strong) NSString *docNumber;

@end
