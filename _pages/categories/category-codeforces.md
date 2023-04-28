---
title: "Codeforces"
layout: category
permalink: /categories/codeforces/
author_profile: true
taxonomy: Codeforces
sidebar:
  nav: "categories"
---

{% assign posts = site.categories.codeforces %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}