---
title: "[Java] Codeforces 208A - Dubstep"
excerpt: "Dubstep"

categories:
  - Codeforces
tags:
  - [Java]

permalink: /categories/codeforces/codeforces-208a-dubstep/

toc: true
toc_sticky: true

date: 2022-12-24
last_modified_at: 2022-12-24
---

<https://codeforces.com/problemset/problem/208/A>

<br>

## Solution

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Solution {
    static void printWords(String input) {
        String[] inputToArr = input.split("WUB");
        for (String s : inputToArr) {
            if (s.equals("")) {
                continue;
            }
            System.out.print(s + " ");
        }
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String input = br.readLine();
        printWords(input);
        br.close();
    }
}
```