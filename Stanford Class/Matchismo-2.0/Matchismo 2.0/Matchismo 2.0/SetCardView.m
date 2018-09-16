//
//  SetCardView.m
//  SuperCard
//
//  Created by James Small on 8/12/13.
//  Copyright (c) 2013 James Small. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#define CORNER_RADIUS 12.0
#define LINE_WIDTH 2.0

- (void)drawRect:(CGRect)rect
{
    // Drawing Code
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    // sets white background but doesn't put white in rounded cut off corners part
    [roundedRect addClip];
    
    if (self.faceUp)
        [[UIColor grayColor] setFill];
    else
        [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawSymbols];
  
}

- (void)drawSymbols
{
    UIColor *color;
    
    if ([self.color isEqualToString:@"1"])
    {
        color = [UIColor greenColor];
    } else if ([self.color isEqualToString:@"2"])
    {
            color = [UIColor redColor];
    } else if ([self.color isEqualToString:@"3"])
    {
        color = [UIColor purpleColor];
    } else{
        color = [UIColor blackColor];
    }
    
    NSString *shading;
    
    if ([self.shading isEqualToString:@"1"])
    {
        shading = @"none";
    } else if ([self.shading isEqualToString:@"2"])
    {
        shading = @"stripped";
    } else if ([self.shading isEqualToString:@"3"])
    {
        shading = @"full";
    } else
    {
        //problem if here
    
    }
    
    CGPoint oneCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGPoint twoCenterTop = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 3);
    CGPoint twoCenterBottom = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 3 * 2);
    CGPoint threeCenterTop = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 4);
    CGPoint threeCenterMiddle = oneCenter;
    CGPoint threeCenterBottom = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 4 * 3);
    
    // loop to check symbol and draw symbol with color
    
    if ([self.symbol isEqualToString:@"1"])
    {
        // draw diamonds
        
        if ([self.number isEqualToNumber:@(1)])
        {
            //draw 1
            [self drawDiamondAtCenterPoint:oneCenter withColor:color andShading:shading];
            
        } else if ([self.number isEqualToNumber:@(2)])
        {
            //draw 2
            [self drawDiamondAtCenterPoint:twoCenterTop withColor:color andShading:shading];
            [self drawDiamondAtCenterPoint:twoCenterBottom withColor:color andShading:shading];
        }
        else if ([self.number isEqualToNumber:@(3)])
        {
            //draw 3
            [self drawDiamondAtCenterPoint:threeCenterTop withColor:color andShading:shading];
            [self drawDiamondAtCenterPoint:threeCenterMiddle withColor:color andShading:shading];
            [self drawDiamondAtCenterPoint:threeCenterBottom withColor:color andShading:shading];
            
        } else{
            //problem with count
            
        }
        
    } else if ([self.symbol isEqualToString:@"2"])
    {
        // draw squiggles

        if ([self.number isEqualToNumber:@(1)])
        {
            //draw 1
            [self drawSquiggleAtCenterPoint:oneCenter withColor:color andShading:shading];
            
        } else if ([self.number isEqualToNumber:@(2)])
        {
            //draw 2
            [self drawSquiggleAtCenterPoint:twoCenterTop withColor:color andShading:shading];
            [self drawSquiggleAtCenterPoint:twoCenterBottom withColor:color andShading:shading];
            
        }
        else if ([self.number isEqualToNumber:@(3)])
        {
            //draw 3
            [self drawSquiggleAtCenterPoint:threeCenterTop withColor:color andShading:shading];
            [self drawSquiggleAtCenterPoint:threeCenterMiddle withColor:color andShading:shading];
            [self drawSquiggleAtCenterPoint:threeCenterBottom withColor:color andShading:shading];
            
        } else{
            //problem with count
  
        }
        
    } else if ([self.symbol isEqualToString:@"3"])
    {
        //draw ovals
       
        if ([self.number isEqualToNumber:@(1)])
        {
            //draw 1
            [self drawOvalAtCenterPoint:oneCenter withColor:color andShading:shading];
            
        } else if ([self.number isEqualToNumber:@(2)])
        {
            //draw 2
            [self drawOvalAtCenterPoint:twoCenterTop withColor:color andShading:shading];
            [self drawOvalAtCenterPoint:twoCenterBottom withColor:color andShading:shading];
            
        }
        else if ([self.number isEqualToNumber:@(3)])
        {
            //draw 3
            [self drawOvalAtCenterPoint:threeCenterTop withColor:color andShading:shading];
            [self drawOvalAtCenterPoint:threeCenterMiddle withColor:color andShading:shading];
            [self drawOvalAtCenterPoint:threeCenterBottom withColor:color andShading:shading];
            
        } else{
            //problem with count
    
        }
   
    } else{
        //porblem if here
      
        
    }    
}

#define DIAMOND_X_OFFSET 0.25
#define DIAMOND_Y_OFFSET 0.08

