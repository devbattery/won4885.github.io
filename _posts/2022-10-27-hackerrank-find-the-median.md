---
title: "[Java] HackerRank Find the Median"
excerpt: "Find the Median"

categories:
  - HackerRank
tags:
  - [Java]

permalink: /hackerrank/hackerrank-find-the-median/

toc: true
toc_sticky: true

date: 2022-10-27
last_modified_at: 2022-10-27
---

<https://www.hackerrank.com/challenges/find-the-median/problem?isFullScreen=true>

<br>

## Solution

```java
import java.io.*;
import java.util.*;
import java.util.stream.*;
import static java.util.stream.Collectors.toList;

class Result {
    static int findMedian(List<Integer> arr) {
        int answer;
        Collections.sort(arr);
        answer = arr.get(arr.size() / 2);
        return answer;
    }
}

public class Solution {
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(System.getenv("OUTPUT_PATH")));

        int n = Integer.parseInt(bufferedReader.readLine().trim());

        List<Integer> arr = Stream.of(bufferedReader.readLine().replaceAll("\\s+$", "").split(" "))
                .map(Integer::parseInt)
                .collect(toList());

        int result = Result.findMedian(arr);

        bufferedWriter.write(String.valueOf(result));
        bufferedWriter.newLine();

        bufferedReader.close();
        bufferedWriter.close();
    }
}
```