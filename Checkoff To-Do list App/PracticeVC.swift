//
//  PracticeVC.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/27/22.
//

import UIKit

class Practice {
    static func startPractice() {
        let answer = twoSum(nums: [2,7,11,15], target: 9)
        let answer2 = increaseIntBy1(nums: [9])
        print("The answer of two sum qeustion is \(answer)")
        // Should print [0,1]
        print("The answer is \(answer2)")

        
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
    
    //You are given a large integer represented as an integer array digits, where each digits[i] is the ith digit of the integer. The digits are ordered from most significant to least significant in left-to-right order. The large integer does not contain any leading 0's.
//
//    Increment the large integer by one and return the resulting array of digits.
//
//
//
//    Example 1:
//
//    Input: digits = [1,2,3]
//    Output: [1,2,4]
//    Explanation: The array represents the integer 123.
//    Incrementing by one gives 123 + 1 = 124.
//    Thus, the result should be [1,2,4].
//    Example 2:
//
//    Input: digits = [4,3,2,1]
//    Output: [4,3,2,2]
//    Explanation: The array represents the integer 4321.
//    Incrementing by one gives 4321 + 1 = 4322.
//    Thus, the result should be [4,3,2,2].
//    Example 3:
//
//    Input: digits = [9]
//    Output: [1,0]
//    Explanation: The array represents the integer 9.
//    Incrementing by one gives 9 + 1 = 10.
//    Thus, the result should be [1,0].
//
//
//    Constraints:
//
//    1 <= digits.length <= 100
//    0 <= digits[i] <= 9
//    digits does not contain any leading 0's.
    static func increaseIntBy1(nums: [Int]) -> [Int] {
        
        var answer = nums
        
        for index in (0..<answer.count).reversed() {
//            answer = answer.last!
            let lastNumber = index
            if answer[lastNumber] != 9 {
                answer[lastNumber] = answer[lastNumber]+1
                return answer
            }
            else {
                answer[lastNumber] = 0
                answer.insert(1, at: 0)
                return answer
            }
        }
        return[]
    }
}
