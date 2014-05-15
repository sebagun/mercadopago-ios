//
//  MPPayerCostInfo.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPPayerCostInfo : NSObject

@property (nonatomic,strong) NSNumber *installments;
@property (nonatomic,strong) NSNumber *installmentRate;
@property (nonatomic,strong) NSArray *labels; //array of NSString
@property (nonatomic,strong) NSNumber *minAllowedAmount;
@property (nonatomic,strong) NSNumber *maxAllowedAmount;

- (NSDecimalNumber *) shareAmountForAmount:(NSDecimalNumber *) amount; //amount per share
- (NSDecimalNumber *) totalAmountForAmount:(NSDecimalNumber *) amount; //total amount for a payment with installments

@end
