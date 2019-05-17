//
//  CXYNetworkDetection.h
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/17.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface CXYNetworkDetection : NSObject

@property (nonatomic, strong, readonly) RACSignal *single;

@property (nonatomic, assign, readonly) AFNetworkReachabilityStatus status;

+ (instancetype)singletons;

- (RACSignal *)start;

@end
