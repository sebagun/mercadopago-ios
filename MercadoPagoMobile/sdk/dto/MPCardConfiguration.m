//
//  MPCardConfigurationInfo.m
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import "MPCardConfiguration.h"

@implementation MPCardConfiguration

- (instancetype) initFromDictionary: (NSDictionary *) dict
{
    if (self = [super init]) {
        self.binCardPattern = [dict objectForKey:@"bin_card_pattern"];
        self.binCardExclusionPattern = [dict objectForKey:@"bin_card_exclusion_pattern"];
        self.cardNumberLength = [[[NSNumberFormatter alloc]init]numberFromString:[dict objectForKey:@"card_number_length"]];
        self.securityCodeLength = [dict objectForKey:@"security_code_lenght"];
        self.luhnAlgorithm = [dict objectForKey:@"luhn_algorithm"];
        self.installmentBinsPattern = [dict objectForKey:@"installment_bins_pattern"];
        self.additionalInfoNeeded = [dict objectForKey:@"additional_info_needed"];
    }
    
    return self;
}

@end
