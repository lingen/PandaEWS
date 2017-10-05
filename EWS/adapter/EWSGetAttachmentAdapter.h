//
//  EWSGetAttachmentAdapter.h
//  EWS
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EWSApiAdapter.h"

@interface EWSGetAttachmentAdapter : NSObject <EWSApiAdapter>

-(instancetype)initWith:(NSString*)attachmentId;

@end
