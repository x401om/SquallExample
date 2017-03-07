//
//  SlotMachineViewController.m
//  SquallExample
//
//  Created by Aleksey Goncharov on 07.03.17.
//  Copyright © 2017 Easy Ten. All rights reserved.
//

#import "SlotMachineViewController.h"

@interface SlotMachineViewController ()<UITabBarDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation SlotMachineViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.contentOffset = CGPointMake(0.0f, 40.0f * 15);
}

- (IBAction)animatePressed:(id)sender {
  __weak typeof(self) weakSelf = self;
  
  self.tableView.contentOffset = CGPointMake(0.0f, 40.0f * 15);
  self.timer =
  [NSTimer scheduledTimerWithTimeInterval:1.0f / 60.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
    CGPoint offset = weakSelf.tableView.contentOffset;
    
    if (offset.y <= 10.0f) {
      offset.y += 1.0f;
    } else if (offset.y <= 40.0f) {
      offset.y += 3.0f;
    }  else if (offset.y <= 100.0f) {
      offset.y += 5.0f;
    } else if (offset.y <= 200.0f) {
      offset.y += 10.0f;
    } else if (offset.y <= 300.0f) {
      offset.y += 15.0f;
    } else if (offset.y <= 1800.0f) {
      offset.y += 17.0f;
    } else if (offset.y <= 1900.0f) {
      offset.y += 13.0f;
    } else if (offset.y <= 1940.0f) {
      offset.y += 8.0f;
    } else if (offset.y <= 1980.0f) {
      offset.y += 5.0f;
    } else if (offset.y <= 2020.0f) {
      offset.y += 3.0f;
    } else if (offset.y <= 2040.0f) {
      offset.y += 1.0f;
    } else if (offset.y > 2040.0f) {
      [weakSelf.timer invalidate];
      return ;
    }
    
    weakSelf.tableView.contentOffset = offset;
  }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  
  for (UIView *v in cell.contentView.subviews) {
    if ([v isKindOfClass:[UILabel class]]) {
      [(UILabel *)v setText:[NSString stringWithFormat:@"Row %@", @(indexPath.row)]];
    }
  }
  return cell;
}

@end
