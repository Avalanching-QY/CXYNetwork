//
//  Target_Networking.m
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/16.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import "Target_Networking.h"

static Target_Networking *single = nil;

@implementation Target_Networking

#pragma mark - singletons

+ (instancetype)singletons {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[super allocWithZone:NULL] init];
    });
    
    return single;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self singletons];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self class] singletons];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [[self class] singletons];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - public method

- (NSString *)currentUrlWithSubString:(NSString *)suffix {
    static NSString *const domain = @"https://app-service.cx580.com";
    if (!suffix) {
        suffix = @"";
    } else {
        suffix = [suffix stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    NSString *result = [NSString stringWithFormat:@"%@%@", domain, suffix];
    return result;
}

@end