- (void)drawDiamondAtCenterPoint:(CGPoint)center
                   withColor:(UIColor *)color
                   andShading:(NSString *)shade
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(center.x - DIAMOND_X_OFFSET * self.bounds.size.width, center.y)];
    [path addLineToPoint:CGPointMake(center.x, center.y + DIAMOND_Y_OFFSET * self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(center.x + DIAMOND_X_OFFSET * self.bounds.size.width, center.y)];
    [path addLineToPoint:CGPointMake(center.x, center.y - DIAMOND_Y_OFFSET * self.bounds.size.height)];
    [path closePath]; 
    [color setStroke];
    [path setLineWidth:LINE_WIDTH];
    [path stroke];
    
    if ([shade isEqualToString:@"full"])
    {
        [color setFill];
        [path fill];
    } else if ([shade isEqualToString:@"stripped"])
    {
        [path setLineWidth:3.0];
        [self pushContextAndDrawStripesWithColor:color andCenterPoint:center withPath:path];
        [self popContext];
    }
}

#define SQUIGGLE_X_OFFSET 0.3
#define SQUIGGLE_Y_OFFSET 0.1
#define POINT_X_OFFSET 0.4
#define POINT_Y_OFFSET 0.1

- (void)drawSquiggleAtCenterPoint:(CGPoint)center
                       withColor:(UIColor *)color
                      andShading:(NSString *)shade
{
    
    CGPoint point1 = CGPointMake(center.x - self.bounds.size.width * SQUIGGLE_X_OFFSET, center.y);
    CGPoint point2 = CGPointMake(center.x + self.bounds.size.width * SQUIGGLE_X_OFFSET, center.y - self.bounds.size.height * SQUIGGLE_Y_OFFSET);
    CGPoint point3 = CGPointMake(center.x + self.bounds.size.width * SQUIGGLE_X_OFFSET, center.y + self.bounds.size.height * SQUIGGLE_Y_OFFSET);
    CGPoint point4 = CGPointMake(center.x - self.bounds.size.width * SQUIGGLE_X_OFFSET, center.y + self.bounds.size.height * SQUIGGLE_Y_OFFSET);
 
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:point4];
    [path addQuadCurveToPoint:point1 controlPoint:CGPointMake(center.x - self.bounds.size.width * POINT_X_OFFSET, center.y - self.bounds.size.height * POINT_Y_OFFSET)];
    [path addCurveToPoint:point2
            controlPoint1:CGPointMake(center.x + self.bounds.size.width * POINT_X_OFFSET, center.y - self.bounds.size.height * POINT_Y_OFFSET)
            controlPoint2:CGPointMake(center.x + self.bounds.size.width * POINT_X_OFFSET, center.y + self.bounds.size.height * POINT_Y_OFFSET)];
    [path addQuadCurveToPoint:point3 controlPoint:CGPointMake(center.x + self.bounds.size.width * POINT_X_OFFSET, center.y - self.bounds.size.height * POINT_Y_OFFSET)];
    [path addCurveToPoint:point4
            controlPoint1:CGPointMake(center.x + self.bounds.size.width * POINT_X_OFFSET, center.y + self.bounds.size.height * POINT_Y_OFFSET)
            controlPoint2:CGPointMake(center.x + self.bounds.size.width * POINT_X_OFFSET, center.y + self.bounds.size.height * POINT_Y_OFFSET)];

    [path setLineWidth:LINE_WIDTH];
    
    
    [color setStroke];
    
    [path stroke];
    
    if ([shade isEqualToString:@"full"])
    {
        [color setFill];
        [path fill];
    } else if ([shade isEqualToString:@"stripped"])
    {
        [path setLineWidth:3.0];
        [self pushContextAndDrawStripesWithColor:color andCenterPoint:center withPath:path];
        [self popContext];
    }
    
}

#define OVAL_X_OFFSET 0.5
#define OVAL_Y_OFFSET 0.15
#define OVAL_CORNER_RADIUS 20.0


- (void)drawOvalAtCenterPoint:(CGPoint)center
                       withColor:(UIColor *)color
                      andShading:(NSString *)shade
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center.x - self.bounds.size.width  / 2 * OVAL_X_OFFSET, center.y - self.bounds.size.height / 2 * OVAL_Y_OFFSET, self.bounds.size.width * OVAL_X_OFFSET, self.bounds.size.height * OVAL_Y_OFFSET) cornerRadius:OVAL_CORNER_RADIUS];
    
    [roundedRect setLineWidth:LINE_WIDTH];
    [color setStroke];
    [roundedRect stroke];
    
    if ([shade isEqualToString:@"full"])
    {
        [color setFill];
        [roundedRect fill];
    } else if ([shade isEqualToString:@"stripped"])
    {
        [roundedRect setLineWidth:2.0];
        [self pushContextAndDrawStripesWithColor:color andCenterPoint:center withPath:roundedRect];
        [self popContext];
    }
    
}

- (void) pushContextAndDrawStripesWithColor:(UIColor *)color andCenterPoint:(CGPoint)center withPath:(UIBezierPath *)path
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    
    CGPoint startingPoint = CGPointMake(center.x - 50, center.y - 30);
    
    [path addClip];
    
    
    
    for (int i = 0;i < 112;i += 4)
    {
        [path moveToPoint:CGPointMake(startingPoint.x + i, startingPoint.y)];
        [path addLineToPoint:CGPointMake(startingPoint.x + i, startingPoint.y + 60.0)];
   
    }
    
    [path setLineWidth:2.0];
    [color setStroke];
    [path stroke];
}

- (void) popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void) setNumber:(NSNumber *)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void) setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void) setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void) setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void) setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark 9 Initialization

- (void) setup
{
    
}

- (void) awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}



@end

