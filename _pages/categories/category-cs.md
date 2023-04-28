---
title: "CS"
layout: category
permalink: /categories/cs/
author_profile: true
taxonomy: CS
sidebar:
  nav: "categories"
---

{% assign posts = site.categories.cs %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}