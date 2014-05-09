//
//  MPCheckout.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/7/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPJSONRestClient.h"
#import "MPCardInfo.h"

@interface MPCheckout : NSObject

@property (nonatomic,strong) NSString *publishableKey;

/* Advanced
- (void) paymentMethodInfoForCardNumber:(NSString *) bin onSuccess:(MPSuccessRequestHandler) success onFailure:(MPFailureRequestHandler) failure;

- (void) installmentsForPaymentMethodId:(NSString *) methodId andAmount:(NSNumber *) amount onSuccess:(MPSuccessRequestHandler) success onFailure:(MPFailureRequestHandler) failure;

- (void) cardIssuersForPaymentMethodId:(NSString *) methodId onSuccess:(MPSuccessRequestHandler) success onFailure:(MPFailureRequestHandler) failure;

- (void) installmentsForIssuerId:(NSNumber *) issuerId andAmount:(NSNumber *) amount onSuccess:(MPSuccessRequestHandler) success onFailure:(MPFailureRequestHandler) failure;
*/

- (void) createTokenWithCardInfo:(MPCardInfo *) info onSuccess:(MPSuccessRequestHandler) success onFailure:(MPFailureRequestHandler) failure;

@end
