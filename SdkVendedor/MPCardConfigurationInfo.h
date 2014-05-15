//
//  MPCardConfigurationInfo.h
//  SdkVendedor
//
//  Created by jgyonzo on 5/12/14.
//  Copyright (c) 2014 MercadoPago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPCardConfigurationInfo : NSObject

@property (nonatomic,strong) NSString *binCardPattern;
@property (nonatomic,strong) NSString *binCardExclusionPattern;
@property (nonatomic,strong) NSNumber *cardNumberLength;
@property (nonatomic,strong) NSNumber *securityCodeLength;
@property (nonatomic,strong) NSString *luhnAlgorithm;
@property (nonatomic,strong) NSString *installmentBinsPattern;
@property (nonatomic,strong) NSArray *additionalInfoNeeded;//array of NSString

@end
