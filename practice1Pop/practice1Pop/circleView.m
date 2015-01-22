//
//  circleView.m
//  practice1Pop
//
//  Created by indianic on 22/01/15.
//  Copyright (c) 2015 indianic. All rights reserved.
//

#import "circleView.h"

@implementation circleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.borderColor = [[UIColor blackColor]CGColor];
    self.layer.borderWidth = 2;
}

@end
