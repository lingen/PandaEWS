
#import <Foundation/Foundation.h>
#import "EWSEmailBoxModel.h"

@interface EWSHttpRequest : NSObject <NSURLSessionDelegate>

@property (nonatomic, strong) EWSEmailBoxModel *emailBoxModel;

-(void)ewsHttpRequest:(NSString *)soapXmlString
               andUrl:(NSString *)url
      receiveResponse:(void (^)(NSURLResponse *response))receiveResponseBlock
          reveiveData:(void (^)(NSData *data))receiveDataBlock
        finishLoading:(void (^)())finishLoadingBlock
                error:(void (^)(NSError *error))errorBlock;

-(void)ewsHttpRequest:(NSString *)soapXmlString
               andUrl:(NSString *)url
         emailBoxInfo:(EWSEmailBoxModel *)emailBoxInfo
      receiveResponse:(void (^)(NSURLResponse *response))receiveResponseBlock
          reveiveData:(void (^)(NSData *data))receiveDataBlock
        finishLoading:(void (^)())finishLoadingBlock
                error:(void (^)(NSError *error))errorBlock;

@end
