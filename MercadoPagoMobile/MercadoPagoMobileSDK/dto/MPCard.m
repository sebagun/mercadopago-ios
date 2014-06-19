//
//  MPCardInfo.m
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/8/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPCard.h"
#import "MPError.h"
#import "MPUtils.h"
#import "UIDevice+Hardware.h"
#import "MPJSONRestClient.h"
#import "MercadoPago.h"
#import "MPPaymentMethod.h"

@interface MPCard ()

+ (BOOL)handleValidationErrorForParameter:(NSString *)parameter error:(NSError **)outError;

@property (nonatomic) BOOL paymentMethodCallInProgress;
@property (nonatomic) NSString *cardBinGuessed;
@property (nonatomic, strong) NSArray *paymentMethods;

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
    
    if (self.paymentMethods) {
        BOOL match = NO;
        for (MPPaymentMethod *p in self.paymentMethods) {
            for (MPCardConfiguration *c in p.cardConfiguration) {
                match = match || (ioValueString.length == c.cardNumberLength.integerValue && ([c.luhnAlgorithm isEqualToString:@"none"] || [MPUtils isLuhnValidString:ioValueString]));
            }
        }
        if (!match) {
            return [[self class] handleValidationErrorForParameter:@"cardNumber" error:outError];
        }
    }
    return YES;
}

