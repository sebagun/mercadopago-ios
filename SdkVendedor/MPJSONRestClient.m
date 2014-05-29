//
//  MPRestClient.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/7/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPJSONRestClient.h"

@interface MPJSONRestClient ()

- (MPRequestCompletionHandler) complationHandlerWithSucess:(MPSuccessRequestHandler) success andFailure:(MPFailureRequestHandler) failure;

@end

@implementation MPJSONRestClient

#pragma mark -
#pragma mark Init
- (instancetype) init
{
    self = [super initWithHeaders:@{@"Content-Type":@"application/json;charset=UTF-8",@"Accept":@"application/json"}];
    return self;
}

- (instancetype) initWithHeaders:(NSDictionary *)headers
{
    NSMutableDictionary *heads = [[NSMutableDictionary alloc] init];
    [heads addEntriesFromDictionary:headers];
    [heads setObject:@"application/json;charset=UTF-8" forKey:@"Content-Type"];
    [heads setObject:@"application/json" forKey:@"Accept"];
    self = [super initWithHeaders:heads];
    
    return self;
}

#pragma mark -
#pragma mark Requests
- (NSURLSessionDataTask *) getJSONFromUrl:(NSString *)urlString onSuccess:(MPSuccessRequestHandler)success onFailure:(MPFailureRequestHandler)failure
{
    MPRequestCompletionHandler onCompletion = [self complationHandlerWithSucess:success andFailure:failure];
    
    return [self getDataFromUrl:urlString onComplention:onCompletion];
}

- (NSURLSessionDataTask *) postJSON:(id)json toUrl:(NSString *)urlString onSuccess:(MPSuccessRequestHandler)success onFailure:(MPFailureRequestHandler)failure
{
    if([NSJSONSerialization isValidJSONObject:json]){
        MPRequestCompletionHandler onCompletion = [self complationHandlerWithSucess:success andFailure:failure];
        NSError *error;
        NSData *body = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:&error];
        if (error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                           ^(){
                               failure(nil,0,error);
                           });
        }else{
            return [self postData:body toUrl:urlString onCompletion:onCompletion];
        }
    }else{
        NSDictionary *info = @{@"error":[NSString stringWithFormat:@"Trying to post invalid json to url %@",urlString]};
        NSError *error = [NSError errorWithDomain:@"invalid_json" code:100 userInfo:info];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure(nil,0,error);
                       });
    }
    return nil;
}

- (NSURLSessionDataTask *) postJSONString:(NSString *)json toUrl:(NSString *)urlString onSuccess:(MPSuccessRequestHandler)success onFailure:(MPFailureRequestHandler)failure
{
    MPRequestCompletionHandler onCompletion = [self complationHandlerWithSucess:success andFailure:failure];
    NSData *body = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [self postData:body toUrl:urlString onCompletion:onCompletion];
}


#pragma mark -
#pragma mark Private
- (MPRequestCompletionHandler) complationHandlerWithSucess:(MPSuccessRequestHandler) success andFailure:(MPFailureRequestHandler) failure
{
    return ^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            //failure by error
            failure(nil,0,error);
        }else{
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200 || httpResp.statusCode == 201) {
                NSError *errorParsing;
                id json = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&errorParsing];
                if (errorParsing) {
                    failure(nil,0,errorParsing);
                }else{
                    success(json,httpResp.statusCode);
                }
            }else{
                //failure by http error status
                //check if response is json data
                if ([[[httpResp allHeaderFields] objectForKey:@"Content-Type"] rangeOfString:@"application/json"].location != NSNotFound) {
                    NSError *errorParsing;
                    id json = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&errorParsing];
                    failure(json,httpResp.statusCode,error); //just original error
                }else{
                    failure(nil,httpResp.statusCode,error);
                }
            }
        }
    };
}

@end
