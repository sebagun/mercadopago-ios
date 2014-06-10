//
//  MPPayerCost.h
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPPayerCost : NSObject

@property (nonatomic,strong) NSNumber *installments;
@property (nonatomic,strong) NSNumber *installmentRate;
@property (nonatomic,strong) NSArray *labels; //array of NSString
@property (nonatomic,strong) NSNumber *minAllowedAmount;
@property (nonatomic,strong) NSNumber *maxAllowedAmount;

- (NSDecimalNumber *) installmentAmountForAmount:(NSDecimalNumber *) amount; //amount per installment
- (NSDecimalNumber *) totalAmountForAmount:(NSDecimalNumber *) amount; //total amount for a payment with installments

/*
 This method should not be invoked in your code. This is used by MercadoPago to retrieve
 payment method data using a MercadoPago API response
 */
- (instancetype) initFromDictionary: (NSDictionary *) dict;

@end
