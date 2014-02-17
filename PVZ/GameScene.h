//
//  GameScene.h
//  PVZ
//
//  Created by jackson on 1/9/14.
//  Copyright (c) 2014 jackson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) CGFloat zombieSpeed;
@property (strong, nonatomic)   IBOutlet    UISlider    *slider;

@end
