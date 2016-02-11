---
layout: page
title: "Contact"
meta_title: "Contact and use our contact form"
subheadline: "Get in touch"
teaser: ""
permalink: "/contact/"
---

<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
          Contact Coordinator
        </a>
      </h4>
    </div>
    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">
        For general enquiries, comment or feedback, please contact the Africa-Arabia Regional Operations Centre Coordination team
        <form action="//formspree.io/brucellino@gmail.com" method="POST">
          <input type="hidden" name="_next" value="//{{ site_url }}/">
          <input type="text" name="_gotcha" style="display:none" />
          <div class="form-group">
            <label for="exampleInputEmail1">Full Name</label>
            <input type="text" class="form-control" name="name" id="inputName" placeholder="Jane Doe">
          </div>
          <div class="form-group">
            <label class="control-label" for="emailAddress">Email Address</label>
            <input type="email" class="form-control" name="emailAddress" id="inputEmail" placeholder="jane.doe@example.com">
            <span class="fa fa-check-square-o form-control-feedback" aria-hidden="true" id="inputEmail"></span>
            <span id="inputEmail" class="sr-only">(success)</span>
          </div>
          <span class="fa fa-check-square-o form-control-feedback" aria-hidden="true"></span>
          <span id="inputGroupSuccess2Status" class="sr-only">(success)</span>

          <div class="form-group">
            <label for="message">Your Message</label>
            <textarea type="text" class="form-control" name="Message" id="inputText" rows="3" placeholder="So, what's on your mind ?"></textarea>
          </div>

          <!-- <div class="form-group">
            <label class="checkbox">
              <input type="checkbox" id="inlineCheckbox1" value="JoinGrid"> Site interested in joining the grid
            </label>
            <label class="checkbox">
              <input type="checkbox" id="inlineCheckbox2" value="Research"> Interested in the grid for research purposes
            </label>
            <label class="checkbox">
              <input type="checkbox" id="inlineCheckbox3" value="Developer">Interested in collaborating on technical project
            </label>
            <label class="checkbox">
              <input type="checkbox" id="inlineCheckbox3" value="Proposal">Want to propose a project on the grid.
            </label>
          </div> -->
          <button type="submit" class="btn btn-default">Submit</button>
          You will be taken back to the front page
        </form>
      </div>
    </div>
  </div>
</div>
