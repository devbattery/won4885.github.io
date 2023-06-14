---
title: "Computer Science"
layout: category
permalink: /cs/
author_profile: true
taxonomy: CS
---

{% assign posts = site.categories.cs %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}