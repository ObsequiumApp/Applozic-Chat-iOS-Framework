//
//  ALObseObject.m
//  AFNetworking
//
//  Created by EmvigoSuperMac on 09/03/18.
//

#import "ALObseObject.h"
#import "ALObseCommon.h"
//#import <AFNetworking/AFURLSessionManager.h>
//#import <AFNetworking/AFNetworking.h>

@implementation ALObseObject






- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties..
    [encoder encodeObject:self.groupId1 forKey:ObseGroupId1];
    [encoder encodeObject:self.groupName1 forKey:ObseGroupName1];
    [encoder encodeObject:self.appLGroupId1 forKey:ObseAppLGroupId1];
    [encoder encodeObject:self.groupMembers1 forKey:ObseGroupMembers1];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
        //decode properties..
        self.groupId1=[decoder decodeObjectForKey:ObseGroupId1];
        self.groupName1=[decoder decodeObjectForKey:ObseGroupName1];
        self.appLGroupId1=[decoder decodeObjectForKey:ObseAppLGroupId1];
        self.groupMembers1=[decoder decodeObjectForKey:ObseGroupMembers1];
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    
    self = [super init];
    if (self == nil) return nil;
    self.groupId1=[dictionary objectForKey:ObseGroupId1];
    self.groupName1=[dictionary objectForKey:ObseGroupName1];
    self.appLGroupId1=[dictionary objectForKey:ObseAppLGroupId1];
    self.groupMembers1=[dictionary objectForKey:ObseGroupMembers1];
    
    return self;
}

static NSOperationQueue *getMeetingGroupRequest;
static NSOperationQueue *addGroupRequest;
static NSOperationQueue *updateGroupRequest;
static NSOperationQueue *removeGroupRequestMember;
static NSOperationQueue *deleteGroupRequest;

    
  //to get group members
+ (void)getGroupMembers:(NSString*)userName friendName:(NSString*)friendName catId:(NSString*)catId groupId:(NSString*)groupId meetingId:(NSString*)meetingId deviceId:(NSString*)deviceId success:(void (^)(ALObseObject *oneObj))success failure:(void (^)(NSString *error))failure
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"https://staging-connect.obsequium.in/api/GetMeetingMembers"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    //    [request setHTTPMethod:@"POST"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters;
    parameters = @{@"uniqueId":userName,@"friendName":friendName,@"catid":catId,@"groupId":groupId,@"meetingID":meetingId,@"deviceId":deviceId};
    NSError *err = nil;
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&err];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //   [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        NSLog(@"[%@]", dictResponse);
        //  NSLog(@"responseValue %@",data);
        
        //NSLog(@"res %@",responseValue);
        BOOL status = [[dictResponse valueForKey:@"status"] boolValue];
        //      BOOL status = 0;
        if(status==0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            success(response);
            
        } else {
            
            NSArray *contactArr=[dictResponse objectForKey:@"groups"];
            //NSMutableDictionary *contactDict=[responseValue objectForKey:@"Memebers"];
            //NSLog(@"bbbb  %@",[responseValue objectForKey:@"Memebers"]);
            for(int i=0;i<contactArr.count;i++)
            {
                NSDictionary *contactListDict=contactArr[i];
                ALObseObject *obj = [[ALObseObject alloc]initWithDictionary:contactListDict];
                
                //                                                [[NSUserDefaults standardUserDefaults] setObject:contactArr forKey:@"membersListArray"];
                success(obj);
            }
            
            
            
            
            if (error) {
                NSLog(@"Error: %@", error);
            }
            else
            {
                NSLog(@"Error: %@", error);
                // failure([ObseCommon getMessageForErrorCode:-1004]);
                
            }
        }
        
        
        
        
        
    }];
    
    [postDataTask resume];
    
    
}

+ (void)addGroup:(NSString*)userName groupName:(NSString*)groupName groupId:(NSString*)groupId entityID:(NSString*)entityID appLozicGroupID:(NSString*)appLozicGroupID Members:(NSString*)Members  deviceId:(NSString*)deviceId success:(void (^)(ALObseObject *oneObj))success failure:(void (^)(NSString *error))failure
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"https://staging-connect.obsequium.in/api/ManageGroup"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    //    [request setHTTPMethod:@"POST"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters;
    parameters = @{@"uniqueId":userName,@"groupName":groupName,@"groupId":groupId,@"entityID":entityID,@"appLozicGroupID":appLozicGroupID,@"Members":Members,@"deviceId":deviceId};
    NSError *err = nil;
    
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&err];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //   [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        NSLog(@"[%@]", dictResponse);
        //  NSLog(@"responseValue %@",data);
        
        
        BOOL status = [[dictResponse valueForKey:@"status"] boolValue];
        //      BOOL status = 0;
        if(status==0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            success(response);
            
        } else {
            
            if([[[dictResponse objectForKey:@"status"] stringValue] isEqualToString:@"1"])
            {
                ALObseObject *obj = [[ALObseObject alloc]initWithDictionary:dictResponse];
                success(obj);
            }
            
            
            if (error) {
                NSLog(@"Error: %@", error);
            }
            else
            {
                NSLog(@"ERROR");
                // failure([ObseCommon getMessageForErrorCode:-1004]);
                
            }
        }
        
    }];
    
    [postDataTask resume];
    

    
}

