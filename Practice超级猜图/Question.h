//
//  Question.h
//  Practice超级猜图
//
//  Created by 王为 on 17/2/27.
//  Copyright © 2017年 王为. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic,strong)NSString *answer;
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSArray *options;

-(instancetype)initWithDict:(NSDictionary *) dict;
+(instancetype)questionWithDict:(NSDictionary *) dict;

@end
