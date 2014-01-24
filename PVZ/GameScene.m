//
//  GameScene.m
//  PVZ
//
//  Created by jackson on 1/9/14.
//  Copyright (c) 2014 jackson. All rights reserved.
//

#import "GameScene.h"
#import "JCJoystick.h"
#import "JCButton.h"

@interface GameScene ()
@property BOOL contentCreated;
@property (strong, nonatomic) JCJoystick *joystick;
@property (strong, nonatomic) JCButton *normalButton;
@property (strong, nonatomic) SKLabelNode *myLabel;
@property (strong, nonatomic) SKSpriteNode *princess;
@property (strong, nonatomic) SKSpriteNode *brush;
@property (strong, nonatomic) SKShapeNode *textBox;
@end

@implementation GameScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.princess.position = CGPointMake(50, 125);
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.joystick = [[JCJoystick alloc] initWithControlRadius:25 baseRadius:45 baseColor:[SKColor blueColor] joystickRadius:25 joystickColor:[SKColor redColor]];
        [self.joystick setPosition:CGPointMake(70,70)];
        [self addChild:self.joystick];
        
        self.normalButton = [[JCButton alloc] initWithButtonRadius:25 color:[SKColor greenColor] pressedColor:[SKColor blackColor] isTurbo:NO];
        [self.normalButton setPosition:CGPointMake(size.width - 40,95)];
        [self addChild:self.normalButton];
        
        self.princess = [SKSpriteNode spriteNodeWithImageNamed:@"princess.png"];
        SKAction *zoom = [SKAction scaleTo:0.5 duration:0];
        [self.princess runAction:zoom];
        [self addChild:self.princess];
        
        self.textBox = [SKShapeNode node];
        CGMutablePathRef  rectPath = CGPathCreateMutable();
        CGPathAddRect(rectPath, nil, CGRectMake(0, 0, 10, 10));
        self.textBox.path = rectPath;
        CGPathRelease(rectPath);
        self.textBox.fillColor =  [SKColor grayColor];
        self.textBox.lineWidth = 0;
        [self.textBox setPosition:CGPointMake(0, 0)];
        [self addChild:self.textBox];
    }
    return self;
}

- (void)checkButtons
{
    if (self.normalButton.isOn)
    {
        [self addBrushIn:CGPointMake(0,self.size.height-40)];
    }
}

- (void)addSquareIn:(CGPoint)position
          withColor:(SKColor *)color
{
    SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(15,10)];
    [square setPosition:position];
    SKAction *move = [SKAction moveTo:CGPointMake(self.size.width+square.size.width/2,position.y) duration:1];
    SKAction *destroy = [SKAction removeFromParent];
    [self addChild:square];
    [square runAction:[SKAction sequence:@[move,destroy]]];
}

- (void)addBrushIn:(CGPoint)position
{
    if (self.brush == nil)
    {
        self.brush = [SKSpriteNode spriteNodeWithImageNamed:@"brush.png"];
        [self.brush setPosition:position];
        [self addChild:self.brush];
        
        SKAction *posy = [SKAction moveToY:self.princess.position.y duration:0];
        SKAction *move = [SKAction moveTo:CGPointMake(self.size.width+self.brush.size.width/2,self.princess.position.y) duration:1];
        SKAction *destroy = [SKAction removeFromParent];
        SKAction *clearBrush = [SKAction runBlock:^
                                {
                                    self.brush = nil;
                                }];
        [self.brush runAction:[SKAction sequence:@[posy, move, clearBrush, destroy]]];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    [self.princess setPosition:CGPointMake(self.princess.position.x, self.princess.position.y+self.joystick.y*2)];
    [self checkButtons];
}

@end