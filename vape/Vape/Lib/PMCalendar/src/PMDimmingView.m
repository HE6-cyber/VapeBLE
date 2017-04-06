//
//  PMDimmingView.m
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/18/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMDimmingView.h"
#import "PMCalendarConstants.h"
#import "PMCalendarController.h"
#import "PMCalendarHelpers.h"

@implementation PMDimmingView

@synthesize controller = _controller;

- (id)initWithFrame:(CGRect)frame controller:(PMCalendarController*)controller
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }
    
    self.controller = controller;
    self.backgroundColor = [UIColor clearColor];//UIColorMakeRGBA(0, 0, 0, 0.3);
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTapEventWithRecognizer:)];
//    tapGestureRecognizer.numberOfTapsRequired = 1;
//    tapGestureRecognizer.numberOfTouchesRequired = 1;
//    [self addGestureRecognizer:tapGestureRecognizer];
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.controller.delegate respondsToSelector:@selector(calendarControllerShouldDismissCalendar:)]
        || [self.controller.delegate calendarControllerShouldDismissCalendar:self.controller])
    {
        [self.controller dismissCalendarAnimated:YES];
    }
    
}

//=======================================================================================================================
#pragma mark - 添加手势与处理手势
//=======================================================================================================================
///处理左右轻扫手势
-(void)handlerTapEventWithRecognizer:(UITapGestureRecognizer*)gesture {
    
    if (![self.controller.delegate respondsToSelector:@selector(calendarControllerShouldDismissCalendar:)]
        || [self.controller.delegate calendarControllerShouldDismissCalendar:self.controller])
    {
        [self.controller dismissCalendarAnimated:YES];
    }
}


@end
