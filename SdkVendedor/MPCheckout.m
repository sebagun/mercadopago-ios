//
//  MPCheckout.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/7/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPCheckout.h"
#import "MPJSONRestClient.h"

@implementation MPCheckout

- (void) createTokenWithCardInfo:(MPCardInfo *)info onSuccess:(MPSuccessRequestHandler)success onFailure:(MPFailureRequestHandler)failure
{
    MPJSONRestClient *client = [[MPJSONRestClient alloc] init];
    NSMutableDictionary *json = [NSMutableDictionary dictionaryWithCapacity:7];
    
    if (info.cardNumber && ![info.cardNumber isEqualToString:@""]) {
        [json setObject:info.cardNumber.copy forKey:@"card_number"];
    }else{
        dispatch_async(dispatch_get_main_queue(),
                       ^(){
                           failure(nil,0,[NSError errorWithDomain:@"card_input_error" code:1 userInfo:@{@"description":@"invalid card number"}]);
                       }
                       );
        return;
    }
    
    //if (info.securityCode && ![info.securityCode isEqualToString:@""]) {
    if (info.securityCode) {
        [json setObject:info.securityCode.copy forKey:@"security_code"];
    }else{
        dispatch_async(dispatch_get_main_queue(),
                       ^(){
                           failure(nil,0,[NSError errorWithDomain:@"card_input_error" code:2 userInfo:@{@"description":@"invalid security code"}]);
                       }
                       );
        return;
    }
    
    if (info.expirationMonth) {
        [json setObject:info.expirationMonth.copy forKey:@"expiration_month"];
    }else{
        dispatch_async(dispatch_get_main_queue(),
                       ^(){
                           failure(nil,0,[NSError errorWithDomain:@"card_input_error" code:3 userInfo:@{@"description":@"invalid expiration month"}]);
                       }
                       );
        return;
    }
    
    if (info.expirationYear) {
        [json setObject:info.expirationYear.copy forKey:@"expiration_year"];
    }else{
        dispatch_async(dispatch_get_main_queue(),
                       ^(){
                           failure(nil,0,[NSError errorWithDomain:@"card_input_error" code:4 userInfo:@{@"description":@"invalid expiration month"}]);
                       }
                       );
        return;
    }
    
    NSMutableDictionary *cardholder = [NSMutableDictionary dictionary];
    
    if (info.cardholderName && ![info.cardholderName isEqualToString:@""]) {
        [cardholder setObject:info.cardholderName.copy forKey:@"name"];
    }else{
        dispatch_async(dispatch_get_main_queue(),
                       ^(){
                           failure(nil,0,[NSError errorWithDomain:@"card_input_error" code:5 userInfo:@{@"description":@"invalid cardholder name"}]);
                       }
                       );
        return;
    }
    
    NSMutableDictionary *document = [NSMutableDictionary dictionary];
    
    if (info.docType && ![info.docType isEqualToString:@""]) {
        [document setObject:info.docType.copy forKey:@"type"];
    }else{
        dispatch_async(dispatch_get_main_queue(),
                       ^(){
                           failure(nil,0,[NSError errorWithDomain:@"card_input_error" code:6 userInfo:@{@"description":@"invalid doc type"}]);
                       }
                       );
        return;
    }
    
    if (info.docNumber && ![info.docNumber isEqualToString:@""]) {
        [document setObject:info.docNumber.copy forKey:@"number"];
    }else{
        dispatch_async(dispatch_get_main_queue(),
                       ^(){
                           failure(nil,0,[NSError errorWithDomain:@"card_input_error" code:7 userInfo:@{@"description":@"invalid doc number"}]);
                       }
                       );
        return;
    }
    
    [cardholder setObject:document forKey:@"document"];
    [json setObject:cardholder forKey:@"cardholder"];
    
    [client postJSON:json toUrl:[NSString stringWithFormat:@"https://pagamento.mercadopago.com/card_tokens?public_key=%@",self.publishableKey] onSuccess:success onFailure:failure];
}

@end