- (BOOL)validateSecurityCode:(id *)ioValue error:(NSError **)outError
{
    if (self.paymentMethods) {
        BOOL match = NO;
        for (MPPaymentMethod *p in self.paymentMethods) {
            for (MPCardConfiguration *c in p.cardConfiguration) {
                match = match ||
                        (c.securityCodeLength.integerValue == 0 && (*ioValue == nil || ((NSString *) *ioValue).length == 0)) ||
                        (*ioValue != nil && c.securityCodeLength.integerValue == ((NSString *) *ioValue).length);
            }
        }
        if (!match) {
            return [[self class] handleValidationErrorForParameter:@"securityCode" error:outError];
        }
    }else{
        if (*ioValue == nil) {
            //Some credit cards do not require CVC
            return YES;
        }
        NSString *ioValueString = (NSString *) *ioValue;
        
        BOOL validLength = ([ioValueString length] >= 3 && [ioValueString length] <= 4);
        
        
        if (![MPUtils isNumericString:ioValueString] || !validLength) {
            return [[self class] handleValidationErrorForParameter:@"securityCode" error:outError];
        }
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

- (BOOL)validateCardholderIDType:(id *)ioValue error:(NSError **)outError
{
    if (self.paymentMethods) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",@"cardholder_identification_type"];
        BOOL match = NO;
        for (MPPaymentMethod *p in self.paymentMethods) {
            for (MPCardConfiguration *c in p.cardConfiguration) {
                if (match) {
                }else if ([c.additionalInfoNeeded filteredArrayUsingPredicate:predicate].count == 0  && (*ioValue == nil || ((NSString *) *ioValue).length == 0)){
                    match = YES;
                }else if ([c.additionalInfoNeeded filteredArrayUsingPredicate:predicate].count > 0 && *ioValue != nil && ((NSString *) *ioValue).length > 0){
                    NSString *ioValueString = (NSString *) *ioValue;
                    if ([p.siteId isEqualToString:@"MLA"] && [[MPUtils argentinaValidCardholderIDTypes] containsObject:ioValueString]) {
                        match = YES;
                    }else if ([p.siteId isEqualToString:@"MLB"] && [[MPUtils brasilValidCardholderIDTypes] containsObject:ioValueString]) {
                        match = YES;
                    }else if ([p.siteId isEqualToString:@"MLM"] && [[MPUtils mexicoValidCardholderIDTypes] containsObject:ioValueString]) {
                        match = YES;
                    }else if ([p.siteId isEqualToString:@"MLV"] && [[MPUtils venezuelaValidCardholderIDTypes] containsObject:ioValueString]) {
                        match = YES;
                    }else if ([p.siteId isEqualToString:@"MCO"] && [[MPUtils colombiaValidCardholderIDTypes] containsObject:ioValueString]) {
                        match = YES;
                    }
                }
            }
        }
        if (!match) {
            return [[self class] handleValidationErrorForParameter:@"cardholderIDType" error:outError];
        }
    }else{
        if (*ioValue == nil) {
            //In mexico, all the cardholder identification info is optional.
            return YES;
        }
        
        NSString *ioValueString = (NSString *) *ioValue;
        
        if (![[MPUtils argentinaValidCardholderIDTypes] containsObject:ioValueString]   &&
            ![[MPUtils brasilValidCardholderIDTypes] containsObject:ioValueString]      &&
            ![[MPUtils venezuelaValidCardholderIDTypes] containsObject:ioValueString]   &&
            ![[MPUtils mexicoValidCardholderIDTypes] containsObject:ioValueString]      &&
            ![[MPUtils colombiaValidCardholderIDTypes] containsObject:ioValueString]) {
            return [[self class] handleValidationErrorForParameter:@"cardholderIDType" error:outError];
        }
    }
    return YES;
}

- (BOOL)validateCardholderIDSubType:(id *)ioValue error:(NSError **)outError
{
    if (*ioValue == nil) {
        //TODO: better validation by country from payment method info
        return YES;
    }
    NSString *ioValueString = (NSString *) *ioValue;
    
    if (![[MPUtils venezuelaValidCardholderIDSubTypes] containsObject:ioValueString]){
        return [[self class] handleValidationErrorForParameter:@"cardholderIDSubType" error:outError];
    }
    
    //TODO: check invalid combinations of IDType and IDSubType
    //(docType == "CI") &&  !(subDocType in ["V","E"]) ==> error
    //(docType == "RIF") &&  !(subDocType in ["J", "P", "V", "E", "G"]) ==> error
    
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
    NSString *cardholderIDTypeRef = [self cardholderIDType];
    NSString *cardholderIDSubTypeRef = [self cardholderIDSubType];
    
    return [self validateCardNumber:&numberRef error:outError] &&
    [self validateExpirationYear:&expYearRef error:outError] &&
    [self validateExpirationMonth:&expMonthRef error:outError] &&
    [self validateSecurityCode:&cvcRef error:outError] &&
    [self validateCardholderIDType:&cardholderIDTypeRef error:outError] &&
    [self validateCardholderIDSubType:&cardholderIDSubTypeRef error:outError];
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
    
    //Include device info for fraud prevention. If you remove this, you will have more payments rejections.
    NSDictionary *fingerprint = [[UIDevice currentDevice] fingerPrint];
    NSDictionary *deviceInfo = [NSDictionary dictionaryWithObject:fingerprint forKey:@"fingerprint"];
    [json setObject:deviceInfo forKey:@"device"];
    
    return json;
}
- (NSString *) cardBin
{
    if (self.cardNumber && [self.cardNumber length] > 5) {
        return [self.cardNumber substringToIndex:6];
    }
    return nil;
}

- (NSArray *) paymentMethods
{
    return _paymentMethods;
}
-(void) fillPaymentMethodsExecutingOnSuccess:(void (^)(NSArray *)) success onFailure:(void (^)(NSError *)) failure
{
    [MercadoPago validateKey];
    
    if (success == nil)
        [NSException raise:@"RequiredParameter" format:@"'success' is required"];
    if (failure == nil)
        [NSException raise:@"RequiredParameter" format:@"'failure' is required"];
    
    NSError *validationError;
    NSString *cardBin = [self cardBin];
    
    if ([MPUtils validateCardBin:cardBin error:&validationError] && validationError) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure(validationError);
                       }
                       );
        return;
    }
    
    if (self.cardBinGuessed && [cardBin isEqualToString:self.cardBinGuessed]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           success(self.paymentMethods);
                       }
                       );
        return;
    }
    
    if(self.paymentMethodCallInProgress){
        return;
    }
    
    //Handle JSON success response from API
    MPSuccessRequestHandler s = ^(id jsonArr, NSInteger statusCode){
        NSArray *arr = (NSArray *)jsonArr;
        NSMutableArray *cleanArr = [[NSMutableArray alloc] initWithCapacity:[arr count]];
        for (NSDictionary *paymentMethodJSON in arr) {
            MPPaymentMethod *p = [[MPPaymentMethod alloc]initFromDictionary:paymentMethodJSON];
            [cleanArr addObject:p];
        }
        self.paymentMethods = cleanArr;
        self.cardBinGuessed = cardBin;
        self.paymentMethodCallInProgress = NO;
        success(cleanArr);
    };
    
    //Handle failure response from API or error
    MPFailureRequestHandler failureHandler = ^(id json, NSInteger statusCode, NSError *error){
        self.paymentMethodCallInProgress = NO;
        if (error) {
            failure(error);
        }else{
            NSError *apiError = [MPUtils createErrorWithJSON:json HTTPstatus:statusCode userMessage:MPPaymentMethodApiCallErrorUserMessage];
            failure(apiError);
        }
    };
    
    //GET payment method with the bin
    MPJSONRestClient *client = [[MPJSONRestClient alloc] init];
    [client getJSONFromUrl: [NSString stringWithFormat:@"https://api.mercadolibre.com/checkout/custom/payment_methods/search?public_key=%@&bin=%@",[MercadoPago publishableKey], [self cardBin]] onSuccess:s onFailure:failureHandler];
    self.paymentMethodCallInProgress = YES;
}

