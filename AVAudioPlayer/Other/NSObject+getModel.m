//
//  NSObject+getModel.m
//  字典转模型--runtime
//
//  Created by cuipengfei on 16/7/25.
//  Copyright © 2016年 崔鹏飞. All rights reserved.
//

#import "NSObject+getModel.h"
#import <objc/message.h>

@implementation NSObject (getModel)

+ (instancetype)getModelFromDict:(NSDictionary *)dict{
    
    // 创建对应类的对象
    id objc = [[self alloc] init];
    
    // 遍历模型所有成员属性
    // Ivar *:指向Ivar类型的成员变量数组指针
    // count:成员属性总数
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0 ; i < count; i++) {
        // 获取成员属性
        Ivar ivar = ivarList[i];
        
        // 获取成员名
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        ;
        // 成员属性类型
        NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        // 获取key
        NSString *key = [propertyName substringFromIndex:1];
        
        // 获取字典的value
        id value = dict[key];
        
        // 二级转换
        // 值是字典,成员属性的类型不是字典,才需要转换成模型
        if ([value isKindOfClass:[NSDictionary class]] && ![propertyType containsString:@"NS"]) {
            
            // 字符串截取
            NSRange range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringFromIndex:range.location + range.length];
            range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringToIndex:range.location];
            
            // 获取需要转换类的类对象
            Class modelClass =  NSClassFromString(propertyType);
            
            if (modelClass) {
                value =  [modelClass getModelFromDict:value];
            }
        }
        
        if (value) {    // KVC赋值:不能传空
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}

@end
