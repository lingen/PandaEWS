
#import "EWSService.h"
#import "EWSEmailBoxModel.h"
#import "EWSAutoDiscoverAdapter.h"
#import "EWSAbstractRequest.h"
#import "EWSFindItemAdapter.h"
#import "EWSGetItemAdapter.h"
#import "EWSGetAttachmentAdapter.h"

@implementation EWSService

+(instancetype)sharedInstance{
    static EWSService* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EWSService alloc] init];
    });
    return instance;
}

-(void)queryEwsUrlByAutoDiscovery:(void(^)(NSString* ewsUrl,NSError* error))resultBlock{
    NSArray *address = [self.ewsEmailBoxModel.emailAddress componentsSeparatedByString:@"@"];
    
    NSMutableArray* autodiscoverAddressList = [[NSMutableArray alloc] init];
    
    [autodiscoverAddressList addObject:[NSString stringWithFormat:@"https://autodiscover.%@/autodiscover/autodiscover.xml",[address objectAtIndex:1]]];
    [autodiscoverAddressList addObject:[NSString stringWithFormat:@"https://%@/autodiscover/autodiscover.xml",[address objectAtIndex:1]]];
    [autodiscoverAddressList addObject:[NSString stringWithFormat:@"https://email.%@/autodiscover/autodiscover.xml",[address objectAtIndex:1]]];
    
    for (NSString* addressList in autodiscoverAddressList) {
        EWSAutoDiscoverAdapter* autoDiscovery = [[EWSAutoDiscoverAdapter alloc] initWith:addressList emailAddress:self.ewsEmailBoxModel.emailAddress];
        EWSAbstractRequest* request  = [[EWSAbstractRequest alloc] initWith:self.ewsEmailBoxModel apiAdapter:autoDiscovery];
        [request request:^(id result, NSError *error) {
            if (result) {
                NSString* stringResult = (NSString*)result;
                resultBlock(stringResult,nil);
            }else{
                resultBlock(nil,error);
            }
        }];
    }
}

-(void)fetchInboxItems:(void(^)(NSArray* items,NSError* error))resultBlock{
    EWSFindItemAdapter* findItemAdapter = [[EWSFindItemAdapter alloc] initWith:@"inbox"];
    EWSAbstractRequest* request  = [[EWSAbstractRequest alloc] initWith:self.ewsEmailBoxModel apiAdapter:findItemAdapter];
    
    [request request:^(id result, NSError *error) {
        if (resultBlock) {
            NSArray* list = (NSArray*)result;
            resultBlock(list,nil);
        }else{
            resultBlock(nil,error);
        }
    }];

}

-(void)fetchItemContent:(EWSInboxListModel*)model resultBlock:(void(^)(EWSItemContentModel* contentModel,NSError* error))resultBlock{
    EWSGetItemAdapter* getItemAdapter = [[EWSGetItemAdapter alloc] initWith:model];
    
    EWSAbstractRequest* request  = [[EWSAbstractRequest alloc] initWith:self.ewsEmailBoxModel apiAdapter:getItemAdapter];
    
    [request request:^(id result, NSError *error) {
        if (resultBlock) {
            EWSItemContentModel* contentModel = (EWSItemContentModel*)result;
            resultBlock(contentModel,nil);
        }else{
            resultBlock(nil,error);
        }
    }];
}

-(void)fetchAttachment:(NSString*)attachmentId resultBlock:(void(^)(NSData* data,NSError* error))resultBlock{
    EWSGetAttachmentAdapter* attachmentAdapter = [[EWSGetAttachmentAdapter alloc] initWith:attachmentId];
    
    EWSAbstractRequest* request  = [[EWSAbstractRequest alloc] initWith:self.ewsEmailBoxModel apiAdapter:attachmentAdapter];
    
    [request request:^(id result, NSError *error) {
        if (resultBlock) {
            NSData* data = (NSData*)result;
            resultBlock(data,nil);
        }else{
            resultBlock(nil,error);
        }
    }];

}

@end
