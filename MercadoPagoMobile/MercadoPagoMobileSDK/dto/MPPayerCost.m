//
//  MPPayerCost.m
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPPayerCost.h"

@interface MPPayerCost ()

@property (nonatomic,strong) NSDecimalNumberHandler *roundPlain;

@end

@implementation MPPayerCost

- (NSDecimalNumberHandler *) roundPlain
{
    if (!_roundPlain) {
        _roundPlain = [NSDecimalNumberHandler
                       decimalNumberHandlerWithRoundingMode:NSRoundPlain
                       scale:2
                       raiseOnExactness:NO
                       raiseOnOverflow:NO
                       raiseOnUnderflow:NO
                       raiseOnDivideByZero:YES];
    }
    return _roundPlain;
}

- (NSDecimalNumber *) installmentAmountForAmount:(NSDecimalNumber *) amount
{
    if (amount && self.minAllowedAmount && self.maxAllowedAmount && [amount compare: self.minAllowedAmount] == NSOrderedDescending && [amount compare: self.maxAllowedAmount] == NSOrderedAscending) {
        if ([self.installmentRate floatValue] > 0.0) {
            //(amount * (1 + installmentRate/100)) / installments
            NSDecimalNumber *rate = [NSDecimalNumber decimalNumberWithDecimal:[self.installmentRate decimalValue]];
            NSDecimalNumber *installments = [NSDecimalNumber decimalNumberWithDecimal:[self.installments decimalValue]];
            NSDecimalNumber *amountd = [NSDecimalNumber decimalNumberWithDecimal:[amount decimalValue]];
            return [[[[rate decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"] withBehavior:self.roundPlain] decimalNumberByAdding: [NSDecimalNumber one] withBehavior:self.roundPlain] decimalNumberByMultiplyingBy:amountd withBehavior:self.roundPlain]decimalNumberByDividingBy:installments withBehavior:self.roundPlain];
        }else{
            //amount / installments
            NSDecimalNumber *installments = [NSDecimalNumber decimalNumberWithDecimal:[self.installments decimalValue]];
            NSDecimalNumber *amountd = [NSDecimalNumber decimalNumberWithDecimal:[amount decimalValue]];
            NSDecimalNumberHandler *roundPlain = [NSDecimalNumberHandler
                                                  decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                  scale:2
                                                  raiseOnExactness:NO
                                                  raiseOnOverflow:NO
                                                  raiseOnUnderflow:NO
                                                  raiseOnDivideByZero:YES];
            return [amountd decimalNumberByDividingBy:installments withBehavior:roundPlain];
        }
    }
    return nil;
}

- (NSDecimalNumber *) totalAmountForAmount:(NSDecimalNumber *) amount
{
    if (amount && self.minAllowedAmount && self.maxAllowedAmount && [amount compare: self.minAllowedAmount] == NSOrderedDescending && [amount compare: self.maxAllowedAmount] == NSOrderedAscending) {
        if ([self.installmentRate floatValue] > 0.0) {
            //share*installments
            NSDecimalNumber *share = [self installmentAmountForAmount:amount];
            NSDecimalNumber *installments = [NSDecimalNumber decimalNumberWithDecimal:[self.installments decimalValue]];
            return [share decimalNumberByMultiplyingBy:installments withBehavior:self.roundPlain];
        }else{
            return amount;
        }
    }
    return nil;
}

- (instancetype) initFromDictionary: (NSDictionary *) dict
{
    if (self = [super init]) {
        self.installments = [dict objectForKey:@"installments"];
        self.installmentRate = [dict objectForKey:@"installment_rate"];
        self.labels = [dict objectForKey:@"labels"];
        self.minAllowedAmount = [dict objectForKey:@"min_allowed_amount"];
        self.maxAllowedAmount = [dict objectForKey:@"max_allowed_amount"];
    }
    return self;
}

@end
