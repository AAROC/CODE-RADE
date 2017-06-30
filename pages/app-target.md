---
layout: page-fullwidth
permalink: "/app-target/"
header:
  title: "Build Targets"
  image_fullwidth: "tumblr_o1ulvtxCMk1sfie3io1_1280.jpg"
show_meta: true
---

# CODE-RADE is cross-platform

A distibuted computing environment is characterised by a high degree of heterogeneity. It is impossible to predict with certainty in which kind of an environment a  user will want to execute a particular application. One way to address this issue is to encapsulate the execution environment and separate it from the rest of the infrastructure, _i.e_ **contain** the application within it's environment. Another approach is to build and test in as many environments as possible, and distribute the resulting builds. These approaches are not mutually exclusive and CODE-RADE can handle both.

# What defines a target ?

Execution environments are defined by both software and hardware characteristics. Computers can be complex machines with several components which define their behaviour, which is even further complicated when they are combined into compute _clusters_. Whilst there are several variables representing the different kinds of computer hardware which may be present at a compute resource, these may be abstracted into general _patterns_ of compute resources. Even if the hardware is similar
