---
title: "[Java] Codeforces 520A - Pangram"
excerpt: "Pangram"

categories:
  - Codeforces
tags:
  - [Java]

permalink: /categories/codeforces/codeforces-520a-pangram/

toc: true
toc_sticky: true

date: 2022-12-26
last_modified_at: 2022-12-26
---

<https://codeforces.com/problemset/problem/520/A>

<br>

## Solution

```java
import org.w3c.dom.ls.LSOutput;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Solution {
    static void printYesOrNo(String input) {
        int count = 0;
        for (char ch = 'a'; ch <= 'z'; ch++) {
            if (input.toLowerCase().contains(String.valueOf(ch))) {
                count++;
            }
        }

        if (count == 26) {
            System.out.print("YES");
        } else {
            System.out.print("NO");
        }
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        int n = Integer.parseInt(br.readLine());
        String input = br.readLine();
        printYesOrNo(input);
        br.close();
    }
}
```