//
//  MPUtils.m
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/16/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPUtils.h"
#import "MPError.h"
#import "MPPayerCost.h"
#import "MPExceptionsByCardIssuer.h"
#import "MPCardConfiguration.h"

@implementation MPUtils

+(BOOL) validateCardBin:(NSString *)bin error:(NSError **) error
{
    if (!bin ||
        [bin length] < 6 ||
        ![[self class] isNumericString:bin]) {
        
        *error = [NSError errorWithDomain:MercadoPagoDomain
                                     code:MPCardError
                                 userInfo:@{
                                            NSLocalizedDescriptionKey : MPCardErrorInvalidNumberUserMessage,
                                            MPErrorParameterKey : @"cardNumber",
                                            MPCardErrorCodeKey : MPInvalidCardNumber,
                                            MPErrorMessageKey : @"invalid card bin, cannot be nil and has to be at least 6 digits"
                                            }
                  ];
        return NO;
        
    }
    return YES;
}

+(BOOL) isNumericString: (NSString *) aString
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([aString rangeOfCharacterFromSet:notDigits].location == NSNotFound);
}

+ (NSNumber *)currentYear
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    return [NSNumber numberWithInteger:[components year]];
}

+ (BOOL)isExpiredMonth:(NSNumber *)month andYear:(NSNumber *)year
{
    NSDate *now = [NSDate date];
    NSInteger monthInt = [month integerValue];
    NSInteger yearInt = [year integerValue];
    monthInt = monthInt + 1;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:yearInt];
    [components setMonth:monthInt];
    [components setDay:1];
    NSDate *expiryDate = [calendar dateFromComponents:components];
    return ([expiryDate compare:now] == NSOrderedAscending);
}

+ (BOOL)isLuhnValidString:(NSString *)number
{
    BOOL isOdd = true;
    NSInteger sum = 0;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    for (NSInteger index = [number length] - 1; index >= 0; index--) {
        NSString *digit = [number substringWithRange:NSMakeRange(index, 1)];
        NSNumber *digitNumber = [numberFormatter numberFromString:digit];
        if (digitNumber == nil)
            return NO;
        NSInteger digitInteger = [digitNumber intValue];
        isOdd = !isOdd;
        if (isOdd)
            digitInteger *= 2;
        
        if (digitInteger > 9)
            digitInteger -= 9;
        
        sum += digitInteger;
    }
    
    if (sum % 10 == 0)
        return YES;
    else
        return NO;
}

+ (NSArray *) payerCostsFromJson:(NSArray *) jsonArray
{
    if (jsonArray && [jsonArray count] > 0) {
        NSMutableArray *ma = [[NSMutableArray alloc]init];
        for (NSDictionary *d in jsonArray) {
            MPPayerCost *cost = [[MPPayerCost alloc]initFromDictionary:d];
            [ma addObject:cost];
        }
        NSArray *ar = [ma copy];
        ma = nil;
        return ar;
    }
    return nil;
}

+ (NSArray *) exceptionsByCardIssuerFromJson:(NSArray *) jsonArray
{
    if (jsonArray && [jsonArray count] > 0) {
        NSMutableArray *ma = [[NSMutableArray alloc]init];
        for (NSDictionary *d in jsonArray) {
            MPExceptionsByCardIssuer *exc = [[MPExceptionsByCardIssuer alloc]initFromDictionary:d];
            [ma addObject:exc];
        }
        NSArray *ar = [ma copy];
        ma = nil;
        return ar;
    }
    return nil;
}

+ (NSArray *) cardConfigurationFromJson:(NSArray *) jsonArray
{
    if (jsonArray && [jsonArray count] > 0) {
        NSMutableArray *ma = [[NSMutableArray alloc]init];
        for (NSDictionary *d in jsonArray) {
            MPCardConfiguration *conf = [[MPCardConfiguration alloc]initFromDictionary:d];
            [ma addObject:conf];
        }
        NSArray *ar = [ma copy];
        ma = nil;
        return ar;
    }
    return nil;
}

+ (NSError *) createErrorWithJSON: (id) json HTTPstatus: (NSInteger) status userMessage:(NSString *) userMessage
{
    return [[NSError alloc] initWithDomain:MercadoPagoDomain
                                      code:MPHttpError
                                  userInfo:@{
                                             NSLocalizedDescriptionKey : userMessage,
                                             MPHttpStatusKey : [NSString stringWithFormat:@"%ld", (long)status],
                                             MPApiErrorResponseKey : json
                                             }];
}

