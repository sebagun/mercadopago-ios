//
//  MPRequestService.m
//  MercadoPagoMobile
//
//  Created by jgyonzo on 5/6/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPRequestService.h"

@interface MPRequestService ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation MPRequestService

#pragma mark -
#pragma mark Init
//init with custom headers
- (instancetype) initWithHeaders:(NSDictionary *) headers
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setHTTPAdditionalHeaders:headers];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    return self;
}

//init with default config
- (instancetype) init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    return self;
}

#pragma mark -
#pragma mark Requests

- (NSURLSessionDataTask *) getDataFromUrl:(NSString *)urlString onComplention:(MPRequestCompletionHandler)onCompletion
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask * dataTask = [self.session dataTaskWithURL:url completionHandler:onCompletion];
    [dataTask resume];
    return dataTask;
}

- (NSURLSessionDataTask *) postData:(NSData *)data toUrl:(NSString *)urlString onCompletion:(MPRequestCompletionHandler)onCompletion
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:data];
    NSURLSessionDataTask * dataTask = [self.session dataTaskWithRequest:urlRequest completionHandler:onCompletion];
    [dataTask resume];
    return dataTask;
}

@end
