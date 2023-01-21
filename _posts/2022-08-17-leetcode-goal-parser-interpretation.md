---
title: "[Java] LeetCode 1678. Goal Parser Interpretation"
excerpt: "Goal Parser Interpretation"

categories:
  - LeetCode
tags:
  - [Java]

permalink: /leetcode/leetcode-goal-parser-interpretation/

toc: true
toc_sticky: true

date: 2022-08-17
last_modified_at: 2022-08-17
---

<https://leetcode.com/problems/goal-parser-interpretation/>

<br>

## Solution

```java
class Solution {
    static String interpret(String command) {
        return command.replaceAll("\\(\\)", "o").replaceAll("\\(al\\)", "al");
    }

    public static void main(String[] args) {
        System.out.println(interpret("G()(al)"));
        System.out.print(interpret("G()()()()(al)"));
    }
}
```