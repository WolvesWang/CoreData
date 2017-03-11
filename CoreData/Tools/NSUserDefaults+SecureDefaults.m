//
//  NSUserDefaults+SecureDefaults.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/3.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "NSUserDefaults+SecureDefaults.h"
#import <security/Security.h>

@implementation NSUserDefaults (SecureDefaults)

+ (id)secureDefaultForKey:(NSString *)key;
{
    id result = nil;
    
    if (key) {
        @synchronized(self) {
            CFStringRef cfKey = (__bridge CFStringRef)key;
            const void *keys[6] = { kSecClass, kSecAttrAccount, kSecMatchLimit, kSecReturnData, kSecReturnAttributes, kSecReturnPersistentRef };
            const void *values[6] = { kSecClassGenericPassword, cfKey, kSecMatchLimitOne, kCFBooleanTrue, kCFBooleanTrue, kCFBooleanTrue };
            CFDictionaryRef searchDictionary = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 6, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
            CFDictionaryRef attributesDictionary = NULL;
            OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchDictionary, (CFTypeRef *)&attributesDictionary);
            
            if (noErr == status) {
                CFDataRef cfData = CFDictionaryGetValue(attributesDictionary, kSecValueData);
                
                if (NULL != cfData) {
                    NSData *data = (__bridge NSData *)cfData;
                    
                    result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                }
            }
            else if (errSecItemNotFound != status) {
                NSLog(@"secureDefaultForKey: Error (%d) getting value for key (%@)", (int)status, key);
            }
            
            if (NULL != searchDictionary) {
                CFRelease(searchDictionary);
            }
            
            if (NULL != attributesDictionary) {
                CFRelease(attributesDictionary);
            }
        }
    }
    
    return result;
}

+ (void)setSecureDefault:(id <NSObject, NSCoding>)value forKey:(NSString *)key;
{
    BOOL conformsToProtocol = [value conformsToProtocol:NSProtocolFromString(@"NSCoding")];
    
    if (YES == conformsToProtocol) {
        
        @synchronized(self) {
            
            NSString *currentValue = [self secureDefaultForKey:key];
            CFStringRef cfKey = (__bridge CFStringRef)key;
            NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:value];
            CFDataRef cfValueData = (__bridge CFDataRef)valueData;
            const void *keys[3] = { kSecClass, kSecAttrAccount, kSecValueData };
            const void *values[3] = { kSecClassGenericPassword, cfKey, cfValueData };
            CFDictionaryRef keychainItemAttributeDictionary = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 3, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
            
            if (nil != currentValue) {
                const void *updateKeys[2] = { kSecAttrAccount, kSecValueData };
                const void *updateValues[2] = { cfKey, cfValueData };
                CFDictionaryRef updateDictionary = CFDictionaryCreate(kCFAllocatorDefault, updateKeys, updateValues, 2, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
                
                OSStatus status = SecItemUpdate(keychainItemAttributeDictionary, updateDictionary);
                
                if (noErr != status) {
                    NSLog(@"setSecureDefault:forKey: Error (%d) setting value (%@) for key (%@)", (int)status, value, key);
                }
            }
            else {
                OSStatus status = SecItemAdd(keychainItemAttributeDictionary, NULL);
                
                if (noErr != status) {
                    NSLog(@"setSecureDefault:forKey: Error (%d) setting value (%@) for key (%@)", (int)status, value, key);
                }
            }
        }
    }
    else {
        NSLog(@"setSecureDefault:forKey: value of class %@ does not conform to NSCoding protocol.", NSStringFromClass([value class]));
    }
    
    return;
}

+ (void)removeSecureDefaultForKey:(NSString *)key;
{
    NSString *currentValue = [self secureDefaultForKey:key];
    
    if (nil != currentValue) {
        CFStringRef cfKey = (__bridge CFStringRef)key;
        const void *keys[2] = { kSecClass, kSecAttrAccount };
        const void *values[2] = { kSecClassGenericPassword, cfKey };
        CFDictionaryRef searchDictionary = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 2, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
        OSStatus status = SecItemDelete(searchDictionary);
        
        if (noErr != status) {
            NSLog(@"removeSecureDefaultForKey: Error (%d) removing value for key (%@)", (int)status, key);
        }
    }
    
    return;
}

@end
