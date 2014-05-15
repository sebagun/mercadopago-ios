//
//  MPPayerCostInfo.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPPayerCostInfo.h"

@interface MPPayerCostInfo ()

@property (nonatomic,strong) NSDecimalNumberHandler *roundPlain;

//TODO cache the operations
/*
@property (nonatomic,strong) NSDecimalNumber *lastAmount; //last amount used
@property (nonatomic,strong) NSDecimalNumber *lastShareAmount; //share amount for the last amount used
@property (nonatomic,strong) NSDecimalNumber *lastTotalAmount; //total amount for the last amount used
*/

@end

@implementation MPPayerCostInfo

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

- (NSDecimalNumber *) shareAmountForAmount:(NSDecimalNumber *) amount
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
            NSDecimalNumber *share = [self shareAmountForAmount:amount];
            NSDecimalNumber *installments = [NSDecimalNumber decimalNumberWithDecimal:[self.installments decimalValue]];
            return [share decimalNumberByMultiplyingBy:installments withBehavior:self.roundPlain];
        }else{
            return amount;
        }
    }
    return nil;
}

@end
