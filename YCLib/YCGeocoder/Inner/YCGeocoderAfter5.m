//
//  YCGeocoderAfter5.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark.h"
#import "YCGeocoderAfter5.h"

@interface YCGeocoderAfter5 (private) 

/**
 用超时错误来回调
 **/
- (void)_doFailForwardGeocodeWithTimeoutError;
- (void)_doFailReverseGeocodeWithTimeoutError;

@end

@implementation YCGeocoderAfter5

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)initWithTimeout:(NSTimeInterval)timeout{
    self = [super initWithTimeout:timeout];
    if (self) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)dealloc{
    [_geocoder release];
    [_reverseGeocodeCompletionHandler release];
    [super dealloc];
}

- (void)cancel{
    if (_geocoder.geocoding) {
        [_geocoder cancelGeocode];
    }
}

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(YCGeocodeCompletionHandler)completionHandler{
    
}

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(YCGeocodeCompletionHandler)completionHandler{
    
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(YCGeocodeCompletionHandler)completionHandler{
    
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(YCReverseGeocodeCompletionHandler)completionHandler{
    
    //声明block，为了超时回调
    CLGeocodeCompletionHandler handler = ^(NSArray *placemarks, NSError *error){
        //取消上次的超时回调，并停止当前查询
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_doFailReverseGeocodeWithTimeoutError) object:nil];
        if (_geocoder.geocoding) 
            [_geocoder cancelGeocode];
        
        YCPlacemark *aYCplacemark = nil;
        if ([placemarks count] > 0) 
            aYCplacemark = [[YCPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
        
         completionHandler(aYCplacemark,error);
    };

    //释放：有可能上次调用copy的block
    if (_reverseGeocodeCompletionHandler){
        [_reverseGeocodeCompletionHandler release];
        _reverseGeocodeCompletionHandler = nil;
    }
    _reverseGeocodeCompletionHandler = [handler copy];
    
    [_geocoder reverseGeocodeLocation:location completionHandler:handler];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_doFailReverseGeocodeWithTimeoutError) object:nil];
    [self performSelector:@selector(_doFailReverseGeocodeWithTimeoutError) withObject:nil afterDelay:_timeout]; //超时调用
}

- (void)_doFailForwardGeocodeWithTimeoutError{
    
}

- (void)_doFailReverseGeocodeWithTimeoutError{
    if (_geocoder.geocoding) {
        _reverseGeocodeCompletionHandler(nil,[NSError errorWithDomain:NSOSStatusErrorDomain code:-100 userInfo:nil]);
    }
}


@end
