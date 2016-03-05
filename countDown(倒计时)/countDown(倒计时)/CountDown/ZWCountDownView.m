//
//  ZWCountDemoView.m
//  countDown(倒计时)
//
//  Created by 张伟 on 16/3/5.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "ZWCountDownView.h"

#define LabelCount 4

@interface ZWCountDownView()
/** 定时器 */
@property (nonatomic,strong)dispatch_source_t timer;
/** 时间数组 */
@property (nonatomic,strong)NSMutableArray *timeLabelArrM;
/** 分离 */
@property (nonatomic,strong)NSMutableArray *separateLableArrM;

/** 天 */
@property (nonatomic,strong)UILabel *dayLabel;
/** 时 */
@property (nonatomic,strong)UILabel *hourLabel;
/** 分 */
@property (nonatomic,strong)UILabel *minuesLabel;
/** 秒 */
@property (nonatomic,strong)UILabel *secondsLabel;
/** 毫秒 */
@property (nonatomic,strong)UILabel *millisecondLabel;

@end

@implementation ZWCountDownView

/** 创建单例 */
+ (instancetype)shareCoundDown
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZWCountDownView alloc] init];
    });
    return instance;
}

/** 类方法创建 */
+ (instancetype)countDown
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupLabel];
        
        
        //        [self addSubview:self.dayLabel];
        [self addSubview:self.hourLabel];
        [self addSubview:self.minuesLabel];
        [self addSubview:self.secondsLabel];
        [self addSubview:self.millisecondLabel];
        for (NSInteger index = 0; index < LabelCount; index ++) {
            UILabel *separateLabel = [[UILabel alloc] init];
            separateLabel.text = @":";
            separateLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:separateLabel];
            [self.separateLableArrM addObject:separateLabel];
        }
    }
    return self;
}
- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    _backgroundImageName = backgroundImageName;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
}

// 拿到传过来的时间
- (void)setTimeStamp:(NSInteger)timeStamp
{
    timeStamp *= 1000;  // 秒 到 毫秒
    _timeStamp = timeStamp;
    __block NSInteger timeSp = _timeStamp;
    if (timeSp != 0) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC);
        
        // 频率,以毫秒
        uint64_t interval = (uint64_t)(0.001 * NSEC_PER_SEC);
        dispatch_source_set_timer(self.timer, start, interval, 0);
        
        //设置回调
        dispatch_source_set_event_handler(self.timer, ^{
            timeSp --;
            [self getDetailTimeWithTimestamp:timeSp];
            if (timeSp == 0) {
                dispatch_cancel(self.timer);
                self.timer = nil;
                self.timeStopBlock();
            }
        });
        //启动定时器
        dispatch_resume(self.timer);
    }
    
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timeStamp
{
    NSInteger ms = timeStamp;
    
    NSInteger ml = 1;
    NSInteger ss = ml * 1000 ;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    //    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger hour = ms / hh;                                                       // 时
    NSInteger minute = (ms - hour * hh) / mi;                                       // 分
    NSInteger second =  (ms - hour * hh - minute * mi) / ss ;                       // 秒
    NSInteger millisecond = (ms - hour * hh - minute * mi - second * ss) / 10;      // 毫秒
    //        NSLog(@"%zd时:%zd分:%zd秒:%zd毫秒",hour,minute,second,millisecond);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.hourLabel.text = [NSString stringWithFormat:@"%02zd",hour];
        self.minuesLabel.text = [NSString stringWithFormat:@"%02zd",minute];
        self.secondsLabel.text = [NSString stringWithFormat:@"%02zd",second];
        self.millisecondLabel.text = [NSString stringWithFormat:@"%02zd",millisecond];
    });
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 获取view的宽高
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height;
    
    // 单个label的宽度
    CGFloat labelW = viewW / LabelCount;
    CGFloat labelH = viewH;
    
    self.hourLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.minuesLabel.frame = CGRectMake(1 * labelW, 0, labelW, labelH);
    self.secondsLabel.frame = CGRectMake(2 * labelW, 0, labelW, labelH);
    self.millisecondLabel.frame = CGRectMake(3 * labelW, 0, labelW, labelH);
    
    
    for (NSInteger index = 0;  index < LabelCount - 1; index ++) {
        UILabel *separateLabel  =self.separateLableArrM[index];
        separateLabel.frame = CGRectMake((labelW - 1) * (index + 1), 0, 5, labelH);
    }
}

- (void)setupLabel
{
    // 初始化数组
    _timeLabelArrM = [NSMutableArray array];
    _separateLableArrM = [NSMutableArray array];
    
    // 初始化label
    // 时
    _hourLabel  = [[UILabel alloc] init];
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    
    // 分
    _minuesLabel  = [[UILabel alloc] init];
    _minuesLabel.textAlignment = NSTextAlignmentCenter;
    
    // 秒
    _secondsLabel  = [[UILabel alloc] init];
    _secondsLabel.textAlignment = NSTextAlignmentCenter;
    
    // 毫秒
    _millisecondLabel  = [[UILabel alloc] init];
    _millisecondLabel.textAlignment = NSTextAlignmentCenter;
}

@end
