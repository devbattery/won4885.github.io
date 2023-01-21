---
title: "[Java] Codeforces 131A - cAPS lOCK"
excerpt: "cAPS lOCK"

categories:
  - Codeforces
tags:
  - [Java]

permalink: /categories/codeforces/codeforces-131a-caps-lock/

toc: true
toc_sticky: true

date: 2022-12-25
last_modified_at: 2022-12-25
---

<https://codeforces.com/problemset/problem/131/A>

<br>

## Solution

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Solution {
    static void printResult(String input) {
        char[] inputToChar = input.toCharArray();
        boolean flag = true;
        for (int i = 1; i < inputToChar.length; i++) {
            if (Character.isLowerCase(inputToChar[i])) {
                flag = false;
            }
        }
        if (flag) { // is upper?
            for (int i = 0; i < inputToChar.length; i++) {
                if (Character.isUpperCase(inputToChar[i])) {
                    inputToChar[i] = Character.toLowerCase(inputToChar[i]);
                } else { //Lower
                    inputToChar[i] = Character.toUpperCase(inputToChar[i]);
                }
            }
        }
        System.out.print(inputToChar);
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String input = br.readLine();
        printResult(input);
        br.close();
    }
}
```