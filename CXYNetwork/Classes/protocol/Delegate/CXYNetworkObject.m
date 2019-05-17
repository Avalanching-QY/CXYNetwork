//
//  CXYNetworkObject.m
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/16.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import "CXYNetworkObject.h"
#import <objc/runtime.h>

@implementation CXYNetworkObject

@synthesize dict = _dict;

@synthesize errorCode = _errorCode;
@synthesize errorMsg = _errorMsg;


//#pragma mark - setting getting
//
//- (void)setDict:(NSDictionary *)dict {
//    _dict = dict;
//}
//
//- (void)setErrorCode:(CYXNetworkStatus)errorCode {
//    _errorCode = errorCode;
//}
//
//- (void)setErrorMsg:(NSString *)errorMsg {
//    _errorMsg = errorMsg;
//}

#pragma mark - CXYNetworkDataProtocol

- (id<CXYNetworkDataProtocol>)initWithCode:(CYXNetworkStatus)networkStatus result:(id)result {
    
    self = [super init];
    if (self) {
        self.errorCode = networkStatus;
        [self analysisDataWithObject:result];
    }
    return self;
}

- (void)analysisDataWithObject:(id)objcet {
    if ([objcet isKindOfClass:[NSDictionary class]]) {
        self.dict = objcet;
        self.errorCode = [[objcet objectForKey:@"ret"] intValue];
        self.errorMsg = [objcet objectForKey:@"msg"];
    } else {
        self.dict = @{@"value":objcet == nil ? @"" : objcet};
        switch (self.errorCode) {
            case CYXNetworkStatusIsTimeout:
                self.errorMsg = @"网络超时";
                break;
            case CYXNetworkStatusIsSuccess:
                self.errorMsg = @"请求成功";
                break;
            case CYXNetworkStatusIsNoNetwork:
                self.errorMsg = @"网络链接中断";
                break;
            default:
                self.errorMsg = @"服务器异常";
                break;
        }
    }
}

@end
