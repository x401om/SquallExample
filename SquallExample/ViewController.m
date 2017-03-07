//
//  ViewController.m
//  SquallExample
//
//  Created by Aleksey Goncharov on 25.11.16.
//  Copyright © 2016 Easy Ten. All rights reserved.
//

@import Squall;
@import Keyframes;

#import "EAKeyframeView.h"

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet EAKeyframeView *cloudView;
@property (nonatomic, weak) IBOutlet UIView *animationView;
@property (nonatomic, weak) IBOutlet UIView *fruitAppearingContainer;

@property (nonatomic, weak) SLCoreAnimation *animation;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSURL *file = [[NSBundle mainBundle] URLForResource:@"SLLicense" withExtension:@"txt"];
  NSString *license = [NSString stringWithContentsOfURL:file encoding:NSUTF8StringEncoding error:nil];
  
  [Squall setLicenseKey:license];
  
  self.cloudView.vectorPrefix = @"KFCloud";
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self reloadAnimation:nil];
  
//  KFVectorLayer *fruitAppearingLayer = [self createFruitAppearingLayer];
//  [self.fruitAppearingContainer.layer addSublayer:fruitAppearingLayer];
//  [fruitAppearingLayer startAnimation];
}

- (IBAction)didChangeSegment:(UISegmentedControl *)sender {
  [self.cloudView startVectorAnimationAtIndex:sender.selectedSegmentIndex + 1];
}

- (KFVectorLayer *)createFruitAppearingLayer {
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"KFFruitAppearing" ofType:@"json" inDirectory:nil];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  if (!data) {
    return nil;
  }
  NSDictionary *sampleVectorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  KFVector *sampleVector = KFVectorFromDictionary(sampleVectorDictionary);
  KFVectorLayer *sampleVectorLayer = [KFVectorLayer new];
  sampleVectorLayer.frame = CGRectMake(0, 0, 200, 500);
  sampleVectorLayer.faceModel = sampleVector;
  return sampleVectorLayer;
}

- (KFVectorLayer *)createFruitLayerWithId:(NSString *)fruitId {
  NSString *fruitFileName = [NSString stringWithFormat:@"KFFruit_%@", fruitId];
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fruitFileName ofType:@"json" inDirectory:nil];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  if (!data) {
    return nil;
  }
  NSDictionary *sampleVectorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  KFVector *sampleVector = KFVectorFromDictionary(sampleVectorDictionary);
  KFVectorLayer *sampleVectorLayer = [KFVectorLayer new];
  sampleVectorLayer.frame = CGRectMake(0, 0, 50, 50);
  sampleVectorLayer.faceModel = sampleVector;
  return sampleVectorLayer;
}

- (CALayer *)createRowLayerWithId:(NSString *)fruitId {
  CAShapeLayer *layer = [CAShapeLayer layer];
  layer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 840, 120)].CGPath;
  layer.fillColor = [UIColor colorWithWhite:0.5f alpha:0.0f].CGColor;
  
  CATextLayer *label = [[CATextLayer alloc] init];
  [label setFont:@"DINRoundPro-Bold"];
  [label setFontSize:60];
  [label setFrame:CGRectMake(0, 0, 840, 120)];
  [label setString:fruitId];
  [label setAlignmentMode:kCAAlignmentCenter];
  [label setForegroundColor:[[UIColor whiteColor] CGColor]];
  [layer addSublayer:label];
  
  return layer;
}

- (IBAction)reloadAnimation:(id)sender {
  if (self.animation) {
    [self.animation pause];
    [self.animation removeFromSuperlayer];
  }

  NSError *error;
  
  SLAnimationInformation *animationInformation = [[SLReader new] parseFileFromBundle:@"SkillMachineTest.sqa" error:&error];

//  [animationInformation adaptLayerProperties:^(SLProperty * _Nonnull property, NSString * _Nonnull layerName) {
//    if ([layerName isEqual:@"fruit_1"]) {
//      if ([property.name isEqual:@"Opacity"]) {
//        property.value = @1;
//      }
//    }
//  }];
  for (NSInteger i = 1; i <= 10; ++i) {
    NSString *fruitLayerName = [NSString stringWithFormat:@"BarrelCellDefault%@", @(i)];
    CALayer *rowLayer = [self createRowLayerWithId:@(i).description];
    [animationInformation replaceLayerWithName:fruitLayerName
                                     withLayer:rowLayer
                                         error:&error];
  }
  
  SLCoreAnimation *animation = [SLCoreAnimation new];
  [animation buildWithInformation:animationInformation];
  animation.frame = self.animationView.bounds;
  [self.animationView.layer addSublayer:animation];
  
  animation.playbackType = SLPlaybackTypeLoop;
  [animation play];

  self.animation = animation;
}

@end
