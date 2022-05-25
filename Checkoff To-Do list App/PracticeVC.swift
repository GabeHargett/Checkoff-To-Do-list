//
//  PracticeVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/27/22.
//

import UIKit

class Practice {
    static func startPractice() {
        let answer = twoSum(nums: [2,7,11,15], target: 17)
        
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
        var answer = [Int]()
        var numberInArray: Int?
        for (index, num) in nums.enumerated() {
            if let temporaryNumber = numberInArray {
                if (num + temporaryNumber) == target {
                    answer.append(index)
                }
                else{
                    numberInArray = num
                }
            }
            else {
                numberInArray = num
            }
        }
        return answer
    }
}

