//
//  ZWCountDemoView.h
//  countDown(倒计时)
//
//  Created by 张伟 on 16/3/5.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimeStopBlock)();

@interface ZWCountDownView : UIView
/** 时间戳 */
@property (nonatomic,assign)NSInteger timeStamp;   // 以秒为单位计算

/** 背景 */
@property(nonatomic,copy)NSString *backgroundImageName;

/** 时间停止后回调 */
@property(nonatomic,copy)TimeStopBlock timeStopBlock;


// 创建单例对象
+ (instancetype)shareCoundDown; // 计时钟是唯一的,就用这个


// 创建非单例对象
+ (instancetype)countDown;  // 计时不是唯一的,不是唯一的就用这个




@end