+ (void)updateGroup:(NSString*)userName groupId:(NSString*)groupId groupName:(NSString*)groupName deviceId:(NSString*)deviceId success:(void (^)(NSDictionary *oneObj))success failure:(void (^)(NSString *error))failure
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"https://staging-connect.obsequium.in/api/UpdateGroupName"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    //    [request setHTTPMethod:@"POST"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters;
     parameters = @{@"uniqueId":userName,@"groupId":groupId,@"groupName":groupName,@"deviceId":deviceId};
    NSError *err = nil;
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&err];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //   [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        NSLog(@"[%@]", dictResponse);
        //  NSLog(@"responseValue %@",data);
        
        
        BOOL status = [[dictResponse valueForKey:@"status"] boolValue];
        //      BOOL status = 0;
        if(status==0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            success(dictResponse);
            
        } else {
            
            if([[[dictResponse objectForKey:@"status"] stringValue] isEqualToString:@"1"])
            {
                success(dictResponse);
            }
            
            
            
            
            if (error) {
                NSLog(@"Error: %@", error);
            }
            else
            {
                NSLog(@"ERROR");
                // failure([ObseCommon getMessageForErrorCode:-1004]);
                
            }
        }
        
        
        
    }];
    
    [postDataTask resume];
    
    
    
    
    
    
   
}

+ (void)removeGroupMember:(NSString*)userName groupId:(NSString*)groupId toUserUniqueId:(NSString*)toUserUniqueId deviceId:(NSString*)deviceId success:(void (^)(ALObseObject *oneObj))success failure:(void (^)(NSString *error))failure
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"https://staging-connect.obsequium.in/api/RemoveGroupMember"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    //    [request setHTTPMethod:@"POST"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters;
    parameters = @{@"uniqueId":userName,@"groupId":groupId,@"toUserUniqueId":toUserUniqueId,@"deviceId":deviceId};
    NSError *err = nil;
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&err];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //   [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        NSLog(@"[%@]", dictResponse);
        //  NSLog(@"responseValue %@",data);
        
        
        BOOL status = [[dictResponse valueForKey:@"status"] boolValue];
        //      BOOL status = 0;
        if(status==0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            success(dictResponse);
            
        } else {
            
            NSArray *contactArr=[dictResponse objectForKey:@"groups"];
            
            for(int i=0;i<contactArr.count;i++)
            {
                NSDictionary *contactListDict=contactArr[i];
                ALObseObject *obj = [[ALObseObject alloc]initWithDictionary:contactListDict];
                
                
                success(obj);
            }
            
            
            
            
            if (error) {
                NSLog(@"Error: %@", error);
            }
            else
            {
                NSLog(@"Error");
                // failure([ObseCommon getMessageForErrorCode:-1004]);
                
            }
            
        }
        
        
        
        
        
        
        
        
        
    }];
    
    [postDataTask resume];
    
    
    
    
    
    
    
    
}

+ (void)deleteGroupMember:(NSString*)userName groupUniqueId:(NSString*)groupUniqueId deviceId:(NSString*)deviceId success:(void (^)(NSDictionary *oneObj))success failure:(void (^)(NSString *error))failure
{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:@"https://staging-connect.obsequium.in/api/DeleteGroup"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    //    [request setHTTPMethod:@"POST"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters;
    parameters = @{@"uniqueId":userName,@"groupUniqueId":groupUniqueId,@"deviceId":deviceId};
    NSError *err = nil;
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&err];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //   [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err = nil;
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        NSLog(@"[%@]", dictResponse);
        //  NSLog(@"responseValue %@",data);
        
        
        BOOL status = [[dictResponse valueForKey:@"status"] boolValue];
        //      BOOL status = 0;
        if(status==0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PIN"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uniqueId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneOtp"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"multiUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            success(dictResponse);
            
        } else {
            
            if([[dictResponse objectForKey:@"message"]isEqualToString:@"Deleted"])
            {
                success(dictResponse);
            }
            
            if (error) {
                NSLog(@"Error: %@", error);
            }
            else
            {
                NSLog(@"error");
                //  failure([ObseCommon getMessageForErrorCode:-1004]);
                
            }
        }
        
    }];
    
    [postDataTask resume];
    
    
    
    
}



@end
