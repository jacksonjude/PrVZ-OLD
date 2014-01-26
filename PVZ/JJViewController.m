//
//  JJViewController.m
//  PVZ
//
//  Created by jackson on 1/7/14.
//  Copyright (c) 2014 jackson. All rights reserved.
//

#import "JJViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "TitleScene.h"
#import "GameScene.h"

@interface JJViewController ()

@end

@implementation JJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView *spriteView = (SKView *) self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;    
}


- (void)viewWillAppear:(BOOL)animated
{
    SKView *spriteView = (SKView*)self.view;
    CGSize aSize = CGSizeMake(568, 320);    //spriteView.frame.size;
    
#if 0
    TitleScene *title = [[TitleScene alloc] initWithSize:aSize];
    [spriteView presentScene:title];
#else
    GameScene *game = [[GameScene alloc] initWithSize:aSize];
    [spriteView presentScene:game];
#endif
}

@end
