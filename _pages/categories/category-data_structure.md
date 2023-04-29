---
title: "data-structure"
layout: category
permalink: /categories/data-structure/
author_profile: true
taxonomy: data-structure
sidebar:
  nav: "categories"
---

{% assign posts = site.categories.data-structure %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}