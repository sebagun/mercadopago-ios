//
//  MPCheckout.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/7/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MercadoPago.h"
#import "MPJSONRestClient.h"
#import "MPPayerCost.h"
#import "MPExceptionsByCardIssuer.h"
#import "MPCardConfiguration.h"
#import "MPUtils.h"
#import "MPError.h"

@interface MercadoPago ()

@end

@implementation MercadoPago

+ (void) createTokenWithCard:(MPCard *) card onSuccess:(void (^)(MPCardToken *)) success onFailure:(void (^)(NSError *)) failure
{
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
    NSError *validationError;
    [MPUtils validateCardBin:bin error:&validationError];
    
    if (validationError) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure(validationError);
                       }
        );
    }
    
    //Handle JSON success response from API
    MPSuccessRequestHandler s = ^(id jsonArr, NSInteger statusCode){
        NSDictionary *json = [(NSArray *)jsonArr objectAtIndex:0]; //ugly!!!! but it's the only way. Some mastercard issuers use the same bin in ARG, so the API will return more than one payment_method in those cases
        
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
    publishableKey = key;
}

@end
