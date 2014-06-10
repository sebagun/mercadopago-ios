//
//  MPCard.h
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/8/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPaymentMethod.h"

@interface MPCard : NSObject

/*
 Card info.
 Required info (there are a few exceptions that not require security code)
 */
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *securityCode;
@property (nonatomic, strong) NSNumber *expirationMonth;
@property (nonatomic, strong) NSNumber *expirationYear;

/*
 Cardholder info.
 Not all of these is required. Depends on the country
 */
@property (nonatomic, strong) NSString *cardholderName;
@property (nonatomic, strong) NSString *cardholderIDType;
@property (nonatomic, strong) NSString *cardholderIDSubType;
@property (nonatomic, strong) NSString *cardholderIDNumber;

/*
 Once you have 6 digits of the card number, you can get extra info about the card: 
 country, issuer, installments and rates and card configurations like 
 security code length, card number length, etc.
 Calling this you feed the built-in validators with more info.
 THIS IS DONE ASYNC.
 */
-(void) fillPaymentMethodExecutingOnSuccess:(void (^)(MPPaymentMethod *)) success onFailure:(void (^)(NSError *)) failure;
/*
 The payment method also remains available outside the completion handler using the getter.
 */
- (MPPaymentMethod *) paymentMethod;

/*
 Key-value validation, as described here:
 http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Validation.html#//apple_ref/doc/uid/20002173-CJBDBHCB
 */
- (BOOL)validateCardNumber:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateSecurityCode:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateExpirationMonth:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateExpirationYear:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateCardholderIDType:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateCardholderIDSubType:(id *)ioValue error:(NSError **)outError;

/*
 All in one card validation.
 */
- (BOOL)validateCardReturningError:(NSError **)outError;

- (NSString *) cardBin;

/*
 Used by [MercadoPago createTokenWithCard:]
 
 Build a json (NSDictionary) to request a MPCardToken.
 HINT: use validator to validate the card before requesting a token.
 */
- (NSDictionary *) buildJSON;

@end
