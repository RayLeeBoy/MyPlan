//
//  LCLNetworkManager.h
//  LCLUIDemo
//
//  Created by 正图数创 on 2018/10/19.
//  Copyright © 2018年 正图数创. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCLNetworkManager : NSObject


/**
 GET请求

 @param urlString 字符串 请求地址
 @param parameters 字典 请求参数
 @param success Block 请求成功执行的操作
 @param failure Block 语法失败执行的操作
 */
+ (void)GET:(NSString *)urlString parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 POST请求

 @param urlString 字符串 请求地址
 @param parameters 字典 请求参数
 @param success Block 请求成功执行的操作
 @param failure Block 语法失败执行的操作
 */
+ (void)POST:(NSString *)urlString parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@end
