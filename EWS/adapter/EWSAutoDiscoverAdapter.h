//
//  EWSAutoDiscover.h
//  EWS
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWSApiAdapter.h"

@interface EWSAutoDiscoverAdapter : NSObject <EWSApiAdapter>

-(instancetype)initWith:(NSString*)autoDiscoverUrl emailAddress:(NSString*)emailAddress;

@end
