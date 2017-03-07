//
//  LongViewController.m
//  SquallExample
//
//  Created by Aleksey Goncharov on 07.03.17.
//  Copyright © 2017 Easy Ten. All rights reserved.
//

@import PureLayout;

#import "RowView.h"
#import "LongViewController.h"

@interface LongViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *longView;

@end

@implementation LongViewController

- (RowView *)_createRowViewWithIndex:(NSUInteger)index {
  RowView *view = [[[NSBundle mainBundle] loadNibNamed:@"RowView" owner:nil options:nil] firstObject];
  view.label.text = [NSString stringWithFormat:@"Label %@", @(index)];
  [self.longView addSubview:view];
  [view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
  [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
  [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:index * 40.0f];
  [view autoSetDimension:ALDimensionHeight toSize:40.0f];

  return view;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  for (NSUInteger i = 0; i < 100; ++i) {
    [self _createRowViewWithIndex:i];
  }
}

- (IBAction)animate:(id)sender {
  self.longView.transform = CGAffineTransformIdentity;
  
  NSString *file = [[NSBundle mainBundle] pathForResource:@"SlotAnimation1" ofType:@"plist"];
  NSArray *keyValues = [NSArray arrayWithContentsOfFile:file];
  
  
  __weak typeof(self) weakSelf = self;
  [UIView animateKeyframesWithDuration:3.0f delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
    for (NSDictionary *data in keyValues) {
      double start = [data[@"start"] doubleValue];
      double duration = [data[@"duration"] doubleValue];
      double value = [data[@"value"] doubleValue];
      [UIView addKeyframeWithRelativeStartTime:start relativeDuration:duration animations:^{
        weakSelf.longView.transform = CGAffineTransformMakeTranslation(0.0f, value);
      }];
    }
  } completion:nil];
}

@end
