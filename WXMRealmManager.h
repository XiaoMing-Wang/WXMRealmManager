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

/**  */
//- (void)judgeRealmCache;

#pragma mark _____________________________________________ 增 + 改
- (BOOL)saveRLMObjectWithObj:(RLMObject *)obj;                              /** 增加单个 */
- (NSInteger)saveRLMObjectsWithArray:(NSArray<RLMObject *> *)array;         /** 增加多个 */
- (NSInteger)saveRLMObjectsSingletonWithArray:(NSArray<RLMObject *> *)array;/** 先删除(副键)再添加 */

#pragma mark _____________________________________________ 删除

/** 通过主键删除 */
- (BOOL)removeRLMObjectWithObj:(RLMObject *)obj;
- (BOOL)removeRLMObjectWithPrimaryKeyValue:(id)primaryKeyValue class:(Class)aClass;

/** 通过副键删除 */
- (NSInteger)removeRLMObjectWithViceKeyValue:(id)viceKeyValue class:(Class)aClass;
- (NSInteger)removeRLMObjectWithViceKey:(id)viceKey
                           viceKeyValue:(id)viceKeyValue
                                  class:(Class)aClass;

#pragma mark _____________________________________________ 查

/** 通过主键获取单个缓存对象(主键唯一) */
- (id)objWithPrimaryKeyValue:(id)primaryKeyValue class:(Class)aClass;
/** 副键查询 */
- (NSArray <RLMObject *>*)objWithViceKeyValue:(id)viceKeyValue class:(Class)aClass;
- (NSArray <RLMObject *>*)objWithViceKey:(id)viceKey
                            viceKeyValue:(id)viceKeyValue
                                   class:(Class)aClass;
@end

