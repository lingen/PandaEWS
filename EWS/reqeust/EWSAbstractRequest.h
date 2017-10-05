//
//  EWSAbstractRequest.h
//  EWS
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWSApiAdapter.h"


@class EWSEmailBoxModel;

@interface EWSAbstractRequest : NSObject

-(instancetype)initWith:(EWSEmailBoxModel*)emailModel apiAdapter:(id<EWSApiAdapter>)apiAdapter;

-(void)request:(void(^)(id result,NSError* error))resultBlock;

@end
