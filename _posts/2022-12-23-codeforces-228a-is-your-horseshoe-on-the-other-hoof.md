---
title: "[Java] Codeforces 228A - Is your horseshoe on the other hoof?"
excerpt: "Is your horseshoe on the other hoof?"

categories:
  - Codeforces
tags:
  - [Java]

permalink: /categories/codeforces/codeforces-228a-is-your-horseshoe-on-the-other-hoof/

toc: true
toc_sticky: true

date: 2022-12-23
last_modified_at: 2022-12-23
---

<https://codeforces.com/problemset/problem/228/A>

<br>

## Solution

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;

public class Solution {
    static void printMinNum(List<Integer> input) {
        int count = 0;
        Collections.sort(input);
        for (int i = 0; i < input.size() - 1; i++) {
            if (Objects.equals(input.get(i), input.get(i + 1))) {
                count++;
            }
        }
        System.out.print(count);
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        List<Integer> input = new ArrayList<>();
        StringTokenizer st = new StringTokenizer(br.readLine(), " ");
        while (st.hasMoreTokens()) {
            input.add(Integer.parseInt(st.nextToken()));
        }
        printMinNum(input);
        br.close();
    }
}
```