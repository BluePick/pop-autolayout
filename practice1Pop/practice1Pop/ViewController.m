//
//  ViewController.m
//  practice1Pop
//
//  Created by indianic on 22/01/15.
//  Copyright (c) 2015 indianic. All rights reserved.
//

#import "ViewController.h"
#import <pop/POP.h>


@interface ViewController ()

@end

@implementation ViewController{
    BOOL isCollapse;
    BOOL isAnimating;
}

#pragma mark - UIVIEW LIFE CYCLE -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isCollapse = YES;
    centerView.center = self.view.center;
    [self applyAlpha:YES];
    [self addTapGesture];
    [self addDragView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - ADD GESTURE METHODS -

-(void)addTapGesture{
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [centerView addGestureRecognizer:tapEvent];
    tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [brc1View1 addGestureRecognizer:tapEvent];
    tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [brc1View2 addGestureRecognizer:tapEvent];
    tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [brc1View3 addGestureRecognizer:tapEvent];
    tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [brc1View4 addGestureRecognizer:tapEvent];
    tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [brc1View5 addGestureRecognizer:tapEvent];
    tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [brc1View6 addGestureRecognizer:tapEvent];
    tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [brc1View7 addGestureRecognizer:tapEvent];
    tapEvent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapFrom:)];
    [brc1View8 addGestureRecognizer:tapEvent];
}

- (void)addDragView
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [centerView addGestureRecognizer:recognizer];
}


#pragma mark - HANDLE TAP GESTURE METHODS -

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    
    if (isAnimating) return;
    
    UIView *viewTap = (UIView *)recognizer.view;
    centerView.userInteractionEnabled = NO;
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(2, 2)];
    [scaleAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        centerView.userInteractionEnabled = YES;
    }];
    [viewTap.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    if (viewTap == centerView) {
        if (isCollapse)
            [self closeMenu];
        else
            [self resetMenu];
        isCollapse = !isCollapse;
        [self applyAlpha:isCollapse];
    }
}



#pragma mark - HANDLE PAN GESTURE METHODS -

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        isAnimating = YES;
        centerView.layer.borderWidth = 3;
        if (isCollapse){
            [self closeMenu];
            isCollapse = !isCollapse;
        }
        [self applyAlpha:NO];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        isAnimating = YES;
        centerView.layer.borderWidth = 3;
        CGPoint velocity = [recognizer velocityInView:self.view];
        POPDecayAnimation *positionAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.delegate = self;
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            isAnimating = !finished;
            centerView.layer.borderWidth = finished?0:3;
        }];
        [recognizer.view.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}


#pragma mark - POP ANIMATION DELEGATE METHOD -

- (void)pop_animationDidApply:(POPDecayAnimation *)anim
{
    // CHECK IF CENTER VIEW TOUCH VIEW BOUND
    BOOL isDragViewOutsideOfSuperView = !CGRectContainsRect(self.view.frame, centerView.frame);
    if (isDragViewOutsideOfSuperView) {
        isAnimating = YES;
        centerView.layer.borderWidth = 3;
        CGPoint currentVelocity = [anim.velocity CGPointValue];
        CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        positionAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
        [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            isAnimating = !finished;
            centerView.layer.borderWidth = finished?0:3;
        }];
        [centerView.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
}


#pragma mark - VOID METHODS -

-(void)closeMenu{
    
    //POSITION MOVE ANIMATION
    
    //BRANCH 1
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 18;
    positionAnimation.dynamicsFriction = 100;
    positionAnimation.toValue = [NSValue valueWithCGPoint:centerView.center];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:brc1View1.center];
    [brc1View1 pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    //BRANCH 2
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 18;
    positionAnimation.dynamicsFriction = 100.0f;
    positionAnimation.toValue = [NSValue valueWithCGPoint:centerView.center];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:brc1View2.center];
    [brc1View2 pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    //BRANCH 3
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 18;
    positionAnimation.dynamicsFriction = 100.0f;
    positionAnimation.toValue = [NSValue valueWithCGPoint:centerView.center];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:brc1View3.center];
    [brc1View3 pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    //BRANCH 4
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 18;
    positionAnimation.dynamicsFriction = 100.0f;
    positionAnimation.toValue = [NSValue valueWithCGPoint:centerView.center];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:brc1View4.center];
    [brc1View4 pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    //BRANCH 5
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 18;
    positionAnimation.dynamicsFriction = 100.0f;
    positionAnimation.toValue = [NSValue valueWithCGPoint:centerView.center];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:brc1View5.center];
    [brc1View5 pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    //BRANCH 6
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 18;
    positionAnimation.dynamicsFriction = 100.0f;
    positionAnimation.toValue = [NSValue valueWithCGPoint:centerView.center];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:brc1View6.center];
    [brc1View6 pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    //BRANCH 7
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 18;
    positionAnimation.dynamicsFriction = 100.0f;
    positionAnimation.toValue = [NSValue valueWithCGPoint:centerView.center];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:brc1View7.center];
    [brc1View7 pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    //BRANCH 8
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.springBounciness = 18;
    positionAnimation.dynamicsFriction = 100.0f;
    positionAnimation.toValue = [NSValue valueWithCGPoint:centerView.center];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:brc1View8.center];
    [brc1View8 pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
}

-(void)applyAlpha:(BOOL)IsFullAlpha{
    // APPLY ALPHA
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = IsFullAlpha?@(1.0):@(0.0);
    [brc1View1.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [brc1View2.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [brc1View3.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [brc1View4.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [brc1View5.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [brc1View6.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [brc1View7.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [brc1View8.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

-(void)resetMenu{
    // RESET LAYOUT CONSTRAINTS
    [UIView animateWithDuration:1.0f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        centerView.center = self.view.center;
        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
    } completion:NULL];
}


@end
