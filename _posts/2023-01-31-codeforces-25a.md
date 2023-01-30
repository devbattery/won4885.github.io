---
title: "[Java] Codeforces 25A - IQ test"
excerpt: "IQ test"

categories:
  - Codeforces
tags:
  - [brute-force]

permalink: /categories/codeforces/codeforces-25a/

toc: true
toc_sticky: true

date: 2023-01-30
last_modified_at: 2023-01-30
---

- [Reference](https://codeforces.com/problemset/problem/25/A)

<br>

## Solution

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

public class C_25A {
    public static int solution(List<Integer> list) {
        int index = 1; // Numbers are numbered from 1 in the input order -> 번호가 1부터 매겨짐
        int evenPos = 0, oddPos = 0, evenCnt = 0, oddCnt = 0;

        // 원소간의 간격이 달라지는 index 찾기
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i) % 2 == 0) { // index가 짝수
                evenCnt++; // 짝수일 때 카운트 (홀수 혹은 짝수가 1일 때를 위해)
                evenPos = i; // 마지막 위치 저장
            } else {
                oddCnt++;
                oddPos = i;
            }
        }

        // 홀짝 카운트가 1이면 그 위치가 범인이기 때문에 index에 저장
        if (evenCnt == 1) {
            index += evenPos;
        } else if (oddCnt == 1){
            index += oddPos;
        }

        return index;
    }

    public static void main(String[] args) throws IOException {
        List<Integer> list = new ArrayList<>();

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        int n = Integer.parseInt(br.readLine());
        StringTokenizer st = new StringTokenizer(br.readLine(), " ");

        for (int i = 0; i < n; i++) {
            list.add(Integer.parseInt(st.nextToken()));
        }

        // output
        System.out.print(solution(list));

        br.close();
    }
}
```