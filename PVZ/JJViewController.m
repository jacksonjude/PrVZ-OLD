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
@property (nonatomic) SKView *spriteView;

@end

@implementation JJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(130, 235, 0, 0)];
    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySwitch];
    
    self.Dev = 1;
    
    self.spriteView = (SKView *) self.view;
    if (self.Dev == 1)
    {
        NSLog(@"Dev Enabled");

        if (self.stuff == 1)
        {
            NSLog(@"Enabling DrawCount");
            self.spriteView.showsDrawCount = YES;
        }
        NSLog(@"Enabling FPSCount");
        self.spriteView.showsFPS = YES;
        
        NSLog(@"Enabling NodeCount");
        self.spriteView.showsNodeCount = YES;
    }
}

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        // Execute any code when the switch is ON
        
        NSLog(@"Dev Switch is ON");
    } else{
        // Execute any code when the switch is OFF
        NSLog(@"Dev Switch is OFF");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    SKView *spriteView = (SKView*)self.view;
    CGSize aSize = CGSizeMake(568, 320);    //spriteView.frame.size;
    
    if (self.Dev == 0)
    {
        TitleScene *title = [[TitleScene alloc] initWithSize:aSize];
        [spriteView presentScene:title];
    }
        
    else
    {
        NSLog(@"Skipping to GameScene");
        GameScene *game = [[GameScene alloc] initWithSize:aSize];
        [spriteView presentScene:game];
    }
    
}

@end
