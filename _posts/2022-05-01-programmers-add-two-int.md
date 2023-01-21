---
title: "[Java] Programmers 두 정수 사이의 합"
excerpt: "두 정수 사이의 합"

categories:
  - Programmers
tags:
  - [Java]

permalink: /programmers/programmers-add-two-int/

toc: true
toc_sticky: true

date: 2022-05-01
last_modified_at: 2022-05-01
---

<https://programmers.co.kr/learn/courses/30/lessons/12912?language=java>

<br>


## Solution

```java
class Solution {
    public static long solution(int a, int b) {
        long answer = 0;

        if (a == b) {
            answer = a;
        }

        if (a < b) {
            for (int i = a; i <= b; i++) {
                answer += i;
            }
        }

        if (a > b) {
            for (int i = b; i <= a; i++) {
                answer += i;
            }
        }

        return answer;
    }

    public static void main(String[] args) {
        System.out.println(solution(3, 5));
        System.out.println(solution(3, 3));
        System.out.println(solution(5, 3));
    }
}
```
<!-- <br>

## Another Solution

```java

```  -->
