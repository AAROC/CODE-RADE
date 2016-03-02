---
layout: page-fullwidth
meta_title: "Overview of the project"
permalink: "/overview/"
header:
  image_fullwidth: /overview.jpg
  title: "Overview"
---

# The big picture

The use of computing for research has become nearly ubiquitous. There are few fields of research in which access to a piece of software is not necessary in order to answer the questions posed by the study at hand. At the same time, computing platforms have evolved and diverged to create a rich ecosystem of HPC, grid and cloud systems. Maintaining and deploying the software that is needed to satisfy the needs of diverse research communities on these differing platforms can become a very difficult task, putting strain on the local site administrators and leading to large barriers to entry for new users.

## The two-way window

CODE-RADE is designed to provide a transparent, trusted bridge between computing infrastructures and research comunities, by automating and testing the compilation and configuration of commonly-used research applications. Using concepts and tools from continuous integration, software is built modularly, using code contributed by the communities which support their own applications. Tests are performed on servers which *simulate* a production environment. The characteristics of these environments are provided by the owners of the resources - the site administrators. By simulating the environment which applicaitons will run in, and executing functional tests in these environments, users can ensure that their applications will execute on the target sites. **CODE-RADE thus solves the issue of porting applications to various target architectures** in a more robust and repeatable way.

## Continuous delivery

Once ported and tested,
