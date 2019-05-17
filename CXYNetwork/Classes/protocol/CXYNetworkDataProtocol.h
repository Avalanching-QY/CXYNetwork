//
//  CXYNetworkDataProtocol.h
//  CXYNetwork_Example
//
//  Created by Avalanching on 2019/5/16.
//  Copyright © 2019 avanlanching. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CYXNetworkStatus) {
    CYXNetworkStatusIsTimeout   = -1,   // 超时了
    CYXNetworkStatusIsSuccess   = 0,    // 请求成功
    CYXNetworkStatusIsNoNetwork = 1,    // 没有网络
    CYXNetworkStatusIsOther     = 2,    // 服务器没有返回值预期值
};

@protocol CXYNetworkDataProtocol <NSObject>

@required

@property (nonatomic, copy) NSDictionary *dict;

@property (nonatomic, assign) CYXNetworkStatus errorCode;

@property (nonatomic, assign) NSString *errorMsg;

- (id<CXYNetworkDataProtocol>)initWithCode:(CYXNetworkStatus)networkStatus result:(id)result;

@optional

/**
 @method isMaxPage
 @abstrac 是否到了最大分页
 @result BOOL
 */
- (BOOL)isMaxPage;

/**
 @method maxPage
 @abstrac 最大分页
 @result NSInteger
 */
- (NSInteger)maxPage;


@end
