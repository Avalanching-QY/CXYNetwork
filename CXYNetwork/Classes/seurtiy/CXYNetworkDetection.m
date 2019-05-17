//
//  CXYNetworkDetection.m
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/17.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import "CXYNetworkDetection.h"

static CXYNetworkDetection *single = nil;

@interface CXYNetworkDetection ()

@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;

@property (nonatomic, assign) AFNetworkReachabilityStatus status;

@end

@implementation CXYNetworkDetection

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
        _reachability = [AFNetworkReachabilityManager manager];
    }
    return self;
}

#pragma mark - public

- (RACSignal *)start {
    [_reachability stopMonitoring];
    
    if (!_single) {
        __weak __typeof(self) weakself = self;
        [_reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            __strong __typeof(weakself) strongself = weakself;
            strongself.status = status;
        }];

        RACSignal *single = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            __strong __typeof(weakself) strongself = weakself;
            return [RACObserve(strongself, status) subscribeNext:^(id  _Nullable x) {
                [subscriber sendNext:x];
            }];
        }];
        _single = single;
    }
    [_reachability startMonitoring];
    
    return _single;
}

@end


