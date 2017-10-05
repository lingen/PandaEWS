//
//  EWSApiProtocol.h
//  EWS
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EWSApiAdapter <NSObject>

@required

-(NSString*_Nonnull)requestXmlString;

//解析XML到固定的Model
-(void)pareseDataToModel:(NSData* _Nonnull)xmlData resultBlock:(void(^_Nullable)(id _Nullable result))resutBlock;

@optional
/*
 * 请求URL，如果没有实现，则取EwsURL
 */
-(NSString*_Nullable)requestUrl;

@end
