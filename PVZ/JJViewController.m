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

@property (nonatomic) NSInteger Dev;
@property (nonatomic) NSInteger stuff;

@end

@implementation JJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.Dev = 1;
    
    SKView *spriteView = (SKView *) self.view;
    if (self.Dev == 1)
    {
        NSLog(@"Dev Enabled");

        if (self.stuff == 1)
        {
            NSLog(@"Enabling DrawCount");
            spriteView.showsDrawCount = YES;
        }
        NSLog(@"Enabling FPSCount");
        spriteView.showsFPS = YES;
        
        NSLog(@"Enabling NodeCount");
        spriteView.showsNodeCount = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    SKView *spriteView = (SKView*)self.view;
    CGSize aSize = CGSizeMake(568, 320);    //spriteView.frame.size;
    
    if (self.Dev == 0)
    {
        TitleScene *title = [[TitleScene alloc] initWithSize:aSize];
        title.slider = self.slider;
        [spriteView presentScene:title];
    }
        
    else
    {
        NSLog(@"Skipping to GameScene");
        GameScene *game = [[GameScene alloc] initWithSize:aSize];
        game.slider = self.slider;
        [spriteView presentScene:game];
    }
    
}

@end
