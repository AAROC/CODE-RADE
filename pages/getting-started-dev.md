---
layout: page
show_meta: false
title: "Developer Quickstart"
header:
  image_soon: true
  image_fullwidth: "header_unsplash_5.jpg"
permalink: "/getting-started-dev/"
---

# Want in ?

CORE-RADE was initially developed in response to the high barrier to entry for bringing new applications to the grid - instead of site administrators responding to user requests, CODE-RADE tries to put those who need or want new applicaitons in the driver's seat. If you are supporting an application for a community, or are writing your own application - or just want an existing application integrated, with just a few simple steps, you will be able to drive this process yourself.

## Roles

CODE-RADE recognises the roles of a few actors in the procedure of porting new applications :

  * Research Software Engineer (RSE): the human being which is requesting the new application
  * Infrastructure Expert : the human being responsible for defining the tests necessary for the application to pass in order to run on the sites
  * Infastructure Operations : the human being responsible for operations at a site.
  * Jenkins : the robot responsible for executing and reporting on tests and integration.

CODE-RADE is a mostly a conversation between RSE and Infrastructure Expert, with Jenkins as an impartial intermediary, leaving the Infratructure Operations to get on with their job and focus on maintaining properly-functioning services.

## Procedural overview

The process of integrating applications is triggered by a user request. From then on, as few manual operations as possible are required before the application is integrated into the repository and automatically delivered to the sites. The rough outline of the procedure is :

  1. First contact
    1. Responsible : RSE

# First-contact : Request

If the application that you want is not already integrated (see [the list of applications]({{ site.url }}/applications)) :
<div class="row"><i class="fa fa-hand-o-right"></i> <a href="https://github.com/AAROC/CODE-RADE/issues/new?labels=proposed">Open a Request Ticket</a></div>
Be sure to provide :

  1. *Name and domain of the application* (_e.g._ : "NAMD, Chemistry")
  2. *URL of the source*. Preferably a tarball of a release version of the code, but other options are the url of the source code repository (_e.g._ git, svn repo), or a private copy of the code, if the license permits.
  3. *List of dependencies*. It would also help if the _required_ dependencies and _optional_ dependencies are explicitly stated. Be clear about what _you_ need for your particular use case.
  4. *Configuration and compilation options*. Is there some special trick to building this application _just right_ for your needs ?
  5. *Expected target architecture*, if any. We build for as many [target architectures](/app-target) as we can test for, but it would be nice if you could tell us if you have a favourite.
