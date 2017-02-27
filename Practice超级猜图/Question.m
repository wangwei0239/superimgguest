
//
//  Question.m
//  Practice超级猜图
//
//  Created by 王为 on 17/2/27.
//  Copyright © 2017年 王为. All rights reserved.
//

#import "Question.h"

@implementation Question

-(instancetype)initWithDict:(NSDictionary *) dict{
    
    if(self = [super init]){
        self.answer = dict[@"answer"];
        self.icon = dict[@"icon"];
        self.title = dict[@"title"];
        self.options = dict[@"options"];
    }
    
    return self;
}


+(instancetype)questionWithDict:(NSDictionary *) dict{
    return [[self alloc]initWithDict:dict];
}

@end
