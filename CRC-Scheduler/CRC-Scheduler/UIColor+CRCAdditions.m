//
//  UIColor+CRCAdditions.m
//  CRC-Scheduler
//
//  Created by Cody Mace on 1/21/15.
//  Copyright (c) 2015 Cody Mace. All rights reserved.
//

#import "UIColor+CRCAdditions.h"

@implementation UIColor (CRCAdditions)

+ (UIColor *)CRCGreenColor
{
    return [UIColor colorWithRed:40/255.0 green:196/255.0 blue:154/255.0 alpha:1];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString; {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end
