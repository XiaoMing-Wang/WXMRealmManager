//
//  RLMObject+WXMRealmManager.h
//  ModuleDebugging
//
//  Created by edz on 2019/5/11.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "RLMObject.h"

@interface RLMObject (WXMRealmManager)

/** 存 */
- (BOOL)saveRLMObject;

/** 通过主键获取单个缓存对象(主键唯一) */
+ (id)objWithPrimaryKeyValue:(id)primaryKeyValue;

/** 副键查询 */
+ (NSArray <RLMObject *>*)objWithViceKeyValue:(id)viceKeyValue;
+ (NSArray <RLMObject *>*)objWithViceKey:(id)viceKey
                            viceKeyValue:(id)viceKeyValue
                                   class:(Class)aClass;

/** 通过主键删除 */
- (BOOL)removeRLMObject;
- (BOOL)removeRLMObjectWithPrimaryKeyValue:(id)primaryKeyValue class:(Class)aClass;

@end
