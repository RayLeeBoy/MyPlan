//
//  LCLNetworkManager.m
//  LCLUIDemo
//
//  Created by 正图数创 on 2018/10/19.
//  Copyright © 2018年 正图数创. All rights reserved.
//

#import "LCLNetworkManager.h"

@implementation LCLNetworkManager

+ (void)GET:(NSString *)urlString parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager GET:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)POST:(NSString *)urlString parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer.timeoutInterval = 10;
    
    [manager GET:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
