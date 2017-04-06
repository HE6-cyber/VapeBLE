//
//  ProgressView.m
//  CircleAnimationTest
//
//  Created by ly on 15/11/6.
//  Copyright (c) 2015年 zmit. All rights reserved.
//

#import "ProgressView.h"
#import "Masonry.h"

#define kCColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0  blue:b/255.0  alpha:1]


@interface ProgressView() {
    UILabel *todaySmokePlanLabel;
    UILabel *todaySmokeCountLabel;
    UILabel *todaySmokeLabel;
    NSMutableString * str;
    NSString *resultStr;
}


//创建全局属性
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer2;
@property (nonatomic, strong) CAShapeLayer *cycleLayer;
@property (nonatomic, strong) UIImageView  *roundView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) float currentValue;
@property (nonatomic, assign) int increase;


@end

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

- (void)setPercent:(float)haveFinished{
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [self initData];
}

//在对图形进行初始化的时候，在这边对view进行初始化，像是线宽的以及颜色的属性都可以在这边进行赋值
- (void)initData {
    self.haveFinished =  [self.inFactcount floatValue]/[self.planCount floatValue];
    
    resultStr =[NSString stringWithFormat:@"%0.2f",self.haveFinished];
    
    self.rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.lineWidth = 10.0f;
    _increase = 0;
    [self circleAnimationTypeOne];
    [self addLabel];
    if (_haveFinished >0) {
        //动画没动一次的平均单位是0。008，所以动画的总时间长度就是0.008*总次数
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.0235
                                                  target:self
                                                selector:@selector(numShow)
                                                userInfo:nil
                                                 repeats:YES];
        
        [self animation];
    }
}


- (void)circleAnimationTypeOne {
    
    //创建出CAShapeLayer 这个layer是画出了一整个圈圈的layer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.rect;
    //设置填充颜色
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = self.lineWidth;
    self.shapeLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    
    
    //创建出圆形贝塞尔曲线,设置所画圆形经过路径 在iOS系统中pi从水平的左边开始对面为2pi
    UIBezierPath* circlePath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rect.size.width / 2, self.rect.size.height / 2 )radius:self.rect.size.height / 2-5 startAngle:0 endAngle:M_PI*2  clockwise:YES];
    
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = circlePath.CGPath;
    
    //添加并显示
    [self.layer addSublayer:self.shapeLayer];
    
    
    
    
    //在这里我要用三角函数来计算白点的目标位置
    for (int i = 0; i<10; i++) {
        double radian = M_PI/5 * i;
        
        int index;
        
        float x;
        float y;
        float radius = self.frame.size.height/2-5;
        
        if (radian < M_PI/2) {
            index = 1;
        } else if (radian < M_PI && radian > M_PI_2) {
            index = 2;
        } else if (radian < M_PI_2*3 && radian > M_PI) {
            index = 3;
        } else if (radian < M_PI*2 && radian > M_PI_2*3) {
            index = 4;
        }
        
        switch (index) {
            case 1:
                //在这里处理第一象限的坐标 0 ~ pi/2
                x = radius + sinf(radian)*radius;
                y = radius + cosf(radian)*radius;
                break;
            case 2:
                //在这里处理第二象限的坐标 pi/2 ~ pi
                x = radius - sinf(radian)*radius;
                y = radius + cosf(radian)*radius;
                break;
            case 3:
                //在这里处理第三象限的坐标 pi ~ 3pi/2
                x = radius - sinf(radian)*radius;
                y = radius + cosf(radian)*radius;
                break;
            case 4:
                //在这里处理第四象限的坐标 2pi/2 ~ 2pi
                x = radius + sinf(radian)*radius;
                y = radius + cosf(radian)*radius;
                break;
            default:
                break;
        }
        
        UIImageView *whiteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 10, 10)];
        [whiteImageView setImage:[UIImage imageNamed:@"whiteDot"]];
        
        [self addSubview:whiteImageView];
    }
    
    //这里是贝塞尔曲线所画圆形的路径
    UIBezierPath* circlePath2=[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.rect.size.width / 2, self.rect.size.height / 2 ) radius:self.rect.size.height / 2-5 startAngle:M_PI_2*3 endAngle:2*M_PI*_haveFinished+M_PI_2*3 clockwise:YES];
    
    
    //线条拐角
    [circlePath2 setLineCapStyle:kCGLineCapRound];
    //终点处理
    [circlePath2 setLineJoinStyle:kCGLineJoinRound];
    
    
    
    
    //创建出CAShapeLayer shapelayer2的定义就是含有动画特效的线
    self.shapeLayer2 = [CAShapeLayer layer];
    self.shapeLayer2.frame = self.rect;
    
    self.shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    
    //设置线条的宽度和颜色
    self.shapeLayer2.lineWidth = self.lineWidth;
    self.shapeLayer2.strokeColor = [UIColor whiteColor].CGColor;
    
    
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer2.path = circlePath2.CGPath;
    
    //添加并显示
    [self.layer addSublayer:self.shapeLayer2];
    
    UIView *startRoundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [startRoundView setBackgroundColor:[UIColor whiteColor]];
    [startRoundView setCenter:CGPointMake(self.rect.size.width / 2, 5)];
    [[startRoundView layer] setCornerRadius:5];
    [[startRoundView layer] setMasksToBounds:YES];
    [self addSubview:startRoundView];
    
    
    UIImageView *bigDotImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [bigDotImageView setImage:[UIImage imageNamed:@"bigDot"]];
    bigDotImageView.center = CGPointMake(self.rect.size.width / 2, 5);
    bigDotImageView.layer.cornerRadius = 10;
    bigDotImageView.layer.masksToBounds = YES;

    _roundView = bigDotImageView;
    [self addSubview:bigDotImageView];
}


