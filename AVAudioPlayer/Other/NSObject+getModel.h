//
//  NSObject+getModel.h
//  字典转模型--runtime
//
//  Created by cuipengfei on 16/7/25.
//  Copyright © 2016年 崔鹏飞. All rights reserved.
//
// runtime:遍历模型中所有成员属性,去字典中查找

#import <Foundation/Foundation.h>

@interface NSObject (getModel)

+ (instancetype)getModelFromDict:(NSDictionary *)dict;

@end
