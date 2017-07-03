---
#
# Use the widgets beneath and the content will be
# inserted automagically in the webpage. To make
# this work, you have to use › layout: frontpage
#
layout: frontpage
header:
  image_fullwidth: frontpage-splash.jpg

widget1:
  title: "Overview of the project"
  url: '/overview'
  image: overview.jpg
  text: 'Not sure what this is all about or how you even got here ? Read this first'
widget2:
  title: "Quickstart for Users"
  url: '/getting-started-user'
  text: 'For the impatient user'
  image: header_roadmap_2.jpg
widget3:
  title: "Quickstart for providers"
  url: '/site-admin-quickstart/'
  image: sites.jpg
  text: 'How to provide CODE-RADE at your grid, cloud or HPC site.'
permalink: /index.html
---
<div id="header-home">
    <div class="row">
        <div class="small-12 columns">
        </div><!-- /.medium-4.columns -->
    </div><!-- /.row -->
</div><!-- /#header-home -->

<div id="videoModal" class="reveal-modal large" data-reveal="">
  <div class="flex-video widescreen vimeo" style="display: block;">
    <iframe width="1280" height="720" src="https://www.youtube.com/embed/3b5zCFSmVvU" frameborder="0" allowfullscreen></iframe>
  </div>
  <a class="close-reveal-modal">&#215;</a>
</div>
