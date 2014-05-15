//
//  MPCheckout.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/7/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPCheckout.h"
#import "MPJSONRestClient.h"
#import "MPPayerCostInfo.h"
#import "MPExceptionsByCardIssuerInfo.h"
#import "MPCardConfigurationInfo.h"

@interface MPCheckout ()

@property (nonatomic, strong) NSMutableDictionary *paymentMethodsCache;

- (void) searchPaymentMethodById: (NSString *) paymentMethodId onSuccess:(MPSuccessRequestHandler) success onFailure:(MPFailureRequestHandler) failure;

//Returns a NSArray of MPPayerCostInfo
- (NSArray *) payerCostInfoFromJson:(NSArray *) jsonArray;
//Returns a NSArray of MPExceptionsByCardIssuerInfo
- (NSArray *) exceptionsByCardIssuerFromJson:(NSArray *) jsonArray;
//Returns a NSArray of MPExceptionsByCardIssuerInfo
- (NSArray *) cardConfigurationFromJson:(NSArray *) jsonArray;

@end

@implementation MPCheckout

- (void) createTokenWithCardInfo:(MPCardTokenRequestData *) info onSuccess:(void (^)(MPCardTokenResponseData *)) success onFailure:(void (^)(NSError *)) failure
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (info.cardNumber && ![info.cardNumber isEqualToString:@""]) {
        [json setObject:info.cardNumber.copy forKey:@"card_number"];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure([NSError errorWithDomain:@"card_input_error" code:1 userInfo:@{@"description":@"invalid card number"}]);
                       }
                       );
        return;
    }
    
    //if (info.securityCode && ![info.securityCode isEqualToString:@""]) {
    if (info.securityCode) {
        [json setObject:info.securityCode.copy forKey:@"security_code"];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure([NSError errorWithDomain:@"card_input_error" code:2 userInfo:@{@"description":@"invalid security code"}]);
                       }
                       );
        return;
    }
    
    if (info.expirationMonth) {
        [json setObject:info.expirationMonth.copy forKey:@"expiration_month"];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure([NSError errorWithDomain:@"card_input_error" code:3 userInfo:@{@"description":@"invalid expiration month"}]);
                       }
                       );
        return;
    }
    
    if (info.expirationYear) {
        [json setObject:info.expirationYear.copy forKey:@"expiration_year"];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure([NSError errorWithDomain:@"card_input_error" code:4 userInfo:@{@"description":@"invalid expiration month"}]);
                       }
                       );
        return;
    }
    
    NSMutableDictionary *cardholder = [NSMutableDictionary dictionary];
    
    if (info.cardholderName && ![info.cardholderName isEqualToString:@""]) {
        [cardholder setObject:info.cardholderName.copy forKey:@"name"];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure([NSError errorWithDomain:@"card_input_error" code:5 userInfo:@{@"description":@"invalid cardholder name"}]);
                       }
                       );
        return;
    }
    
    NSMutableDictionary *document = [NSMutableDictionary dictionary];
    
    if (info.docType && ![info.docType isEqualToString:@""]) {
        [document setObject:info.docType.copy forKey:@"type"];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure([NSError errorWithDomain:@"card_input_error" code:6 userInfo:@{@"description":@"invalid doc type"}]);
                       }
                       );
        return;
    }
    
    if (info.docNumber && ![info.docNumber isEqualToString:@""]) {
        [document setObject:info.docNumber.copy forKey:@"number"];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure([NSError errorWithDomain:@"card_input_error" code:7 userInfo:@{@"description":@"invalid doc number"}]);
                       }
                       );
        return;
    }
    
    [cardholder setObject:document forKey:@"document"];
    [json setObject:cardholder forKey:@"cardholder"];
    
    MPSuccessRequestHandler successHandler = ^(NSDictionary *json, NSInteger statusCode){
        MPCardTokenResponseData *card = [[MPCardTokenResponseData alloc] init];
        card.cardId = [json objectForKey:@"card_id"];
        card.luhnValidation = [(NSNumber *)[json objectForKey:@"luhn_validation"] boolValue];
        card.status = [json objectForKey:@"status"];
        card.usedDate = [json objectForKey:@"used_date"];
        card.cardNumberLenght = [json objectForKey:@"card_number_length"];
        card.tokenId = [json objectForKey:@"id"];
        card.creationDate = [json objectForKey:@"creation_date"];
        card.truncatedCardNumber = [json objectForKey:@"trunc_card_number"];
        card.securityCodeLenght = [json objectForKey:@"security_code_lenth"];
        card.expirationMonth = [json objectForKey:@"expiration_month"];
        card.expirationYear = [json objectForKey:@"expiration_year"];
        card.lastModifiedDate = [json objectForKey:@"last_modified_date"];
        card.cardholderName = [(NSDictionary *)[json objectForKey:@"cardholder"] objectForKey:@"name"];
        card.docNumber = [(NSDictionary *)[(NSDictionary *)[json objectForKey:@"cardholder"] objectForKey:@"document"] objectForKey:@"number"];
        card.docSubType = [(NSDictionary *)[(NSDictionary *)[json objectForKey:@"cardholder"] objectForKey:@"document"] objectForKey:@"subtype"];
        card.docType = [(NSDictionary *)[(NSDictionary *)[json objectForKey:@"cardholder"] objectForKey:@"document"] objectForKey:@"type"];
        card.dueDate = [json objectForKey:@"due_date"];
        
        success(card);
    };
    
    MPFailureRequestHandler failureHandler = ^(NSDictionary *json, NSInteger statusCode, NSError *error){
        failure(error); //TODO: por ahora paso el error y tiro lo demas a la basura... armar mejor NSError
    };
    
    MPJSONRestClient *client = [[MPJSONRestClient alloc] init];
    [client postJSON:json toUrl:[NSString stringWithFormat:@"https://pagamento.mercadopago.com/card_tokens?public_key=%@",self.publishableKey] onSuccess:successHandler onFailure:failureHandler];
}

