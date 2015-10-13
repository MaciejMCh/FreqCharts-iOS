//
//  FCSwiftShitness.m
//  FreqCharts
//
//  Created by Maciej Chmielewski on 13.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

#import "FCSwiftShitness.h"
#import <objc/runtime.h>

@implementation FCSwiftShitness

+ (id)instantiateClass:(Class)productClass dictionary:(NSDictionary *)dictionary {
    id product = [productClass alloc];
    SEL initSelector = @selector(initWithDictionary:);
    [product performSelector:initSelector withObject:dictionary];
    return product;
}

@end
