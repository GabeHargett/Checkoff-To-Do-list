//
//  PracticeVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/27/22.
//

import UIKit

class Practice {
    static func startPractice() {
        let answer = twoSum(nums: [1], target: 1)
        
        print("The answer of two sum qeustion is \(answer)")
        // Should print [0,1]
        
    }
    
//    Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.
//
//    You may assume that each input would have exactly one solution, and you may not use the same element twice.
//
//    You can return the answer in any order.
    
//    Example 1:
//
//    Input: nums = [2,7,11,15], target = 9
//    Output: [0,1]
//    Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
//    Example 2:
//
//    Input: nums = [3,2,4], target = 6
//    Output: [1,2]
//    Example 3:
//
//    Input: nums = [3,3], target = 6
//    Output: [0,1]
//
//
//    Constraints:
//
//    2 <= nums.length <= 104
//    -109 <= nums[i] <= 109
//    -109 <= target <= 109
//    Only one valid answer exists.
    
    static private func twoSum(nums: [Int], target: Int) -> [Int] {
        for index1 in 0..<(nums.count-1) {
            let leftNumber = index1
            for index2 in (index1+1)..<nums.count{
            let rightNumber = index2
                if nums[leftNumber] + nums[rightNumber] == target {
                    return [leftNumber, rightNumber]
                }
            }
        }
        return []
    }
}