- (void) paymentMethodInfoForCardBin:(NSString *) bin onSuccess:(void (^)(MPPaymentMethodInfo *)) success onFailure:(void (^)(NSError *)) failure
{
    if (!bin || [bin isEqualToString:@""]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure([NSError errorWithDomain:@"card_input_error" code:1 userInfo:@{@"description":@"invalid card bin"}]);
                       }
                       );
    }
    
    MPJSONRestClient *client = [[MPJSONRestClient alloc] init];
    
    //on success, cache the payment and then executes the success
    MPSuccessRequestHandler s = ^(NSDictionary *json, NSInteger statusCode){
        //TODO [self.paymentMethodsCache setObject:json forKey:[json valueForKey:@"id"]];
        MPPaymentMethodInfo *p = [[MPPaymentMethodInfo alloc]init];
        p.paymentMethodId = [json objectForKey:@"id"];
        p.name = [json objectForKey:@"name"];
        p.paymentTypeId = [json objectForKey:@"payment_type_id"];
        MPCardIssuerInfo *issuer = [[MPCardIssuerInfo alloc] init];
        issuer.issuerId = [(NSDictionary *)[json objectForKey:@"card_issuer"] objectForKey:@"id"];
        issuer.name = [(NSDictionary *)[json objectForKey:@"card_issuer"] objectForKey:@"name"];
        p.issuerInfo = issuer;
        p.siteId = [json objectForKey:@"site_id"];
        p.secureThumbnail = [json objectForKey:@"secure_thmubnail"];
        p.thumbnail = [json objectForKey:@"thumbnail"];
        p.labels = [json objectForKey:@"labels"];
        p.minAccreditationDays = [json objectForKey:@"min_accreditation_days"];
        p.maxAccreditationDays = [json objectForKey:@"max_accreditation_days"];
        p.payerCosts = [self payerCostInfoFromJson:[json objectForKey:@"payer_costs"]];
        p.exceptionsByCardIssuer = [self exceptionsByCardIssuerFromJson:[json objectForKey:@"exceptions_by_card_issuer"]];
        p.cardConfiguration = [self cardConfigurationFromJson:[json objectForKey:@"card_configuration"]];

        success(p);
    };
    
    MPFailureRequestHandler failureHandler = ^(NSDictionary *json, NSInteger statusCode, NSError *error){
        failure(error); //TODO: por ahora paso el error y tiro lo demas a la basura... armar mejor NSError
    };
    
    [client getJSONFromUrl: [NSString stringWithFormat:@"https://api.mercadolibre.com/checkout/custom/payment_methods/search?public_key=%@&bin=%@",self.publishableKey, bin] onSuccess:s onFailure:failureHandler];
    
}

