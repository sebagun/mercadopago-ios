//
//  MercadoPago.h
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/7/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPCard.h"
#import "MPCardToken.h"

@interface MercadoPago : NSObject

//Your MercadoPago public key.
+ (NSString *) publishableKey;
+ (void) setPublishableKey: (NSString *) key;
+ (void)validateKey;

/*
 Creates a "One use Token" with the collected card info. You will later need this token to create a payment from your server.
 */
+ (void) createTokenWithCard:(MPCard *) card onSuccess:(void (^)(MPCardToken *)) success onFailure:(void (^)(NSError *)) failure;

/*
 > You get a NSArray* of MPPaymentMethod in your success callback.
 > Gets the possible payment methods using the card bin (first six numbers).
 > Normally it will return just one. Just in México, in some cases it will return more than one if the API can't tell
 if the bin belongs to a debit card or credit card.
 */
+ (void) paymentMethodsForCardBin:(NSString *) bin onSuccess:(void (^)(NSArray *)) success onFailure:(void (^)(NSError *)) failure;

@end
