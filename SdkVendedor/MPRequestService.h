//
//  MPRequestService.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/6/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

//generic block to handle data request completions
typedef void (^MPRequestCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

@interface MPRequestService : NSObject

- (instancetype) initWithHeaders:(NSDictionary *) headers;

- (NSURLSessionDataTask *) getDataFromUrl:(NSString *) urlString onComplention:(MPRequestCompletionHandler) onCompletion;

- (NSURLSessionDataTask *) postData:(NSData *) data toUrl:(NSString *) urlString onCompletion:(MPRequestCompletionHandler) onCompletion;

@end
