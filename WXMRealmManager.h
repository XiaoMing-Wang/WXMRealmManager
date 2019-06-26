//
//  RLMRealmManager.h
//  ChaomengPlanet
//
//  Created by 超盟 on 2018/10/23.
//  Copyright © 2018年 wq. All rights reserved.
//
/** 版本号 */
#define WXMRealmInstance [WXMRealmManager sharedInstance]
#define RLMRealmVersion 1.0
#import <Foundation/Foundation.h>
#import <Realm.h>

@interface WXMRealmManager : NSObject

+ (WXMRealmManager *)sharedInstance;
//- (void)judgeRealmCache;

#pragma mark   增+改

/** 主键增加单个 */
- (BOOL)saveRLMObjectWithObj:(RLMObject *)obj;

/** 副键增加多个 */
- (NSInteger)saveRLMObjectsWithArray:(NSArray<RLMObject *> *)array;

/** 副键先删除再加多个 */
- (NSInteger)saveRLMObjectsSingletonWithArray:(NSArray<RLMObject *> *)array;

#pragma mark   查
/** 主键查询 */
- (id)objWithPrimaryKeyValue:(id)primaryKeyValue class:(Class)aClass;

/** 副键查询 */
- (NSArray <RLMObject *>*)objWithViceKeyValue:(id)viceKeyValue class:(Class)aClass;
- (NSArray <RLMObject *>*)objWithViceKey:(id)viceKey
                            viceKeyValue:(id)viceKeyValue
                                   class:(Class)aClass;

#pragma mark   删除
/** 主键删除 */
- (BOOL)removeRLMObjectWithObj:(RLMObject *)obj;
- (BOOL)removeRLMObjectWithPrimaryKeyValue:(id)primaryKeyValue class:(Class)aClass;

/** 副键删除 */
- (NSInteger)removeRLMObjectWithViceKeyValue:(id)viceKeyValue class:(Class)aClass;
- (NSInteger)removeRLMObjectWithViceKey:(id)viceKey
                           viceKeyValue:(id)viceKeyValue
                                  class:(Class)aClass;
@end

