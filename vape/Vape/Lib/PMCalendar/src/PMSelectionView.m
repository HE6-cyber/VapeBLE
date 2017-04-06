//
//  PMSelectionView.m
//  PMCalendar
//
//  Created by Pavel Mazurin on 7/14/12.
//  Copyright (c) 2012 Pavel Mazurin. All rights reserved.
//

#import "PMSelectionView.h"
#import "PMCalendarConstants.h"
#import "PMTheme.h"

@interface PMSelectionView ()

@property (nonatomic, assign) CGRect initialFrame;

@end

@implementation PMSelectionView

@synthesize startIndex = _startIndex;
@synthesize endIndex = _endIndex;
@synthesize initialFrame = _initialFrame;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)redrawComponent
{
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) 
    {
        return nil;
    }    
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redrawComponent)
                                                 name:kPMCalendarRedrawNotification
                                               object:nil];
    self.backgroundColor = [UIColor clearColor];
    self.initialFrame = frame;
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *eComponents = [gregorian components:NSMonthCalendarUnit|NSYearCalendarUnit
                                                 fromDate:self.currentDate];
    
    NSDateComponents *nowComponents = [gregorian components:NSMonthCalendarUnit|NSYearCalendarUnit
                                                   fromDate:[NSDate date]];
    
    if((_startIndex>=0 || _endIndex>=0) || ([eComponents month]==[nowComponents month] && [eComponents year]==[nowComponents year]))
    {
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGFloat cornerRadius = [[[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeCornerRadiusGenericType
                                                                             subtype:PMThemeBackgroundSubtype
                                                                                type:PMThemeSelectionElementType] floatValue];

        UIEdgeInsets shadowPadding = kPMThemeShadowPadding;
        CGSize innerPadding        = kPMThemeInnerPadding;
        CGFloat headerHeight       = kPMThemeHeaderHeight;
        
        CGFloat width  = _initialFrame.size.width;
        CGFloat height = _initialFrame.size.height;
        CGFloat hDiff = (width + shadowPadding.left + shadowPadding.right - innerPadding.width * 2) / 7;
        CGFloat vDiff = (height - headerHeight - innerPadding.height * 2) / (kPMThemeDayTitlesInHeaderIntOffset + 6);


        NSString *coordinatesRound = [[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeCoordinatesRoundGenericType
                                                                                  subtype:PMThemeBackgroundSubtype
                                                                                     type:PMThemeSelectionElementType];
        
        UIEdgeInsets rectInset = [[[PMThemeEngine sharedInstance] elementOfGenericType:PMThemeEdgeInsetsGenericType
                                                                               subtype:PMThemeBackgroundSubtype
                                                                                  type:PMThemeSelectionElementType] pmThemeGenerateEdgeInsets];
        
        if (coordinatesRound)
        {
            if ([coordinatesRound isEqualToString:@"ceil"])
            {
                hDiff = ceil(hDiff);
                vDiff = ceil(vDiff);
            }
            else if ([coordinatesRound isEqualToString:@"floor"])
            {
                hDiff = floor(hDiff);
                vDiff = floor(vDiff);
            }
        }
        
        //=============================================================================================
        //today的背景
        //=============================================================================================
        if ([eComponents month]==[nowComponents month] && [eComponents year]==[nowComponents year]) {
            
            NSDate *dateOnFirst = [[NSDate date] monthStartDate];
            NSInteger weekdayOfFirst = [dateOnFirst weekday];
            NSInteger todayIndex = [[[NSDate date] dateWithoutTime] daysSinceDate:[[NSDate date] monthStartDate]] + weekdayOfFirst - 1;
            
            NSInteger tempStart = todayIndex;
            NSInteger tempEnd = todayIndex;
            
            NSInteger rowStart = tempStart / 7;
            NSInteger rowEnd = tempEnd / 7;
            NSInteger colStart = tempStart % 7;
            NSInteger colEnd = tempEnd % 7;
            
            for (NSInteger i = rowStart; i <= rowEnd; i++)
            {
                //// selectedRect Drawing
                NSInteger thisRowStartCell = 0;
                NSInteger thisRowEndCell = 6;
                
                if (rowStart == i)
                {
                    thisRowStartCell = colStart;
                }
                
                if (rowEnd == i)
                {
                    thisRowEndCell = colEnd;
                }
                
                //// selectedRect Drawing
                CGRect rect = CGRectMake(innerPadding.width + floor(thisRowStartCell * hDiff)
                                         , innerPadding.height + headerHeight
                                         + floor((i + kPMThemeDayTitlesInHeaderIntOffset) * vDiff)
                                         , floor((thisRowEndCell - thisRowStartCell + 1) * hDiff)
                                         , floor(vDiff));
                rect = UIEdgeInsetsInsetRect(rect, rectInset);
                
                UIBezierPath* selectedRectPath = [UIBezierPath bezierPathWithRoundedRect: rect  cornerRadius: cornerRadius];
                
                [[PMThemeEngine sharedInstance] drawPath:selectedRectPath
                                          forElementType:PMThemeCalendarDigitsTodayElementType
                                                 subType:PMThemeBackgroundSubtype
                                               inContext:context];
            }
            
        }
        
        if (_startIndex>=0 || _endIndex>=0) {
            
            NSInteger tempStart = MAX(MIN(_startIndex, _endIndex), 0);
            NSInteger tempEnd = MAX(_startIndex, _endIndex);
        
            NSInteger rowStart = tempStart / 7;
            NSInteger rowEnd = tempEnd / 7;
            NSInteger colStart = tempStart % 7;
            NSInteger colEnd = tempEnd % 7;
            
            NSDate *dateOnFirst = [[NSDate date] monthStartDate];
            NSInteger weekdayOfFirst = [dateOnFirst weekday];
            NSInteger todayIndex = [[[NSDate date] dateWithoutTime] daysSinceDate:[[NSDate date] monthStartDate]] + weekdayOfFirst - 1;
            
            //选中的日期不是今天
            if (!(todayIndex==tempStart && tempStart==tempEnd && [eComponents month]==[nowComponents month] && [eComponents year]==[nowComponents year])) {
                
                for (NSInteger i = rowStart; i <= rowEnd; i++)
                {
                    
                    //// selectedRect Drawing
                    NSInteger thisRowStartCell = 0;
                    NSInteger thisRowEndCell = 6;
                    
                    if (rowStart == i) 
                    {
                        thisRowStartCell = colStart;
                    }
                    
                    if (rowEnd == i) 
                    {
                        thisRowEndCell = colEnd;
                    }
                    
                    //// selectedRect Drawing
                    CGRect rect = CGRectMake(innerPadding.width + floor(thisRowStartCell * hDiff)
                                             , innerPadding.height + headerHeight
                                                    + floor((i + kPMThemeDayTitlesInHeaderIntOffset) * vDiff)
                                             , floor((thisRowEndCell - thisRowStartCell + 1) * hDiff)
                                             , floor(vDiff));
                    rect = UIEdgeInsetsInsetRect(rect, rectInset);

                    UIBezierPath* selectedRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
                    
                    NSDictionary *themeDictionary = [[PMThemeEngine sharedInstance] themeDictForType:PMThemeSelectionElementType subtype:PMThemeBackgroundSubtype];
                    NSDictionary *stroke = [themeDictionary elementInThemeDictOfGenericType:PMThemeStrokeGenericType];
                    
                    if (stroke)
                    {
                        NSString *strokeColorStr = [stroke elementInThemeDictOfGenericType:PMThemeColorGenericType];
                        UIColor *strokeColor = [PMThemeEngine colorFromString:strokeColorStr];
                        
                        CGContextSaveGState(context);
                        [strokeColor setStroke];
                        selectedRectPath.lineWidth = [[stroke elementInThemeDictOfGenericType:PMThemeSizeWidthGenericType] floatValue];
                        [selectedRectPath stroke];
                        CGContextRestoreGState(context);
                        
                       
                    }
                }
                    
            }
            //选中的日期是今天
            else {
                
                for (NSInteger i = rowStart; i <= rowEnd; i++)
                {
                    
                    //// selectedRect Drawing
                    NSInteger thisRowStartCell = 0;
                    NSInteger thisRowEndCell = 6;
                    
                    if (rowStart == i)
                    {
                        thisRowStartCell = colStart;
                    }
                    
                    if (rowEnd == i)
                    {
                        thisRowEndCell = colEnd;
                    }
                    
                    //// selectedRect Drawing
                    CGRect rect = CGRectMake(innerPadding.width + floor(thisRowStartCell * hDiff)
                                             , innerPadding.height + headerHeight
                                             + floor((i + kPMThemeDayTitlesInHeaderIntOffset) * vDiff)
                                             , floor((thisRowEndCell - thisRowStartCell + 1) * hDiff)
                                             , floor(vDiff));
                    rect = UIEdgeInsetsInsetRect(rect, rectInset);
            
                    UIBezierPath* selectedRectPath = [UIBezierPath bezierPathWithRoundedRect: rect cornerRadius: cornerRadius];
                    NSDictionary *themeDictionary = [[PMThemeEngine sharedInstance] themeDictForType:PMThemeSelectionElementType subtype:PMThemeBackgroundSubtype];
                    id colorObj = [themeDictionary elementInThemeDictOfGenericType:PMThemeColorGenericType];
                    if ([colorObj isKindOfClass:[NSString class]]) // plain color
                    {
                        CGContextSaveGState(context);
                        [[PMThemeEngine colorFromString:colorObj] setFill];
                        [selectedRectPath fill];
                        CGContextRestoreGState(context);
                    }
                    
                }

            }
        }
            
    }
    
}

- (void)setStartIndex:(NSInteger)startIndex
{
    if (_startIndex != startIndex)
    {
        _startIndex = startIndex;
        [self setNeedsDisplay];
    }
}

- (void)setEndIndex:(NSInteger)endIndex
{
    if (_endIndex != endIndex)
    {
        _endIndex = endIndex;
        [self setNeedsDisplay];
    }
}

@end
