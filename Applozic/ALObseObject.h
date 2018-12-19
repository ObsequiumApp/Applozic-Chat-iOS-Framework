//
//  ALObseObject.h
//  AFNetworking
//
//  Created by EmvigoSuperMac on 09/03/18.
//

#import <Foundation/Foundation.h>

@interface ALObseObject : NSObject



// Group details
@property (strong, nonatomic) NSString *groupId1;
@property (nonatomic, strong) NSString *groupName1;
@property (strong, nonatomic) NSString *appLGroupId1;
@property (strong, nonatomic) NSArray *groupMembers1;
@property (strong, nonatomic) NSString *contactCategorytoUniqueId1;


//Method used to get meeting group members...
+ (void)getGroupMembers:(NSString*)userName friendName:(NSString*)friendName catId:(NSString*)catId groupId:(NSString*)groupId meetingId:(NSString*)meetingId deviceId:(NSString*)deviceId success:(void (^)(ALObseObject *oneObj))success failure:(void (^)(NSString *error))failure;

//Method used to add group members...
+ (void)addGroup:(NSString*)userName groupName:(NSString*)groupName groupId:(NSString*)groupId entityID:(NSString*)entityID appLozicGroupID:(NSString*)appLozicGroupID Members:(NSString*)Members  deviceId:(NSString*)deviceId success:(void (^)(ALObseObject *oneObj))success failure:(void (^)(NSString *error))failure;

//Method used to update group members...
+ (void)updateGroup:(NSString*)userName groupId:(NSString*)groupId groupName:(NSString*)groupName deviceId:(NSString*)deviceId success:(void (^)(NSDictionary *oneObj))success failure:(void (^)(NSString *error))failure;

//Method used to remove group member...
+ (void)removeGroupMember:(NSString*)userName groupId:(NSString*)groupId toUserUniqueId:(NSString*)toUserUniqueId deviceId:(NSString*)deviceId success:(void (^)(ALObseObject *oneObj))success failure:(void (^)(NSString *error))failure;

//Method used to delete group member...
+ (void)deleteGroupMember:(NSString*)userName groupUniqueId:(NSString*)groupUniqueId deviceId:(NSString*)deviceId success:(void (^)(NSDictionary *oneObj))success failure:(void (^)(NSString *error))failure;


@end