-(void) fillPaymentMethods
{
    [MercadoPago validateKey];
    
    NSError *validationError;
    NSString *cardBin = [self cardBin];
    
    if ([MPUtils validateCardBin:cardBin error:&validationError] && validationError) {
        return;
    }
    
    if (self.cardBinGuessed && [cardBin isEqualToString:self.cardBinGuessed]) {
        return;
    }
    
    if(self.paymentMethodCallInProgress){
        return;
    }
    
    //Handle JSON success response from API
    MPSuccessRequestHandler s = ^(id jsonArr, NSInteger statusCode){
        NSArray *arr = (NSArray *)jsonArr;
        NSMutableArray *cleanArr = [[NSMutableArray alloc] initWithCapacity:[arr count]];
        for (NSDictionary *paymentMethodJSON in arr) {
            MPPaymentMethod *p = [[MPPaymentMethod alloc]initFromDictionary:paymentMethodJSON];
            [cleanArr addObject:p];
        }
        self.paymentMethods = cleanArr;
        self.cardBinGuessed = cardBin;
        self.paymentMethodCallInProgress = NO;
    };
    
    //Handle failure response from API or error
    MPFailureRequestHandler failureHandler = ^(id json, NSInteger statusCode, NSError *error){
        self.paymentMethodCallInProgress = NO;
    };
    
    //GET payment method with the bin
    MPJSONRestClient *client = [[MPJSONRestClient alloc] init];
    [client getJSONFromUrl: [NSString stringWithFormat:@"https://api.mercadolibre.com/checkout/custom/payment_methods/search?public_key=%@&bin=%@",[MercadoPago publishableKey], [self cardBin]] onSuccess:s onFailure:failureHandler];
    self.paymentMethodCallInProgress = YES;
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
        else if ([parameter isEqualToString:@"cardholderIDType"])
            *outError = [MPUtils createErrorWithMessage:MPCardErrorInvalidCardholderIDTypeUserMessage
                                              parameter:parameter
                                          cardErrorCode:MPInvalidCardholderIDType
                                        devErrorMessage:@"cardholderIDType invalid"];
        else if ([parameter isEqualToString:@"cardholderIDSubType"])
            *outError = [MPUtils createErrorWithMessage:MPCardErrorInvalidCardholderIDSubTypeUserMessage
                                              parameter:parameter
                                          cardErrorCode:MPInvalidCardholderIDSubType
                                        devErrorMessage:@"cardholderIDSubType invalid"];
    }
    return NO; //there was an error, so validation is NO and you will have to check the NSError detail
}

@end
