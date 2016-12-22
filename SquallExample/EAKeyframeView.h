//
//  EAKeyframeView.h
//  SquallExample
//
//  Created by Aleksey Goncharov on 22.12.16.
//  Copyright © 2016 Easy Ten. All rights reserved.
//

@import UIKit;

@interface EAKeyframeView : UIView

@property (nonatomic, strong) NSString *vectorPrefix;
@property (nonatomic, readonly) NSUInteger currentVectorIndex;

- (void)startVectorAnimationAtIndex:(NSUInteger)index;

@end