+ (NSError *) createErrorWithTokenResponse: (id) json HTTPstatus: (NSInteger) status
{
    NSString *userMessage;
    NSString *parameter;
    NSString *cardErrorCode;
    NSString *devMessage;
    
    if (status == 400) {
        //Bad Request errors
        if ([json isKindOfClass:[NSDictionary class]]) {
            devMessage = [json objectForKey:@"message"];
            NSString *code = [(NSDictionary *)[(NSArray *) [json objectForKey:@"cause"] objectAtIndex:0] objectForKey:@"code"];
            if ([@[@"E202",@"E301"] containsObject:code]) {
                userMessage = MPCardErrorInvalidNumberUserMessage;
                parameter = @"cardNumber";
                cardErrorCode = MPInvalidCardNumber;
            }else if([@[@"324",@"214"] containsObject:code]) {
                userMessage = MPCardErrorInvalidCardholderIDNumberUserMessage;
                parameter = @"cardholderIDNumber";
                cardErrorCode = MPInvalidCardholderIDNumber;
            }else if([@[@"323",@"213"] containsObject:code]) {
                userMessage = MPCardErrorInvalidCardholderIDSubTypeUserMessage;
                parameter = @"cardholderIDSubType";
                cardErrorCode = MPInvalidCardholderIDSubType;
            }else if([@[@"322",@"212"] containsObject:code]) {
                userMessage = MPCardErrorInvalidCardholderIDTypeUserMessage;
                parameter = @"cardholderIDType";
                cardErrorCode = MPInvalidCardholderIDType;
            }else if([@[@"316",@"221"] containsObject:code]) {
                userMessage = MPCardErrorInvalidCardholderNameUserMessage;
                parameter = @"cardholderName";
                cardErrorCode = MPInvalidCardholderName;
            }else if([@[@"301",@"208",@"325",@"326",@"702",@"209"] containsObject:code]) {
                userMessage = MPCardErrorInvalidExpMonthUserMessage;
                parameter = @"expirationMonth";
                cardErrorCode = MPInvalidExpirationMonth;
            }else if([@[@"E203",@"E302"] containsObject:code]) {
                userMessage = MPCardErrorInvalidSecurityCodeUserMessage;
                parameter = @"securityCode";
                cardErrorCode = MPInvalidSecurityCode;
            }
        }else{
            userMessage = MPTokenApiCallErrorUserMessage;
            devMessage = @"Error from API creating token with card info";
        }
    } else {
        //Other errors (less commons)
        userMessage = MPTokenApiCallErrorUserMessage;
        devMessage = @"Error from API creating token with card info";
    }
    
    return [[NSError alloc] initWithDomain:MercadoPagoDomain
                                      code:MPHttpError
                                  userInfo:@{
                                             NSLocalizedDescriptionKey : userMessage,
                                             MPErrorParameterKey : parameter,
                                             MPCardErrorCodeKey : cardErrorCode,
                                             MPErrorMessageKey : devMessage,
                                             MPHttpStatusKey : [NSString stringWithFormat:@"%ld", (long)status],
                                             MPApiErrorResponseKey : json
                                             }];
}

+ (NSError *)createErrorWithMessage:(NSString *)userMessage parameter:(NSString *)parameter cardErrorCode:(NSString *)cardErrorCode devErrorMessage:(NSString *)devMessage
{
    return [[NSError alloc] initWithDomain:MercadoPagoDomain
                                      code:MPCardError
                                  userInfo:@{
                                             NSLocalizedDescriptionKey : userMessage,
                                             MPErrorParameterKey : parameter,
                                             MPCardErrorCodeKey : cardErrorCode,
                                             MPErrorMessageKey : devMessage
                                             }];
}

+ (NSArray *) argentinaValidCardholderIDTypes
{
    return @[@"DNI", @"CI", @"LC", @"LE", @"Otro"];
}
+ (NSArray *) brasilValidCardholderIDTypes
{
    return @[@"CNPJ", @"CPF"];
}
+ (NSArray *) venezuelaValidCardholderIDTypes
{
    return @[@"CI", @"RIF", @"Pasaporte"];
}
+ (NSArray *) mexicoValidCardholderIDTypes
{
    return @[@"RFC", @"Pasaporte", @"Otro"];
}
+ (NSArray *) colombiaValidCardholderIDTypes
{
    return @[@"CC", @"CE", @"NIT", @"Otro"];
}

+ (NSArray *) venezuelaValidCardholderIDSubTypes
{
    return @[@"J", @"P", @"V", @"E", @"G"];
}
@end
