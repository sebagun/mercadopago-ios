//
//  MPCheckout.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/7/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MercadoPago.h"
#import "MPJSONRestClient.h"
#import "MPUtils.h"
#import "MPError.h"

@interface MercadoPago ()

@end

@implementation MercadoPago

+ (id)alloc
{
    [NSException raise:@"CannotInstantiateStaticClass" format:@"'MercadoPago' is a static class and cannot be instantiated."];
    return nil;
}

+ (void) createTokenWithCard:(MPCard *) card onSuccess:(void (^)(MPCardToken *)) success onFailure:(void (^)(NSError *)) failure
{
    [[self class] validateKey];
    
    if (success == nil)
        [NSException raise:@"RequiredParameter" format:@"'success' is required to use the token that is created"];
    if (failure == nil)
        [NSException raise:@"RequiredParameter" format:@"'failure' is required."];
    
    //Validate card
    NSError *error;
    if(![card validateCardReturningError:&error]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure(error);
                       }
                       );
        return;
    }
    
    //Build JSON
    NSDictionary *json = [card buildJSON];
    
    //Handle JSON success response from API
    MPSuccessRequestHandler successHandler = ^(id json, NSInteger statusCode){
        MPCardToken *token = [[MPCardToken alloc] initFromDictionary:json];
        success(token);
    };
    //Handle failure response from API or error
    MPFailureRequestHandler failureHandler = ^(id json, NSInteger statusCode, NSError *error){
        if (error) {
            failure(error);
        }else{
            //handle api http error
            NSError *apiError = [MPUtils createErrorWithJSON:json HTTPstatus:statusCode userMessage:MPTokenApiCallErrorUserMessage];
            failure(apiError);
        }
    };
    //POST to API
    MPJSONRestClient *client = [[MPJSONRestClient alloc] init];
    [client postJSON:json toUrl:[NSString stringWithFormat:@"https://pagamento.mercadopago.com/card_tokens?public_key=%@",publishableKey] onSuccess:successHandler onFailure:failureHandler];
}

+ (void) paymentMethodForCardBin:(NSString *) bin onSuccess:(void (^)(MPPaymentMethod *)) success onFailure:(void (^)(NSError *)) failure
{
    [[self class] validateKey];
    
    NSError *validationError;
    
    if ([MPUtils validateCardBin:bin error:&validationError] && validationError) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure(validationError);
                       }
        );
        return;
    }
    
    //Handle JSON success response from API
    MPSuccessRequestHandler s = ^(id jsonArr, NSInteger statusCode){
        
        NSArray *arr = (NSArray *)jsonArr;
        
        if ([arr count] > 1) {
            //Not possible now. In the past some bins had more than one payment method.
        }
        
        NSDictionary *json = [arr objectAtIndex:0];
        
        MPPaymentMethod *p = [[MPPaymentMethod alloc]initFromDictionary:json];
        success(p);
    };
    
    //Handle failure response from API or error
    MPFailureRequestHandler failureHandler = ^(id json, NSInteger statusCode, NSError *error){
        if (error) {
            failure(error);
        }else{
            NSError *apiError = [MPUtils createErrorWithJSON:json HTTPstatus:statusCode userMessage:MPPaymentMethodApiCallErrorUserMessage];
            failure(apiError);
        }
    };
    
    //GET payment method with the bin
    MPJSONRestClient *client = [[MPJSONRestClient alloc] init];
    [client getJSONFromUrl: [NSString stringWithFormat:@"https://api.mercadolibre.com/checkout/custom/payment_methods/search?public_key=%@&bin=%@",publishableKey, bin] onSuccess:s onFailure:failureHandler];
    
}

#pragma mark -
#pragma mark publishable key
static NSString *publishableKey;
+ (NSString *) publishableKey
{
    return publishableKey;
}
+ (void) setPublishableKey: (NSString *) key
{
    if (!key || [key isEqualToString:@""])
        [NSException raise:@"InvalidPublishableKey" format:@"You must use a valid publishable key to create a token."];
    
    publishableKey = key;
}
+ (void)validateKey
{
    if (!publishableKey || [publishableKey isEqualToString:@""])
        [NSException raise:@"InvalidPublishableKey" format:@"You must use a valid publishable key to create a token."];
}

@end
