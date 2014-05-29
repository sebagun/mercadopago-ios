//
//  MPValidators.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/16/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Helper methods
 */
@interface MPUtils : NSObject

//Validates if the string is a valid card bin (first 6 number of the credit card)
+(void) validateCardBin:(NSString *)bin error:(NSError **) error;

+(BOOL) isNumericString: (NSString *) aString;

+ (NSNumber *) currentYear;

+ (BOOL) isExpiredMonth:(NSNumber *)month andYear:(NSNumber *)year;

+ (BOOL) isLuhnValidString:(NSString *)number;

//Converts json array of payer costs returned by the API to an array of MPPayerCost
+ (NSArray *) payerCostsFromJson:(NSArray *) jsonArray;

//Converts json array of exceptions by card issuer returned by the API to an array of MPExceptionsByCardIssuer
+ (NSArray *) exceptionsByCardIssuerFromJson:(NSArray *) jsonArray;

//Converts json array of card configurations returned by the API to an array of MPCardConfiguration
+ (NSArray *) cardConfigurationFromJson:(NSArray *) jsonArray;

//Creates an error from an api call error, with it's json and http_status. You also have to provide the user message
+ (NSError *) createErrorWithJSON: (id) json HTTPstatus: (NSInteger) status userMessage:(NSString *) userMessage;

//Creates an error for a card error.
+ (NSError *) createErrorWithMessage:(NSString *)userMessage parameter:(NSString *)parameter cardErrorCode:(NSString *)cardErrorCode devErrorMessage:(NSString *)devMessage;

@end
