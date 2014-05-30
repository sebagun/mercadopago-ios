//
//  MPCardInfo.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/8/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPCard.h"
#import "MPError.h"
#import "MPUtils.h"

@interface MPCard ()

+ (BOOL)handleValidationErrorForParameter:(NSString *)parameter error:(NSError **)outError;

@end

@implementation MPCard

- (BOOL)validateCardNumber:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) {
        return [[self class] handleValidationErrorForParameter:@"cardNumber" error:outError];
    }
    
    NSString *ioValueString = (NSString *) *ioValue;
    
    if (![MPUtils isNumericString:ioValueString] || ioValueString.length < 10 || ioValueString.length > 19) {
        return [[self class] handleValidationErrorForParameter:@"cardNumber" error:outError];
    }
    return YES;
}

- (BOOL)validateSecurityCode:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) {
        //Some credit cards do not require CVC
        return YES;
    }
    NSString *ioValueString = [(NSString *) *ioValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL validLength = ([ioValueString length] >= 3 && [ioValueString length] <= 4);
    
    
    if (![MPUtils isNumericString:ioValueString] || !validLength) {
        return [[self class] handleValidationErrorForParameter:@"securityCode" error:outError];
    }
    return YES;
}

- (BOOL)validateExpirationMonth:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) {
        return [[self class] handleValidationErrorForParameter:@"expirationMonth" error:outError];
    }

    NSNumber *expMonth = (NSNumber *) *ioValue;
    
    if ([expMonth integerValue] > 12 || [expMonth integerValue] < 1) {
        return [[self class] handleValidationErrorForParameter:@"expirationMonth" error:outError];
    }
    else if ([self expirationYear] && [MPUtils isExpiredMonth:expMonth andYear:[self expirationYear]]) {
        NSNumber *currentYear = [MPUtils currentYear];
        if ([currentYear compare: [self expirationYear]] == NSOrderedDescending)
            return [[self class] handleValidationErrorForParameter:@"expirationYear" error:outError];
        else
            return [[self class] handleValidationErrorForParameter:@"expirationMonth" error:outError];
    }
    return YES;
}

- (BOOL)validateExpirationYear:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) {
        return [[self class] handleValidationErrorForParameter:@"expirationYear" error:outError];
    }
    
    NSNumber *expYear = (NSNumber *) *ioValue;
    
    if ([expYear compare:[MPUtils currentYear]] == NSOrderedAscending) {
        return [[self class] handleValidationErrorForParameter:@"expirationYear" error:outError];
    }
    else if ([self expirationMonth] && [MPUtils isExpiredMonth:[self expirationMonth] andYear:expYear]) {
        return [[self class] handleValidationErrorForParameter:@"expirationMonth" error:outError];
    }
    
    return YES;
}

/*
 Full validator
 */
- (BOOL)validateCardReturningError:(NSError **)outError
{
    NSString *numberRef = [self cardNumber];
    NSNumber *expMonthRef = [self expirationMonth];
    NSNumber *expYearRef = [self expirationYear];
    NSString *cvcRef = [self securityCode];
    
    return [self validateCardNumber:&numberRef error:outError] &&
    [self validateExpirationYear:&expYearRef error:outError] &&
    [self validateExpirationMonth:&expMonthRef error:outError] &&
    [self validateSecurityCode:&cvcRef error:outError];
}

- (NSDictionary *) buildJSON
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    [json setObject:self.cardNumber forKey:@"card_number"];
    [json setObject:self.securityCode forKey:@"security_code"];
    [json setObject:self.expirationMonth forKey:@"expiration_month"];
    [json setObject:self.expirationYear forKey:@"expiration_year"];
    
    NSMutableDictionary *cardholder = [NSMutableDictionary dictionary];
    [cardholder setObject:(self.cardholderName?self.cardholderName:[NSNull null]) forKey:@"name"];
    
    NSMutableDictionary *document = [NSMutableDictionary dictionary];
    [document setObject:(self.cardholderIDType?self.cardholderIDType:[NSNull null]) forKey:@"type"];
    [document setObject:(self.cardholderIDNumber?self.cardholderIDNumber:[NSNull null]) forKey:@"number"];
    [document setObject:(self.cardholderIDSubType?self.cardholderIDSubType:[NSNull null]) forKey:@"subtype"];
    
    [cardholder setObject:document forKey:@"identification"];
    [json setObject:cardholder forKey:@"cardholder"];
    
    return json;
}
- (NSString *) cardBin
{
    if (self.cardNumber && [self.cardNumber length] > 5) {
        return [self.cardNumber substringToIndex:6];
    }
    return nil;
}

#pragma mark -
#pragma mark private
+ (BOOL)handleValidationErrorForParameter:(NSString *)parameter error:(NSError **)outError
{
    if (outError != nil) {
        if ([parameter isEqualToString:@"cardNumber"])
            *outError = [MPUtils createErrorWithMessage:MPCardErrorInvalidNumberUserMessage
                                           parameter:parameter
                                       cardErrorCode:MPInvalidCardNumber
                                     devErrorMessage:@"cardNumber must be between 10 and 19 digits long."];
        else if ([parameter isEqualToString:@"securityCode"])
            *outError = [MPUtils createErrorWithMessage:MPCardErrorInvalidSecurityCodeUserMessage
                                           parameter:parameter
                                       cardErrorCode:MPInvalidSecurityCode
                                     devErrorMessage:@"securityCode must be numeric and 3 or 4 digits"];
        else if ([parameter isEqualToString:@"expirationMonth"])
            *outError = [MPUtils createErrorWithMessage:MPCardErrorInvalidExpMonthUserMessage
                                           parameter:parameter
                                       cardErrorCode:MPInvalidExpirationMonth
                                     devErrorMessage:@"expirationMonth must be less than 13"];
        else if ([parameter isEqualToString:@"expirationYear"])
            *outError = [MPUtils createErrorWithMessage:MPCardErrorInvalidExpYearUserMessage
                                           parameter:parameter
                                       cardErrorCode:MPInvalidExpirationYear
                                     devErrorMessage:@"expirationYear must be this year or a year in the future"];
    }
    return NO; //there was an error, so validation is NO and you will have to check the NSError detail
}

@end
