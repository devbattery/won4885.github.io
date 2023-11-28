---
title: "2023 Year"
layout: category
permalink: /2023-year/
author_profile: true
taxonomy: 2023 Year
sidebar:
  nav: "categories"
---

{% assign posts = site.categories.2023-year %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}