- (void)animation {
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 4*self.haveFinished;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1];
    pathAnimation.autoreverses = NO;
    
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = self.shapeLayer2.path;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.calculationMode = kCAAnimationPaced;
    keyAnimation.duration = 4*self.haveFinished;
    keyAnimation.removedOnCompletion = NO;
    [self.shapeLayer2 addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    [_roundView.layer addAnimation:keyAnimation forKey:nil];
}



//这个方法是在往这个view中间添加一些显示用的lable
- (void)addLabel {
    //这事中心的label 表示下现在的吸烟口数
    todaySmokeCountLabel = [[UILabel alloc] init];
    [self addSubview:todaySmokeCountLabel];
    [todaySmokeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    str = [[NSMutableString alloc]init];
    todaySmokeCountLabel.text = @"0";
    todaySmokeCountLabel.textAlignment = NSTextAlignmentCenter;
    todaySmokeCountLabel.font = [UIFont systemFontOfSize:55];
    [todaySmokeCountLabel setTextColor:[UIColor whiteColor]];
    
    
    
    //今日吸烟口数 的一段文字提示
    todaySmokeLabel = [[UILabel alloc] init];
    [self addSubview:todaySmokeLabel];
    [todaySmokeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(todaySmokeCountLabel.mas_centerX);
        make.centerY.equalTo(todaySmokeCountLabel.mas_centerY).offset(-50);
    }];
    
    [todaySmokeLabel setText:@"今日吸烟口数"];
    [todaySmokeLabel setFont:[UIFont systemFontOfSize:14]];
    [todaySmokeLabel setTextAlignment:NSTextAlignmentCenter];
    [todaySmokeLabel setTextColor:[UIColor whiteColor]];
    
    
    //这里则是自己设定的今日计划吸烟口数的label
    todaySmokePlanLabel = [[UILabel alloc] init];
    [self addSubview:todaySmokePlanLabel];
    [todaySmokePlanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(todaySmokeCountLabel.mas_centerX);
        make.centerY.equalTo(todaySmokeCountLabel.mas_centerY).offset(50);
    }];
    str=[[NSMutableString alloc]init];
    todaySmokePlanLabel.text = [NSString stringWithFormat:@"计划:%@",self.planCount];
    todaySmokePlanLabel.textAlignment = NSTextAlignmentCenter;
    todaySmokePlanLabel.font = [UIFont systemFontOfSize:14];
    todaySmokePlanLabel.textColor = [UIColor whiteColor];
    
}


//这是控制view中是数字变化的方法
- (void) numShow {
    if (self.haveFinished < 0) {
        todaySmokeCountLabel.text = @"0";
        [_timer invalidate];
        return;
    }
    if (self.haveFinished <= 0.01) {
         todaySmokeCountLabel.text = @"1";
        [_timer invalidate];
        return;
    }
    
    float count = roundf([self.inFactcount intValue]/(4*self.haveFinished/0.05));
    
    int number = count > 1? count : 1;
    
    _increase += number;
    
    if (_increase >= self.haveFinished * [self.planCount integerValue]) {
        _increase = [self.inFactcount intValue];
        [_timer invalidate];
    }
    
    todaySmokeCountLabel.text = [NSString stringWithFormat:@"%d",_increase];
}

@end