#pragma mark -
#pragma mark private
- (void) searchPaymentMethodById: (NSString *) paymentMethodId onSuccess:(MPSuccessRequestHandler) success onFailure:(MPFailureRequestHandler) failure
{
    if (!paymentMethodId || [paymentMethodId isEqualToString:@""]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^(){
                           failure(nil,0,[NSError errorWithDomain:@"apicall_input_error" code:1 userInfo:@{@"description":@"invalid payment method id"}]);
                       }
                       );
    }
    
    MPJSONRestClient *client = [[MPJSONRestClient alloc] init];
    [client getJSONFromUrl: [NSString stringWithFormat:@"https://api.mercadolibre.com/checkout/custom/payment_methods/search?public_key=%@&payment_method=%@",self.publishableKey, paymentMethodId] onSuccess:success onFailure:failure];
}

- (NSArray *) payerCostInfoFromJson:(NSArray *) jsonArray
{
    if (jsonArray && [jsonArray count] > 0) {
        NSMutableArray *ma = [[NSMutableArray alloc]init];
        for (NSDictionary *d in jsonArray) {
            MPPayerCostInfo *cost = [[MPPayerCostInfo alloc]init];
            cost.installments = [d objectForKey:@"installments"];
            cost.installmentRate = [d objectForKey:@"installment_rate"];
            cost.labels = [d objectForKey:@"labels"];
            cost.minAllowedAmount = [d objectForKey:@"min_allowed_amount"];
            cost.maxAllowedAmount = [d objectForKey:@"max_allowed_amount"];
            [ma addObject:cost];
        }
        NSArray *ar = [ma copy];
        ma = nil;
        return ar;
    }
    return nil;
}

- (NSArray *) exceptionsByCardIssuerFromJson:(NSArray *) jsonArray
{
    if (jsonArray && [jsonArray count] > 0) {
        NSMutableArray *ma = [[NSMutableArray alloc]init];
        for (NSDictionary *d in jsonArray) {
            MPExceptionsByCardIssuerInfo *exc = [[MPExceptionsByCardIssuerInfo alloc]init];
            MPCardIssuerInfo *issuer = [[MPCardIssuerInfo alloc]init];
            issuer.issuerId = [[d objectForKey:@"card_issuer"]objectForKey:@"id"];
            issuer.name = [[d objectForKey:@"card_issuer"]objectForKey:@"name"];
            exc.issuerInfo = issuer;
            exc.labels = [d objectForKey:@"label"];
            exc.thumbnail = [d objectForKey:@"thumbnail"];
            exc.secureThumbnail = [d objectForKey:@"secure_thumbnail"];
            exc.payerCosts = [self payerCostInfoFromJson:[d objectForKey:@"payer_costs"]];
            exc.acceptedBins = [d objectForKey:@"accepted_bins"];
            exc.totalFinantialCost = [d objectForKey:@"total_financial_cost"];
            [ma addObject:exc];
        }
        NSArray *ar = [ma copy];
        ma = nil;
        return ar;
    }
    return nil;
}

- (NSArray *) cardConfigurationFromJson:(NSArray *) jsonArray
{
    if (jsonArray && [jsonArray count] > 0) {
        NSMutableArray *ma = [[NSMutableArray alloc]init];
        for (NSDictionary *d in jsonArray) {
            MPCardConfigurationInfo *conf = [[MPCardConfigurationInfo alloc]init];
            conf.binCardPattern = [d objectForKey:@"bin_card_pattern"];
            conf.binCardExclusionPattern = [d objectForKey:@"bin_card_exclusion_pattern"];
            conf.cardNumberLength = [[[NSNumberFormatter alloc]init]numberFromString:[d objectForKey:@"card_number_length"]];
            conf.securityCodeLength = [d objectForKey:@"security_code_lenght"];
            conf.luhnAlgorithm = [d objectForKey:@"luhn_algorithm"];
            conf.installmentBinsPattern = [d objectForKey:@"installment_bins_pattern"];
            conf.additionalInfoNeeded = [d objectForKey:@"additional_info_needed"];
            [ma addObject:conf];
        }
        NSArray *ar = [ma copy];
        ma = nil;
        return ar;
    }
    return nil;
}

- (NSMutableDictionary *) paymentMethodsCache
{
    if (!_paymentMethodsCache) {
        _paymentMethodsCache = [NSMutableDictionary dictionary];
    }
    return _paymentMethodsCache;
}

@end
