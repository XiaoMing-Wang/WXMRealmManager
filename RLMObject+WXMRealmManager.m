//
//  RLMObject+WXMRealmManager.m
//  ModuleDebugging
//
//  Created by edz on 2019/5/11.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "RLMObject+WXMRealmManager.h"
#import "WXMRealmManager.h"

@implementation RLMObject (WXMRealmManager)
/**  */
- (BOOL)saveRLMObject {
    return [[WXMRealmManager sharedInstance] saveRLMObjectWithObj:self];
}
/**  */
+ (id)objWithPrimaryKeyValue:(id)primaryKeyValue {
    return [[WXMRealmManager sharedInstance] objWithPrimaryKeyValue:primaryKeyValue class:self.class];
}

/**  */
+ (NSArray <RLMObject *>*)objWithViceKeyValue:(id)viceKeyValue {
    return [[WXMRealmManager sharedInstance] objWithViceKeyValue:viceKeyValue class:self.class];
}
+ (NSArray <RLMObject *>*)objWithViceKey:(id)viceKey
                            viceKeyValue:(id)viceKeyValue
                                   class:(Class)aClass {
    return [[WXMRealmManager sharedInstance] objWithViceKey:viceKey
                                               viceKeyValue:viceKeyValue
                                                      class:self.class];
}
/**  */
- (BOOL)removeRLMObject {
    return [[WXMRealmManager sharedInstance] removeRLMObjectWithObj:self];
}
- (BOOL)removeRLMObjectWithPrimaryKeyValue:(id)primaryKeyValue class:(Class)aClass {
    return [[WXMRealmManager sharedInstance] removeRLMObjectWithPrimaryKeyValue:primaryKeyValue
                                                                          class:self.class];
}
@end
