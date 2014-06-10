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
#import "MPPaymentMethod.h"

@interface MercadoPago : NSObject

//Your MercadoPago public key.
+ (NSString *) publishableKey;
+ (void) setPublishableKey: (NSString *) key;
+ (void)validateKey;

//creates a "One use Token" with the collected card info. You will later need this token to create a payment from your server
+ (void) createTokenWithCard:(MPCard *) card onSuccess:(void (^)(MPCardToken *)) success onFailure:(void (^)(NSError *)) failure;

//Gets the payment method info for a card bin (first six numbers)
+ (void) paymentMethodForCardBin:(NSString *) bin onSuccess:(void (^)(MPPaymentMethod *)) success onFailure:(void (^)(NSError *)) failure;

@end
