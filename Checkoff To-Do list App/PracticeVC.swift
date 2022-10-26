//
//  PracticeVC.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 4/27/22.
//

import UIKit

class Practice {
    static func startPractice() {
//        let answer = twoSum([2,7,11,15], 9)
//        print("The answer1 of two sum qeustion is \(answer)")
//        // Should print [0,1]
//        let answer2 = increaseIntBy1(nums: [9])
//        print("The answer2 is \(answer2)")
//        let answer3 = returnTrueIfEqualsPowerInt(startingInt: 0, input: 50)
//        print("answer3 is \(answer3)")
//        let answer4 = palendrome(number: 121)
//        print(answer4)
//        let answer5 = moveZeros(numbers: [1,0,2,4,0,3,0,5,0,6])
//        print(answer5)
//        let strLengthAnswer = lengthOfLastWord("hello world ")
//        print(strLengthAnswer)
//        let binaryTrees = binaryTrees(p: [1,2,3], q: [1,2,3])
//        print(binaryTrees)
        let pascal = pascalTriangle(numRows: 4)
        print(pascal)
       let duplicateNumbs = duplicateNumbs(nums: [1,2,1,43])
        print(duplicateNumbs)
        let containsDuplicate = containsDuplicate([1,2,4,5,6,3,2])
        print(containsDuplicate)
        let findTheDifference = findTheDifference("1234rewq", "13w48e2rq")
        print(findTheDifference)

        var array = [2,3,2,3,2,3,4]
        let removeElement = removeElement(&array, 2)
        print(removeElement)
        let isIsomorphic = isIsomorphic("egg", "odd")
        print(isIsomorphic)
        let climbingStairs = climbingStairs(n: 4)
        print(climbingStairs)
        let longprefix = longestCommonPrefix(["hello", "helicopter", "hill"])
        print(longprefix)
    }
    static func longestCommonPrefix(_ strs: [String]) -> String {
            guard strs.count > 0 else { return "" }
            let chars_array = strs.map({ Array($0) })
            var string = ""
            var i = 0
            
            while true {
                var c: Character? = nil
                for chars in chars_array {
                    if i >= chars.count {
                        return string
                    } else {
                        if c == nil {
                            c = chars[i] }
                        
                        else if chars[i] != c! { return string }
                    }
                }
                string += String(c!)
                i += 1
            }
            
            return string
        }
        
