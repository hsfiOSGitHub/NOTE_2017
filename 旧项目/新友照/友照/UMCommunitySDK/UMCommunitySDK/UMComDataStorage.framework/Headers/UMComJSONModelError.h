//
//  UMComJSONModelError.h
//
//  @version 1.2
//  @author Marin Todorov (http://www.underplot.com) and contributors
//

// Copyright (c) 2012-2015 Marin Todorov, Underplot ltd.
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////////////////////
typedef NS_ENUM(int, kUMComJSONModelErrorTypes)
{
    kUMComJSONModelErrorInvalidData = 1,
    kUMComJSONModelErrorBadResponse = 2,
    kUMComJSONModelErrorBadJSON = 3,
    kUMComJSONModelErrorModelIsInvalid = 4,
    kUMComJSONModelErrorNilInput = 5
};

/////////////////////////////////////////////////////////////////////////////////////////////
/** The domain name used for the UMComJSONModelError instances */
extern NSString* const UMComJSONModelErrorDomain;

/** 
 * If the model JSON input misses keys that are required, check the
 * userInfo dictionary of the UMComJSONModelError instance you get back - 
 * under the kUMComJSONModelMissingKeys key you will find a list of the
 * names of the missing keys.
 */
extern NSString* const kUMComJSONModelMissingKeys;

/**
 * If JSON input has a different type than expected by the model, check the
 * userInfo dictionary of the UMComJSONModelError instance you get back -
 * under the kUMComJSONModelTypeMismatch key you will find a description
 * of the mismatched types.
 */
extern NSString* const kUMComJSONModelTypeMismatch;

/**
 * If an error occurs in a nested model, check the userInfo dictionary of
 * the UMComJSONModelError instance you get back - under the kUMComJSONModelKeyPath
 * key you will find key-path at which the error occurred.
 */
extern NSString* const kUMComJSONModelKeyPath;

/////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Custom NSError subclass with shortcut methods for creating 
 * the common UMComJSONModel errors
 */
@interface UMComJSONModelError : NSError

@property (strong, nonatomic) NSHTTPURLResponse* httpResponse;

@property (strong, nonatomic) NSData* responseData;

/**
 * Creates a UMComJSONModelError instance with code kUMComJSONModelErrorInvalidData = 1
 */
+(id)errorInvalidDataWithMessage:(NSString*)message;

/**
 * Creates a UMComJSONModelError instance with code kUMComJSONModelErrorInvalidData = 1
 * @param keys a set of field names that were required, but not found in the input
 */
+(id)errorInvalidDataWithMissingKeys:(NSSet*)keys;

/**
 * Creates a UMComJSONModelError instance with code kUMComJSONModelErrorInvalidData = 1
 * @param mismatchDescription description of the type mismatch that was encountered.
 */
+(id)errorInvalidDataWithTypeMismatch:(NSString*)mismatchDescription;

/**
 * Creates a UMComJSONModelError instance with code kUMComJSONModelErrorBadResponse = 2
 */
+(id)errorBadResponse;

/**
 * Creates a UMComJSONModelError instance with code kUMComJSONModelErrorBadJSON = 3
 */
+(id)errorBadJSON;

/**
 * Creates a UMComJSONModelError instance with code kUMComJSONModelErrorModelIsInvalid = 4
 */
+(id)errorModelIsInvalid;

/**
 * Creates a UMComJSONModelError instance with code kUMComJSONModelErrorNilInput = 5
 */
+(id)errorInputIsNil;

/**
 * Creates a new UMComJSONModelError with the same values plus information about the key-path of the error.
 * Properties in the new error object are the same as those from the receiver,
 * except that a new key kUMComJSONModelKeyPath is added to the userInfo dictionary.
 * This key contains the component string parameter. If the key is already present
 * then the new error object has the component string prepended to the existing value.
 */
- (instancetype)errorByPrependingKeyPathComponent:(NSString*)component;

/////////////////////////////////////////////////////////////////////////////////////////////
@end
