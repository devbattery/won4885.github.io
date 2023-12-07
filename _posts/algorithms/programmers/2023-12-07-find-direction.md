---
title: "[Programmers] 길 찾기 게임 (Python)"
excerpt: "algorithms, python, 2019 KAKAO BLIND RECRUITMENT"

categories:
  - Programmers
tags:
  - [algorithms, python, 2019 KAKAO BLIND RECRUITMENT]

toc: true
toc_sticky: true

sidebar:
  nav: "categories"

date: 2023-12-07
last_modified_at: 2023-12-07
---

- TODO: Java로 다시 풀어보자

<br>

## Solution

```python
import sys

sys.setrecursionlimit(10000)


class Node:

    def __init__(self, x, y, index):
        self.x = x
        self.y = y
        self.index = index
        self.left = None
        self.right = None


class BinaryTree:

    def __init__(self):
        self.root = None
        self.pre_answer = []
        self.post_answer = []

    def insert(self, parent_node, current_node):
        if parent_node is None:
            parent_node = current_node

        # 단순하게 x 좌표 비교니까 당연한 거임
        if current_node.x < parent_node.x:
            parent_node.left = self.insert(parent_node.left, current_node)
        elif current_node.x > parent_node.x:
            parent_node.right = self.insert(parent_node.right, current_node)

        return parent_node

    def create(self, node_list):
        for node in node_list:
            self.root = self.insert(self.root, node)

    def preorder(self, current_node):
        self.pre_answer.append(current_node.index)

        if current_node.left:
            self.preorder(current_node.left)

        if current_node.right:
            self.preorder(current_node.right)

    def postorder(self, current_node):
        if current_node.left:
            self.postorder(current_node.left)

        if current_node.right:
            self.postorder(current_node.right)

        self.post_answer.append(current_node.index)


def solution(nodeinfo):
    # 이건 왜 안 될까?
    new_nodeinfo = []
    for i, node in enumerate(nodeinfo):
        current_x, current_y = node[0], node[1]
        new_nodeinfo.append([current_x, current_y, i + 1])

    # -x[1]: y좌표(깊이)를 내림차순
    new_nodeinfo.sort(key=lambda x: -x[1])

    node_list = []
    for x, y, index in new_nodeinfo:
        node_list.append(Node(x, y, index))

    tree = BinaryTree()
    tree.create(node_list)
    tree.preorder(tree.root)
    tree.postorder(tree.root)

    return [tree.pre_answer, tree.post_answer]


print(solution([[5, 3], [11, 5], [13, 3], [3, 5], [6, 1], [1, 3], [8, 6], [7, 2], [2, 2]]))
```

<br>

## Reference

- [https://school.programmers.co.kr/learn/courses/30/lessons/42892](https://school.programmers.co.kr/learn/courses/30/lessons/42892)