    static func isPalindrome(_ x: Int) -> Bool {
        var stringInt = String(x)
         var rString = stringInt.reversed()
        var reversedString = String(rString)
         if stringInt == reversedString {
             return(true)
         } else {return(false)}
         // for letter in 0..<stringInt.count {
         //     if stri
         // }
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
    
//    static private func twoSum(nums: [Int], target: Int) -> [Int] {
//        for index1 in 0..<(nums.count-1) {
//            let leftNumber = index1
//            for index2 in (index1+1)..<nums.count{
//            let rightNumber = index2
//                if nums[leftNumber] + nums[rightNumber] == target {
//                    return [leftNumber, rightNumber]
//                }
//            }
//        }
//        return []
//    }
//    static func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
//        var nums = nums
//        nums.sort()
//        var rightI = nums.count-1
//        var leftI = 0
//        while rightI > leftI {
//            if nums[leftI] + nums[rightI] == target {
//                return[leftI, rightI]
//            }
//            else if nums[leftI] + nums[rightI] >= target {
//               rightI = nums[rightI-1]
//            }
//            else{
//            leftI = nums[leftI+1]
//            }
//        }
//        return[]
//    }
    
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
  
    //Given an integer n, return true if it is a power of three. Otherwise, return false.
    //
    //An integer n is a power of three, if there exists an integer x such that n == 3x.
    //
    //
    //
    //Example 1:
    //
    //Input: n = 27
    //Output: true
    //Example 2:
    //
    //Input: n = 0
    //Output: false
    //Example 3:
    //
    //Input: n = 9
    //Output: true
    //
    //
    //Constraints:
    //
    //-231 <= n <= 231 - 1
    //
    //
    //Follow up: Could you solve it without loops/recursion?
    //How can I use any integer to start instead of 3?
    static func returnTrueIfEqualsPowerInt(startingInt: Int, input: Int) -> Bool {
        if startingInt == 0 {return false}
        else if input % startingInt == 0 || input == 1 {
            return true
        }
        else if input == 0{
            return false
        }
        else {
            return false
        }
    }
//    Given an integer x, return true if x is palindrome integer.
//
//    An integer is a palindrome when it reads the same backward as forward.
//
//    For example, 121 is a palindrome while 123 is not.
//
//
//    Example 1:
//
//    Input: x = 121
//    Output: true
//    Explanation: 121 reads as 121 from left to right and from right to left.
//    Example 2:
//
//    Input: x = -121
//    Output: false
//    Explanation: From left to right, it reads -121. From right to left, it becomes 121-. Therefore it is not a palindrome.
//    Example 3:
//
//    Input: x = 10
//    Output: false
//    Explanation: Reads 01 from right to left. Therefore it is not a palindrome.
//
//
//    Constraints:
//
//    -231 <= x <= 231 - 1
//
//
//    Follow up: Could you solve it without converting the integer to a string?
    static func palendrome(number: Int) -> Bool{
        guard number >= 0 else {
           return false
       }
        var temporaryNum = number
        var reverseNum = 0
        
    while(temporaryNum != 0){
        reverseNum = (reverseNum * 10) + temporaryNum % 10
        temporaryNum /= 10
    }
        return reverseNum == number
}
    
    static func moveZeros(numbers: [Int]) -> [Int]{
        var numbers = numbers
        for number in 0..<(numbers.count-1) {
            if numbers[number] == 0 {
                numbers.remove(at: number)
                numbers.append(0)

            }
        }
        return numbers
    }
    //
    //Given an integer numRows, return the first numRows of Pascal's triangle.
    //
    //In Pascal's triangle, each number is the sum of the two numbers directly above it as shown:
    //Example 1:
    //
    //Input: numRows = 5
    //Output: [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]
    //Example 2:
    //
    //Input: numRows = 1
    //Output: [[1]]
    //
    //
    //Constraints:
    //
    //1 <= numRows <= 30

    static func pascalTriangle(numRows: Int) -> [[Int]] {
        guard numRows > 0 else {return [[]]}
        
        if numRows == 1  {
            return [[1]]
        }
        var array = [[Int]]()
        array.append([1])
        for i in 1..<numRows {
            var rows = [1]
            let previousArray = array[i-1]
            for j in 1..<previousArray.count {
                let sum = previousArray[j - 1] + previousArray[j]
                rows.append(sum)
            }
            rows.append(1)
            array.append(rows)
        }
      return array
    }
//    Given the roots of two binary trees p and q, write a function to check if they are the same or not.
//
//    Two binary trees are considered the same if they are structurally identical, and the nodes have the same value.
//
//
//
//    Example 1:
//
//
//    Input: p = [1,2,3], q = [1,2,3]
//    Output: true
//    Example 2:
//
//
//    Input: p = [1,2], q = [1,null,2]
//    Output: false
//    Example 3:
//
//
//    Input: p = [1,2,1], q = [1,1,2]
//    Output: false
    static func binaryTrees(p: [Int], q: [Int]) -> Bool {
        if p == q {
            return true
        }
        else{
            return false
            
        }
        
    }
//Given an integer array nums, return true if any value appears at least twice in the array, and return false if every element is distinct.
//
//
//
//Example 1:
//
//Input: nums = [1,2,3,1]
//Output: true
//Example 2:
//
//Input: nums = [1,2,3,4]
//Output: false
//Example 3:
//
//Input: nums = [1,1,1,3,3,4,3,2,4,2]
//Output: true
//
//
//Constraints:
//
//1 <= nums.length <= 105
//-109 <= nums[i] <= 109

    static func duplicateNumbs(nums: [Int]) -> Bool {
        for i in 0..<(nums.count-1) {
            let duplicateNum = nums[i]
             for j in (i+1)..<nums.count {
                 let numCheck = nums[j]
                if duplicateNum == numCheck {
                    return true
                }
            }
        }
        return false
        //slow time complexity
    }
    //using sets
    static func containsDuplicate(_ nums: [Int]) -> Bool {
        Set(nums).count != nums.count
    }
    //using dictionary
//    static func containsDuplicate(_ nums: [Int]) -> Bool {
//            guard nums.count > 1 else{return false}
//            var hashTable = [Int: Int]()
//            for i in nums {
//                guard hashTable[i] == nil else {
//                    return true
//                }
//                hashTable[i] = 1
//            }
//            return false
//        }

//Given a string s consisting of words and spaces, return the length of the last word in the string.
//
//A word is a maximal substring consisting of non-space characters only.
//
// 
//
//Example 1:
//
//Input: s = "Hello World"
//Output: 5
//Explanation: The last word is "World" with length 5.
//Example 2:
//
//Input: s = "   fly me   to   the moon  "
//Output: 4
//Explanation: The last word is "moon" with length 4.
//Example 3:
//
//Input: s = "luffy is still joyboy"
//Output: 6
//Explanation: The last word is "joyboy" with length 6.
// 
//
//Constraints:
//
//1 <= s.length <= 104
//s consists of only English letters and spaces ' '.
//There will be at least one word in s.

    static func lengthOfLastWord(_ s: String) -> Int {
        // parameter s is immutable
        var string = s
        // drop the whitespaces at the end of the string
        while string.last == " " {
            string.removeLast()
        }
        // main functionality
        var length = 0
        for character in string.reversed(){
            if character == " " {
                break
            }
            length += 1
        }
        return length
    }

static func addedIndexs(nums: [Int]) -> [Int] {
    var answerArray = [Int]()
    for index in 0..<nums.count {
        var int = 0
        if index != 0    {
            let previousNum = nums[index - 1]
            int += previousNum
        }
        if index != nums.count-1 {
            let nextNum = nums[index+1]
            int += nextNum
        }
        let currentNum = nums[index]
        int += currentNum
        answerArray.append(int)
    }
    return answerArray
}
       static func findTheDifference(_ s: String, _ t: String) -> Character {
            var map:[Character:UInt8] = [:]
            for each in s{
                let value = map[each] ?? 0
                map[each] = value + 1
            }
            for each in t{
                if let value = map[each], value > 0{
                    map[each] = value - 1
                }else {
                    return each
                }
            }
            return " "
        }
//    Write an algorithm to determine if a number n is happy.
//
//    A happy number is a number defined by the following process:
//
//    Starting with any positive integer, replace the number by the sum of the squares of its digits.
//    Repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle which does not include 1.
//    Those numbers for which this process ends in 1 are happy.
//    Return true if n is a happy number, and false if not.
//
//
//
//    Example 1:
//
//    Input: n = 19
//    Output: true
//    Explanation:
//    1^2 + 9^2 = 82
//    8^2 + 2^2 = 68
//    6^2 + 8^2 = 100
//    1^2 + 0^2 + 0^2 = 1
//    Example 2:
//
//    Input: n = 2
//    Output: false
//
//
//    Constraints:
//
//    1 <= n <= 231 - 1
    static func isHappy(_ n: Int) -> Bool {
        var set = Set<Int>()
        guard n != 1 else { return true }
        guard !set.contains(n) else { return false }
        set.insert(n)
        
        var sum = 0
        var n = n
        while n != 0 {
            sum += (n % 10) * (n % 10)
            n /= 10
        }
        return isHappy(sum)
    }
//    Given an integer array nums and an integer val, remove all occurrences of val in nums in-place. The relative order of the elements may be changed.
//
//    Since it is impossible to change the length of the array in some languages, you must instead have the result be placed in the first part of the array nums. More formally, if there are k elements after removing the duplicates, then the first k elements of nums should hold the final result. It does not matter what you leave beyond the first k elements.
//
//    Return k after placing the final result in the first k slots of nums.
//
//    Do not allocate extra space for another array. You must do this by modifying the input array in-place with O(1) extra memory.
//
//    Custom Judge:
//
//    The judge will test your solution with the following code:
//
//    int[] nums = [...]; // Input array
//    int val = ...; // Value to remove
//    int[] expectedNums = [...]; // The expected answer with correct length.
//                                // It is sorted with no values equaling val.
//
//    int k = removeElement(nums, val); // Calls your implementation
//
//    assert k == expectedNums.length;
//    sort(nums, 0, k); // Sort the first k elements of nums
//    for (int i = 0; i < actualLength; i++) {
//        assert nums[i] == expectedNums[i];
//    }
//    If all assertions pass, then your solution will be accepted.
//
//
//
//    Example 1:
//
//    Input: nums = [3,2,2,3], val = 3
//    Output: 2, nums = [2,2,_,_]
//    Explanation: Your function should return k = 2, with the first two elements of nums being 2.
//    It does not matter what you leave beyond the returned k (hence they are underscores).
//    Example 2:
//
//    Input: nums = [0,1,2,2,3,0,4,2], val = 2
//    Output: 5, nums = [0,1,4,0,3,_,_,_]
//    Explanation: Your function should return k = 5, with the first five elements of nums containing 0, 0, 1, 3, and 4.
//    Note that the five elements can be returned in any order.
//    It does not matter what you leave beyond the returned k (hence they are underscores).
//
//
//    Constraints:
//
//    0 <= nums.length <= 100
//    0 <= nums[i] <= 50
//    0 <= val <= 100
    
    static func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        guard !nums.isEmpty else {return 0}
        var i = 0
        for num in nums {
            if num != val {continue}
            nums[i] = num
            i += 1
        }
        return i
    }

//func digits() -> [Int] {
//    var digits: [Int] = []
//    var num = self
//    repeat {
//        digits.append(num % 10)
//        num /= 10
//    } while num != 0
//    return digits.reversed()
//}
//}
    static func isIsomorphic(_ s: String, _ t: String) -> Bool {
        let S = Array(s)
        var dict = [Character:Character]()
        
        for (i, char) in t.enumerated() {
            //If current character is mapped, check its value matches other character
            if let map = dict[char] {
                if map != S[i] { return false }
            }else {
                //If not already mapped, check that other character isn't already mapped
                if dict.values.contains(S[i]) {
                    return false
                }
                //Map chars
                dict[char] = S[i]
            }
        }
        
        return true
    }
//    You are climbing a staircase. It takes n steps to reach the top.
//
//    Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?
//
//
//
//    Example 1:
//
//    Input: n = 2
//    Output: 2
//    Explanation: There are two ways to climb to the top.
//    1. 1 step + 1 step
//    2. 2 steps
//    Example 2:
//
//    Input: n = 3
//    Output: 3
//    Explanation: There are three ways to climb to the top.
//    1. 1 step + 1 step + 1 step
//    2. 1 step + 2 steps
//    3. 2 steps + 1 step
//
//
//    Constraints:
//
//    1 <= n <= 45
    static func climbingStairs(n: Int) -> Int {
        if n <= 0 { return n }

        var first = 0
        var second = 1
        var third = 0
        
        for _ in 1...n {
            third = first + second
            first = second
            second = third
        }

        return second
    }
//    Given a non-empty array of integers nums, every element appears twice except for one. Find that single one.
//
//    You must implement a solution with a linear runtime complexity and use only constant extra space.
//
//
//
//    Example 1:
//
//    Input: nums = [2,2,1]
//    Output: 1
//    Example 2:
//
//    Input: nums = [4,1,2,1,2]
//    Output: 4
//    Example 3:
//
//    Input: nums = [1]
//    Output: 1
//
//
//    Constraints:
//
//    1 <= nums.length <= 3 * 104
//    -3 * 104 <= nums[i] <= 3 * 104
//    Each element in the array appears twice except for one element which appears only once.

    }

//class Solution {
//    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
//        var numbers = nums
//        numbers.sort()
//        var rightI = numbers.count-1
//        var leftI = 0
//        while rightI > leftI {
//            if numbers[leftI] + numbers[rightI] == target {
//                if numbers[leftI] == numbers[rightI] {
//                    var ogLeftI = -1
//                    var ogRightI = -1
//                    for (index, element) in nums.enumerated() {
//                        if element == numbers[leftI] {
//                            if ogLeftI == -1 {
//                               ogLeftI = index
//                            } else {
//                               ogRightI = index
//                                 return[ogLeftI, ogRightI]
//                            }
//
//                        }
//                    }
//                } else {
//                    let ogLeftI = nums.firstIndex(where: {$0 == numbers[leftI]})!
//                    let ogRightI = nums.firstIndex(where: {$0 == numbers[rightI]})!
//                    return[ogLeftI, ogRightI]
//                }
//            }
//            else if numbers[leftI] + numbers[rightI] > target {
//               rightI = rightI-1
//            } else{
//                leftI = leftI+1
//            }
//        }
//        return[]
//    }
//}
