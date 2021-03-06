//
//  YCGeocoderBefore5.m
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark.h"
#import "YCGeocoderBefore5.h"

@interface YCGeocoderBefore5 (private) 

/**
 用超时错误回调
 **/
- (void)_doFailForwardGeocodeWithTimeoutError;
- (void)_doFailReverseGeocodeWithTimeoutError;

/**
 结束查询，并释放相关资源
 **/
- (void)_cancelForwardGeocode;
- (void)_cancelReverseGeocode;

@end

@implementation YCGeocoderBefore5

#pragma mark - Init and dealloc

+ (id)allocWithZone:(NSZone *)zone{
    return NSAllocateObject([self class], 0, zone);
}

- (id)initWithTimeout:(NSTimeInterval)timeout{
    self = [super initWithTimeout:timeout];
    if (self) {
        _forwardGeocoder = [[BSForwardGeocoder alloc] init];
        //resverseGeocoder;
    }
    return self;
}

- (void)dealloc{
    [_forwardGeocoder release];
    [_resverseGeocoder cancel];[_resverseGeocoder release];
    [_reverseGeocodeCompletionHandler release];
    [super dealloc];
}

#pragma mark - Implement Abstract Super Method

- (void)cancel{
    [self _cancelForwardGeocode];
    [self _cancelReverseGeocode];
}

- (void)geocodeAddressDictionary:(NSDictionary *)addressDictionary completionHandler:(YCGeocodeCompletionHandler)completionHandler{
    
}

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(YCGeocodeCompletionHandler)completionHandler{
    
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(YCGeocodeCompletionHandler)completionHandler{
    
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(YCReverseGeocodeCompletionHandler)completionHandler{
    //先取消，不论有没有
    [self _cancelReverseGeocode];
    
    _reverseGeocodeCompletionHandler = [completionHandler copy] ;
    _resverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
    _resverseGeocoder.delegate = self;
    [_resverseGeocoder start];
    [self performSelector:@selector(_doFailReverseGeocodeWithTimeoutError) withObject:nil afterDelay:_timeout]; //
    
}

#pragma mark - MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
    _reverseGeocodeCompletionHandler([[YCPlacemark alloc] initWithPlacemark:placemark],nil);
    [self _cancelReverseGeocode];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_doFailReverseGeocodeWithTimeoutError) object:nil];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    _reverseGeocodeCompletionHandler(nil,error);
    [self _cancelReverseGeocode];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_doFailReverseGeocodeWithTimeoutError) object:nil];
}

#pragma mark - 工具

- (void)_doFailForwardGeocodeWithTimeoutError{
    
}

- (void)_cancelForwardGeocode{
    
}

- (void)_doFailReverseGeocodeWithTimeoutError{
    if (_resverseGeocoder.querying) {
        [_resverseGeocoder.delegate reverseGeocoder:_resverseGeocoder didFailWithError:[NSError errorWithDomain:NSOSStatusErrorDomain code:-100 userInfo:nil] ];
    }
}

- (void)_cancelReverseGeocode{
    if (_resverseGeocoder) {
        if (_resverseGeocoder.querying) {
            [_resverseGeocoder cancel];
        }
        [_resverseGeocoder release];
        _resverseGeocoder = nil;
    }

    if (_reverseGeocodeCompletionHandler) {
        [_reverseGeocodeCompletionHandler release];
        _reverseGeocodeCompletionHandler = nil;
    }
}

@end
