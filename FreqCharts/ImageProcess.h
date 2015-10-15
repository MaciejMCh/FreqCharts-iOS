//
//  ImageProcess.h
//  FreqCharts
//
//  Created by Maciej Chmielewski on 15.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGPointWrapper : NSObject
@property (nonatomic) CGPoint point;
@end

@protocol ImageProcessorDelegate <NSObject>

- (void)imageProcessorFinishedProcessingWithImage:(UIImage*)outputImage;

@end

@interface ImageProcessor : NSObject

@property (weak, nonatomic) id<ImageProcessorDelegate> delegate;

+ (instancetype)sharedProcessor;

- (UIImage *)processImage:(UIImage*)inputImage;
- (NSArray *)findNullsInImage:(UIImage *)image inColor:(UIColor *)color;

@end