---
title: "Java"
layout: category
permalink: /java/
author_profile: true
taxonomy: Java
---

{% assign posts = site.categories.java %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}