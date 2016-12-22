//
//  EAKeyframeView.m
//  SquallExample
//
//  Created by Aleksey Goncharov on 22.12.16.
//  Copyright © 2016 Easy Ten. All rights reserved.
//

@import Keyframes;

#import "EAKeyframeView.h"

@interface EAKeyframeView ()

@property (nonatomic) NSUInteger currentVectorIndex;
@property (nonatomic, strong) NSMutableArray *vectorQueue;

@property (nonatomic, weak) KFVectorLayer *vectorLayer;

@end

@implementation EAKeyframeView

- (NSMutableArray *)vectorQueue {
  if (!_vectorQueue) {
    _vectorQueue = [NSMutableArray array];
  }
  return _vectorQueue;
}

- (KFVectorLayer *)_createVectorLayer {
  KFVectorLayer *layer = [KFVectorLayer new];
  layer.frame = self.bounds;
  return layer;
}

- (KFVector *)_loadVectorForIndex:(NSUInteger)index {
  NSString *fileName = [NSString stringWithFormat:@"%@_%@", self.vectorPrefix,  @(index)];
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName
                                                                        ofType:@"json"
                                                                   inDirectory:nil];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  if (!data) {
    return nil;
  }
  NSDictionary *sampleVectorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  KFVector *vector = KFVectorFromDictionary(sampleVectorDictionary);
  return vector;
}

- (KFVector *)_loadTransitionVectorFrom:(NSUInteger)from to:(NSUInteger)to {
  NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@", self.vectorPrefix,  @(from), @(to)];
  NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName
                                                                        ofType:@"json"
                                                                   inDirectory:nil];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  if (!data) {
    return nil;
  }
  NSDictionary *sampleVectorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
  KFVector *vector = KFVectorFromDictionary(sampleVectorDictionary);
  return vector;
}

- (instancetype)initWithVectorPrefix:(NSString *)vectorPrefix {
  self = [super init];
  if (self) {
    _vectorPrefix = vectorPrefix;
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  if (!self.vectorLayer) {
    KFVectorLayer *vectorLayer = [self _createVectorLayer];
    [self.layer addSublayer:vectorLayer];
    self.vectorLayer = vectorLayer;
  }
  self.vectorLayer.frame = rect;
}

- (void)startVectorAnimationAtIndex:(NSUInteger)index {
  if (self.vectorLayer.faceModel) {
    [self.vectorQueue addObject:@(index)];
  } else {
    KFVector *vector = [self _loadVectorForIndex:index];
    if (!vector) {
      return;
    }
    self.currentVectorIndex = index;
    self.vectorLayer.faceModel = vector;
    [self.vectorLayer startAnimation];
    
    __weak typeof(self) weakSelf = self;
    [self.vectorLayer setAnimationDidStopBlock:^(BOOL finish) {
      if (finish && weakSelf.vectorQueue.count) {
        [weakSelf.vectorLayer pauseAnimation];
        
        NSUInteger nextIndex = [[weakSelf.vectorQueue firstObject] unsignedIntegerValue];
        [weakSelf.vectorQueue removeFirstObject];
        KFVector *transitionVector = [weakSelf _loadTransitionVectorFrom:weakSelf.currentVectorIndex to:nextIndex];
        if (transitionVector) {
          // Transition
          KFVectorLayer *layer = [weakSelf _createVectorLayer];
          [weakSelf.layer addSublayer:layer];
          [weakSelf.vectorLayer removeFromSuperlayer];
          weakSelf.vectorLayer = layer;
          weakSelf.vectorLayer.repeatCount = 1.0f;
          
          weakSelf.vectorLayer.faceModel = transitionVector;
          [weakSelf.vectorLayer startAnimation];
          [weakSelf.vectorLayer setAnimationDidStopBlock:^(BOOL finish) {
            if (finish) {
//              [weakSelf.vectorLayer pauseAnimation];
              
              KFVectorLayer *layer = [weakSelf _createVectorLayer];
              [weakSelf.layer addSublayer:layer];
              [weakSelf.vectorLayer removeFromSuperlayer];
              weakSelf.vectorLayer = layer;
              
              [weakSelf startVectorAnimationAtIndex:nextIndex];
            }
          }];
        } else {
          KFVectorLayer *layer = [weakSelf _createVectorLayer];
          [weakSelf.layer addSublayer:layer];
          [weakSelf.vectorLayer removeFromSuperlayer];
          weakSelf.vectorLayer = layer;
          
          [weakSelf startVectorAnimationAtIndex:nextIndex];
        }

      }
    }];
  }
}

@end
