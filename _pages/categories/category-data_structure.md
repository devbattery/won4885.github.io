---
title: "Data Structure"
layout: category
permalink: /categories/data_structure/
author_profile: true
taxonomy: Data Structure
sidebar:
  nav: "categories"
---

{% assign posts = site.categories.data_structure %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}