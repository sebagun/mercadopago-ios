//
//  MPCardInfo.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/8/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCard : NSObject

/*
 Card info
 */
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *securityCode;
@property (nonatomic, strong) NSNumber *expirationMonth;
@property (nonatomic, strong) NSNumber *expirationYear;

/*
 Cardholder info
 */
@property (nonatomic, strong) NSString *cardholderName;
@property (nonatomic, strong) NSString *cardholderDocType;
@property (nonatomic, strong) NSString *cardholderDocSubType;
@property (nonatomic, strong) NSString *cardholderDocNumber;

/*
 Key-value validation, as described here:
 http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Validation.html#//apple_ref/doc/uid/20002173-CJBDBHCB
 */
- (BOOL)validateCardNumber:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateSecurityCode:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateExpirationMonth:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateExpirationYear:(id *)ioValue error:(NSError **)outError;

/*
 All in one card validation.
 */
- (BOOL)validateCardReturningError:(NSError **)outError;


/*
 Used by [MercadoPago createTokenWithCard:]
 
 Build a json (NSDictionary) to request a MPCardToken.
 First validate the card before calling this.
 */
- (NSDictionary *) buildJSON;

@end
