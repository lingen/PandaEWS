
#import <Foundation/Foundation.h>


@class EWSEmailBoxModel;
@class EWSInboxListModel;
@class EWSItemContentModel;
@interface EWSService : NSObject

@property (nonatomic, strong) EWSEmailBoxModel *ewsEmailBoxModel;

+(instancetype)sharedInstance;

-(void)queryEwsUrlByAutoDiscovery:(void(^)(NSString* ewsUrl,NSError* error))resultBlock;

-(void)fetchInboxItems:(void(^)(NSArray* items,NSError* error))resultBlock;

-(void)fetchItemContent:(EWSInboxListModel*)model resultBlock:(void(^)(EWSItemContentModel* contentModel,NSError* error))resultBlock;

-(void)fetchAttachment:(NSString*)attachmentId resultBlock:(void(^)(NSData* data,NSError* error))resultBlock;

@end
