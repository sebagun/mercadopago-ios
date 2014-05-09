//
//  MPRestClient.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/7/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPRequestService.h"

//Handle sucessful responses
typedef void (^MPSuccessRequestHandler)(NSDictionary *json, NSInteger statusCode);

//Handle NSErrors and HTTP error status codes. If there's a json response then json won't be nil
typedef void (^MPFailureRequestHandler)(NSDictionary *json, NSInteger statusCode, NSError *error);

@interface MPJSONRestClient : MPRequestService

//Both inits automatically add json Content-Type and Accept headers for you
- (instancetype) init;
- (instancetype) initWithHeaders:(NSDictionary *)headers;

- (void) getJSONFromUrl:(NSString *)urlString onSuccess:(MPSuccessRequestHandler)success onFailure:(MPFailureRequestHandler)failure;
- (void) postJSON:(NSDictionary *)json toUrl:(NSString *)urlString onSuccess:(MPSuccessRequestHandler)success onFailure:(MPFailureRequestHandler)failure;
- (void) postJSONString:(NSString *)json toUrl:(NSString *)urlString onSuccess:(MPSuccessRequestHandler)success onFailure:(MPFailureRequestHandler)failure;

@end
